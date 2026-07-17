-- ============================================================================
-- 👻 KILLER HUB UNIVERSAL FRAMEWORK | OBSIDIAN ULTRA PREMIUM EDITION (V4.3.0)
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ⚡ FAST-PATH LOCALS (caché de funciones matemáticas/color de uso frecuente en Luau,
-- evita resoluciones de tabla globales repetidas durante el arrastre del Color Picker)
local mathClamp = math.clamp
local mathRound = math.round
local stringFormat = string.format
local color3FromHSV = Color3.fromHSV
local color3FromRGB = Color3.fromRGB
local color3ToHSV = Color3.toHSV

-- 🛠 ANTI-CRASH UNIVERSAL INTEGRADO (GetSafeUIParent)
local function GetSafeUIParent()
    local success, result = pcall(function()
        if gethui then return gethui() end
        local coreGui = game:GetService("CoreGui")
        if coreGui and coreGui.Name then return coreGui end
    end)
    if success and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local TargetParent = GetSafeUIParent()

if TargetParent:FindFirstChild("KillerHub_Universal") then
    TargetParent.KillerHub_Universal:Destroy()
end

local Themes = {
    ["Obsidian"] = {
        BG_MAIN = Color3.fromRGB(8, 8, 10),
        BG_SIDEBAR = Color3.fromRGB(4, 4, 5),
        BG_SECONDARY = Color3.fromRGB(16, 16, 20),
        ACCENT = Color3.fromRGB(222, 222, 222),
        PREMIUM_GOLD = Color3.fromRGB(255, 196, 0),
        TEXT_WHITE = Color3.fromRGB(255, 255, 255),
        TEXT_MUTED = Color3.fromRGB(130, 130, 135),
        BORDER = Color3.fromRGB(20, 0, 40)
    },
    ["Void Premium"] = {
        BG_MAIN = Color3.fromRGB(8, 5, 12),
        BG_SIDEBAR = Color3.fromRGB(11, 8, 16),
        BG_SECONDARY = Color3.fromRGB(15, 11, 22),
        ACCENT = Color3.fromRGB(138, 43, 226),
        PREMIUM_GOLD = Color3.fromRGB(255, 215, 0),
        TEXT_WHITE = Color3.fromRGB(245, 240, 255),
        TEXT_MUTED = Color3.fromRGB(130, 115, 145),
        BORDER = Color3.fromRGB(40, 0, 80)
    },
    ["Midnight Emerald"] = {
        BG_MAIN = Color3.fromRGB(10, 12, 11),
        BG_SIDEBAR = Color3.fromRGB(13, 16, 14),
        BG_SECONDARY = Color3.fromRGB(16, 22, 18),
        ACCENT = Color3.fromRGB(0, 230, 115),
        PREMIUM_GOLD = Color3.fromRGB(255, 200, 50),
        TEXT_WHITE = Color3.fromRGB(245, 245, 245),
        TEXT_MUTED = Color3.fromRGB(130, 140, 130),
        BORDER = Color3.fromRGB(28, 38, 32)
    },
    ["Classic Dark"] = {
        BG_MAIN = Color3.fromRGB(15, 15, 15),
        BG_SIDEBAR = Color3.fromRGB(20, 20, 20),
        BG_SECONDARY = Color3.fromRGB(25, 25, 25),
        ACCENT = Color3.fromRGB(245, 245, 245),
        PREMIUM_GOLD = Color3.fromRGB(255, 180, 0),
        TEXT_WHITE = Color3.fromRGB(245, 245, 245),
        TEXT_MUTED = Color3.fromRGB(130, 130, 130),
        BORDER = Color3.fromRGB(40, 40, 40)
    },
    ["Sakura Blossom"] = {
        BG_MAIN = Color3.fromRGB(16, 12, 14),
        BG_SIDEBAR = Color3.fromRGB(20, 15, 18),
        BG_SECONDARY = Color3.fromRGB(26, 20, 24),
        ACCENT = Color3.fromRGB(255, 143, 163),
        PREMIUM_GOLD = Color3.fromRGB(255, 210, 120),
        TEXT_WHITE = Color3.fromRGB(255, 240, 243),
        TEXT_MUTED = Color3.fromRGB(150, 120, 128),
        BORDER = Color3.fromRGB(50, 30, 38)
    },
    ["Blood"] = {
        BG_MAIN = Color3.fromRGB(10, 10, 10),
        BG_SIDEBAR = Color3.fromRGB(14, 12, 12),
        BG_SECONDARY = Color3.fromRGB(18, 14, 14),
        ACCENT = Color3.fromRGB(185, 15, 15),
        PREMIUM_GOLD = Color3.fromRGB(255, 170, 40),
        TEXT_WHITE = Color3.fromRGB(255, 255, 255),
        TEXT_MUTED = Color3.fromRGB(135, 105, 105),
        BORDER = Color3.fromRGB(46, 20, 20)
    }
}

local CurrentTheme = Themes["Obsidian"]

-- 📂 CARPETA DEDICADA + SEGMENTACIÓN AUTOMÁTICA POR PLACE ID (multi-juego)
-- Cada experiencia de Roblox obtiene su propio JSON: Core_<PlaceId>.json.
-- Así el usuario nunca "arrastra" ajustes de un juego a otro y no se corrompen
-- perfiles entre experiencias con nombres de flag compartidos.
local CONFIG_FOLDER = "KillerHub_Config"
local CURRENT_PLACE_ID = tostring(game.PlaceId or 0)
local CONFIG_FILE = CONFIG_FOLDER .. "/Core_" .. CURRENT_PLACE_ID .. ".json"
-- 🧷 Ruta legacy conservada para migración transparente (una sola vez) desde V4.2
local LEGACY_CONFIG_FILE = CONFIG_FOLDER .. "/Core_Config.json"

pcall(function()
    if isfolder and makefolder and not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end)

local DefaultConfig = {
    Volume = 0.5, ToggleKey = "RightControl", SelectedTheme = "Obsidian", SelectedFont = "GothamMedium",
    GuiWidth = 0.466, GuiHeight = 0.4, UiOpacity = 0.75, ToggleBtnSize = 46,
    MainFrameX = 0, MainFrameY = 0, BtnX = 15, BtnY = 100
}
local Config = {} 
local Flags = {}
local Connections = {}

local function connect(event, callback)
    local conn = event:Connect(callback)
    table.insert(Connections, conn)
    return conn
end

local function copyTable(target, source)
    for k, v in pairs(source) do
        if type(v) == "table" then target[k] = {} copyTable(target[k], v) else target[k] = v end
    end
end
copyTable(Config, DefaultConfig)

-- 🩹 AUTOGUARDADO: dos capas de protección.
-- 1) Debounce de escritura: saveConfig() se llama en cada muestra de arrastre de
--    sliders/keybinds/toggles (varias veces por frame). Antes solo el Color Picker
--    protegía esto con su propio "requestSave"; el resto golpeaba writefile() en
--    cada pixel de movimiento (I/O real -> microstutter / throttling del executor).
--    Ahora el debounce vive en la fuente: colapsa cualquier ráfaga del mismo
--    resumption cycle en un solo writefile, sin cambiar la firma de la función.
-- 2) pcall en cada paso (encode y write por separado): si el JSON.Encode falla
--    por lo que sea, o el executor lanza el write, no se rompe el hub ni se deja
--    un archivo a medio escribir con basura.
local pendingConfigSave = false
local function saveConfig()
    if pendingConfigSave then return end
    pendingConfigSave = true
    task.defer(function()
        pendingConfigSave = false
        if not writefile then return end
        local encodeOk, encoded = pcall(function() return HttpService:JSONEncode(Config) end)
        if encodeOk and encoded then
            pcall(function() writefile(CONFIG_FILE, encoded) end)
        end
    end)
end

-- 🩹 CARGA BLINDADA: si el archivo no existe, está corrupto, o el JSON no es
-- una tabla válida (por ejemplo porque otro script escribió algo raro ahí, o
-- el archivo quedó truncado a medias), simplemente se ignora y se usan los
-- valores por defecto en vez de romper el :Init() de todo el hub.
pcall(function()
    local target = CONFIG_FILE
    -- 🔁 Migración transparente: si aún no existe el archivo por PlaceId pero sí
    -- el archivo legacy V4.2 ("Core_Config.json"), se toma como base sin romper nada.
    if isfile and readfile then
        if not isfile(CONFIG_FILE) and isfile(LEGACY_CONFIG_FILE) then
            target = LEGACY_CONFIG_FILE
        end
        if isfile(target) then
            local readOk, raw = pcall(readfile, target)
            if readOk and raw and #raw > 0 then
                local decodeOk, data = pcall(function() return HttpService:JSONDecode(raw) end)
                if decodeOk and type(data) == "table" then
                    for k, v in pairs(data) do Config[k] = v end
                end
            end
        end
    end
end)

if Themes[Config.SelectedTheme] then CurrentTheme = Themes[Config.SelectedTheme] end

local function create(instanceType, properties, parent)
    local obj = Instance.new(instanceType)
    for prop, val in pairs(properties) do obj[prop] = val end
    if parent then obj.Parent = parent end
    return obj
end

-- 🛠 UTILERÍAS EXTRA DE SEGURIDAD Y MENÚ
local function getSafeColor(flagName, defaultColor)
    local val = Config[flagName]
    if type(val) == "table" then
        local r = tonumber(val[1] or val["1"]) or defaultColor.R
        local g = tonumber(val[2] or val["2"]) or defaultColor.G
        local b = tonumber(val[3] or val["3"]) or defaultColor.B
        return Color3.new(r, g, b)
    end
    return defaultColor
end

local function setTabScrolling(element, enabled)
    local parent = element.Parent
    while parent do
        if parent:IsA("ScrollingFrame") and parent.Name ~= "SidebarTabsContainer" then
            parent.ScrollingEnabled = enabled
            break
        end
        parent = parent.Parent
    end
end

-- ============================================================================
-- 🖥 INTERFAZ CON CANVASGROUP DE ALTO RENDIMIENTO
-- ============================================================================
local ScreenGui = create("ScreenGui", {Name = "KillerHub_Universal", IgnoreGuiInset = false, ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets, ResetOnSpawn = false, DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, TargetParent)

local function playUISound()
    if not Config.Volume or Config.Volume <= 0 then return end
    pcall(function()
        local sound = create("Sound", {SoundId = "rbxassetid://101735926591481", Volume = Config.Volume}, ScreenGui)
        sound:Play() 
        Debris:AddItem(sound, 1.5)
    end)
end

local MainFrame = create("CanvasGroup", {Name = "MainFrame", BackgroundColor3 = CurrentTheme.BG_MAIN, BorderSizePixel = 0, Active = true, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, Config.MainFrameX or 0, 0.5, Config.MainFrameY or 0)}, ScreenGui)
local MainStroke = create("UIStroke", {Thickness = 1.5, Color = CurrentTheme.BORDER, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, MainFrame)
create("UICorner", {CornerRadius = UDim.new(0, 12)}, MainFrame)

local BordeGradient = create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CurrentTheme.BORDER),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
    }), Rotation = 45
}, MainStroke)

local gradientRotationConn = RunService.RenderStepped:Connect(function(dt)
    if BordeGradient and MainFrame.Visible then
        BordeGradient.Rotation = (BordeGradient.Rotation + (15 * dt)) % 360
    end
end)
table.insert(Connections, gradientRotationConn)

local function updateGuiSize()
    if MainFrame.Visible then
        MainFrame.Size = UDim2.new(0, math.floor(430 + ((Config.GuiWidth or 0.466) * 280)), 0, math.floor(280 + ((Config.GuiHeight or 0.4) * 230)))
    end
end

local Topbar = create("Frame", {Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Color3.fromRGB(4, 4, 5), BorderSizePixel = 0, Active = true, ClipsDescendants = true}, MainFrame)
create("UICorner", {CornerRadius = UDim.new(0, 12)}, Topbar)

local Title = create("TextLabel", {Size = UDim2.new(0, 250, 1, 0), Position = UDim2.new(0, 18, 0, 0), BackgroundTransparency = 1, Text = "Killer Hub | By Paolo", TextColor3 = CurrentTheme.TEXT_WHITE, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextSize = 14}, Topbar)
local DecorLine = create("Frame", {Size = UDim2.new(0, 60, 0, 2.5), Position = UDim2.new(0, 18, 1, -2), BackgroundColor3 = CurrentTheme.ACCENT, BorderSizePixel = 0}, Topbar)
local PerformanceLabel = create("TextLabel", {Size = UDim2.new(0, 160, 1, 0), Position = UDim2.new(1, -15, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = "FPS: -- | PING: --", TextColor3 = CurrentTheme.TEXT_MUTED, TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.GothamMedium, TextSize = 11}, Topbar)

local fpsTimer = 0
local frameCounter = 0
local perfConn = RunService.Heartbeat:Connect(function(dt)
    fpsTimer = fpsTimer + dt
    frameCounter = frameCounter + 1
    if fpsTimer >= 1 then
        local currentFps = frameCounter
        frameCounter = 0
        fpsTimer = 0
        local ping = 0
        pcall(function()
            if Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerToClientPing") then
                ping = math.floor(Stats.Network.ServerToClientPing:GetValue())
            else
                ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            end
        end)
        PerformanceLabel.Text = string.format("FPS: %d | PING: %dms", currentFps, ping)
    end
end)
table.insert(Connections, perfConn)

-- 🛡️ ARRASTRE SIN ERRORES MULTI-TOUCH EN MÓVILES
local function makeDraggable(clickObject, dragObject)
    local dragging, dragStart, startPos, activeInput
    local moveConn, endConn
    
    connect(clickObject.InputBegan, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragging then
            dragging = true 
            activeInput = input 
            dragStart = input.Position 
            startPos = dragObject.Position
            
            moveConn = connect(UserInputService.InputChanged, function(changedInput)
                if dragging and (changedInput == activeInput) then
                    task.defer(function()
                        if not dragging then return end
                        local delta = changedInput.Position - dragStart
                        local screenSize = Camera.ViewportSize
                        if dragObject.Name == "MainFrame" then
                            local frameSize = dragObject.AbsoluteSize
                            local absoluteX = (screenSize.X * 0.5) + (startPos.X.Offset + delta.X)
                            local absoluteY = (screenSize.Y * 0.5) + (startPos.Y.Offset + delta.Y)
                            local clampedX = math.clamp(absoluteX, frameSize.X / 2, screenSize.X - (frameSize.X / 2))
                            local clampedY = math.clamp(absoluteY, frameSize.Y / 2, screenSize.Y - (frameSize.Y / 2))
                            dragObject.Position = UDim2.new(0.5, clampedX - (screenSize.X * 0.5), 0.5, clampedY - (screenSize.Y * 0.5))
                        else
                            local btnSize = dragObject.AbsoluteSize
                            local newX = math.clamp(startPos.X.Offset + delta.X, 0, screenSize.X - btnSize.X)
                            local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, screenSize.Y - btnSize.Y)
                            dragObject.Position = UDim2.new(0, newX, 0, newY)
                        end
                    end)
                end
            end)
            
            endConn = connect(UserInputService.InputEnded, function(endedInput)
                if endedInput == activeInput then
                    dragging = false 
                    activeInput = nil
                    if moveConn then moveConn:Disconnect() moveConn = nil end
                    if endConn then endConn:Disconnect() end
                    if dragObject.Name == "MainFrame" then
                        Config.MainFrameX = dragObject.Position.X.Offset
                        Config.MainFrameY = dragObject.Position.Y.Offset
                        saveConfig()
                    elseif dragObject.Name == "KillerHubToggle" then
                        Config.BtnX = dragObject.Position.X.Offset
                        Config.BtnY = dragObject.Position.Y.Offset
                        saveConfig()
                    end
                end
            end)
        end
    end)
end

makeDraggable(Topbar, MainFrame)

local Sidebar = create("Frame", {Name = "Sidebar", Size = UDim2.new(0, 125, 1, -45), Position = UDim2.new(0, 0, 0, 45), BackgroundColor3 = CurrentTheme.BG_SIDEBAR, BorderSizePixel = 0, Active = true}, MainFrame)
local SidebarLine = create("Frame", {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = Color3.fromRGB(30, 30, 35), BorderSizePixel = 0}, Sidebar)

local SearchBoxContainer = create("Frame", {Size = UDim2.new(1, -12, 0, 26), Position = UDim2.new(0, 6, 0, 8), BackgroundColor3 = CurrentTheme.BG_SECONDARY}, Sidebar)
create("UICorner", {CornerRadius = UDim.new(0, 6)}, SearchBoxContainer)
local SearchStroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(35, 35, 40)}, SearchBoxContainer)

local SearchInput = create("TextBox", {Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, PlaceholderText = "Buscar...", PlaceholderColor3 = CurrentTheme.TEXT_MUTED, Text = "", TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, ClearTextOnFocus = false}, SearchBoxContainer)

local SidebarTabsContainer = create("ScrollingFrame", {Size = UDim2.new(1, 0, 1, -85), Position = UDim2.new(0, 0, 0, 38), BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), ScrollingDirection = Enum.ScrollingDirection.Y, BorderSizePixel = 0}, Sidebar)
local tabsLayout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, SidebarTabsContainer)
create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, SidebarTabsContainer)

local tabsSizeConn = tabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SidebarTabsContainer.CanvasSize = UDim2.new(0, 0, 0, tabsLayout.AbsoluteContentSize.Y + 10)
end)
table.insert(Connections, tabsSizeConn)

local SettingsContainer = create("Frame", {Size = UDim2.new(1, -12, 0, 36), Position = UDim2.new(0, 6, 1, -42), BackgroundTransparency = 1}, Sidebar)
local ContentContainer = create("Frame", {Name = "ContentContainer", Size = UDim2.new(1, -125, 1, -45), Position = UDim2.new(0, 125, 0, 45), BackgroundTransparency = 1, Active = true}, MainFrame)

local OpenCloseBtn = create("TextButton", {Name = "KillerHubToggle", Size = UDim2.new(0, 46, 0, 46), Position = UDim2.new(0, Config.BtnX or 15, 0, Config.BtnY or 100), BackgroundColor3 = CurrentTheme.BG_MAIN, Text = "", Active = true}, ScreenGui)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, OpenCloseBtn)
local FloatingStroke = create("UIStroke", {Thickness = 1.5, Color = CurrentTheme.BORDER}, OpenCloseBtn)
local BtnIcon = create("ImageLabel", {Name = "Icon", Size = UDim2.new(1, 0, 1, 0), ScaleType = Enum.ScaleType.Crop, BackgroundTransparency = 1, Image = "rbxassetid://84689030731870", ImageColor3 = CurrentTheme.ACCENT}, OpenCloseBtn)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, BtnIcon)

makeDraggable(OpenCloseBtn, OpenCloseBtn)

local function updateUiOpacity()
    local opacity = Config.UiOpacity or 0.75
    if MainFrame.Visible then
        MainFrame.BackgroundTransparency = 1 - opacity
    end
    Topbar.BackgroundTransparency = math.clamp((1 - opacity) + 0.1, 0, 0.95)
    Sidebar.BackgroundTransparency = math.clamp((1 - opacity) + 0.05, 0, 0.95)
end

local function updateButtonSize()
    local s = Config.ToggleBtnSize or 46
    OpenCloseBtn.Size = UDim2.new(0, s, 0, s)
end

MainFrame.Size = UDim2.new(0, math.floor(430 + ((Config.GuiWidth or 0.466) * 280)), 0, math.floor(280 + ((Config.GuiHeight or 0.4) * 230)))
updateUiOpacity()
updateButtonSize()

local menuVisible = true
local function setMenuVisibility(visible)
    menuVisible = visible
    BtnIcon.ImageColor3 = visible and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE
    
    if visible then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            GroupTransparency = 0
        }):Play()
    else
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            GroupTransparency = 1
        })
        closeTween.Completed:Connect(function()
            if not menuVisible then MainFrame.Visible = false end
        end)
        closeTween:Play()
    end
end

connect(OpenCloseBtn.MouseButton1Click, function() playUISound() setMenuVisibility(not menuVisible) end)

connect(UserInputService.InputBegan, function(input, gp)
    if not gp and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == (Config.ToggleKey or "RightControl") then
        playUISound() setMenuVisibility(not menuVisible)
    end
end)

local activeTweens = setmetatable({}, {__mode = "k"})

-- 🩹 BUG FIX (revert visual del Color Picker): antes, addInteractiveFeedback() guardaba
-- "baseColor" UNA SOLA VEZ al crear el botón. Cualquier color elegido después en el
-- Color Picker (ColorBtn) quedaba aplicado de verdad en Config/Flags, pero al sacar el
-- mouse del cuadrito (MouseLeave, típicamente al cerrar el menú) el tween de "hover
-- feedback" regresaba el BackgroundColor3 a ese snapshot viejo, dando la falsa
-- impresión de que el color (o el guardado) no se había aplicado.
-- InteractiveBaseColor guarda el color "real" vigente de cada botón y se mantiene
-- sincronizado vía setSwatchColor() cada vez que el color picker asigna un color de verdad.
local InteractiveBaseColor = setmetatable({}, {__mode = "k"})

local function setSwatchColor(inst, color)
    inst.BackgroundColor3 = color
    InteractiveBaseColor[inst] = color
end

local function addInteractiveFeedback(inst)
    if not inst:IsA("TextButton") then return end
    InteractiveBaseColor[inst] = InteractiveBaseColor[inst] or inst.BackgroundColor3

    connect(inst.MouseEnter, function()
        if activeTweens[inst] then activeTweens[inst]:Cancel() end
        local base = InteractiveBaseColor[inst] or inst.BackgroundColor3
        activeTweens[inst] = TweenService:Create(inst, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
            BackgroundColor3 = base:Lerp(Color3.fromRGB(255, 255, 255), 0.08)
        })
        activeTweens[inst]:Play()
    end)
    connect(inst.MouseLeave, function()
        if activeTweens[inst] then activeTweens[inst]:Cancel() end
        local base = InteractiveBaseColor[inst] or inst.BackgroundColor3
        activeTweens[inst] = TweenService:Create(inst, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
            BackgroundColor3 = base
        })
        activeTweens[inst]:Play()
    end)
end

-- ============================================================================
-- 📦 API CORE Y MOTOR REACTIVO (ATRIBUTOS DE ARQUITECTURA)
-- ============================================================================
local KillerHub = {
    Tabs = {}, Frames = {}, Buttons = {}, Config = Config, Flags = Flags,
    CurrentTab = nil, AllElements = {}, TargetThemeElements = {}, _Trash = {},
    Elements = {}, TabRegistry = {} -- caché {Frame,Btn,Label,Icon,Line} por pestaña: evita FindFirstChild en cada click
}

-- ============================================================================
-- 💎 SISTEMA PREMIUM DE NOTIFICACIONES DINÁMICAS
-- ============================================================================
local NotifContainer = create("Frame", {
    Name = "NotificationContainer",
    Size = UDim2.new(0, 240, 1, -20),
    Position = UDim2.new(1, -250, 0, 10),
    BackgroundTransparency = 1
}, ScreenGui)
local NotifLayout = create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    VerticalAlignment = Enum.VerticalAlignment.Bottom
}, NotifContainer)

-- 🛡️ TOPE DE NOTIFICACIONES APILADAS: si algo (o alguien) llama a Notify() en ráfaga,
-- esto evita que se acumulen decenas de frames en pantalla comiéndose memoria/GPU;
-- simplemente cierra la más vieja antes de abrir una nueva por encima del límite.
local MAX_ACTIVE_NOTIFS = 5
local ActiveNotifs = {}

function KillerHub:Notify(title, text, duration, customColor)
    duration = duration or 4
    local accentColor = customColor or CurrentTheme.ACCENT

    if #ActiveNotifs >= MAX_ACTIVE_NOTIFS then
        local oldest = table.remove(ActiveNotifs, 1)
        if oldest and oldest.Parent then pcall(function() oldest:Destroy() end) end
    end

    local NotifFrame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = CurrentTheme.BG_MAIN,
        BackgroundTransparency = 0.1,
        ClipsDescendants = true
    }, NotifContainer)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, NotifFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, NotifFrame)
    
    local Line = create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0
    }, NotifFrame)
    
    local Tl = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = CurrentTheme.TEXT_WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, NotifFrame)
    
    local Tx = create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 24),
        Position = UDim2.new(0, 10, 0, 18),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CurrentTheme.TEXT_MUTED,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, NotifFrame)

    if not customColor then
        table.insert(KillerHub.TargetThemeElements, function()
            NotifFrame.BackgroundColor3 = CurrentTheme.BG_MAIN
            Stroke.Color = CurrentTheme.BORDER
            Line.BackgroundColor3 = CurrentTheme.ACCENT
        end)
    end

    table.insert(ActiveNotifs, NotifFrame)

    TweenService:Create(NotifFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 46)}):Play()
    
    task.delay(duration, function()
        if not NotifFrame or not NotifFrame.Parent then return end
        local t = TweenService:Create(NotifFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        t.Completed:Connect(function()
            pcall(function() NotifFrame:Destroy() end)
            local idx = table.find(ActiveNotifs, NotifFrame)
            if idx then table.remove(ActiveNotifs, idx) end
        end)
        t:Play()
    end)
end

-- 🛠 DEBUGGER Y VALIDADOR INTELIGENTE (SafeAssert)
local function SafeAssert(componentName, checks)
    for paramName, checkData in pairs(checks) do
        local value = checkData.value
        local expectedTypes = checkData.types
        local match = false
        
        for _, t in ipairs(expectedTypes) do
            if typeof(value) == t then match = true break end
        end
        
        if not match then
            local expectedStr = table.concat(expectedTypes, " o ")
            local errorMsg = string.format("El parametro '%s' en '%s' debia ser [%s], pero recibio [%s].", paramName, componentName, expectedStr, typeof(value))
            warn("⚠️ [KillerHub Debugger] " .. errorMsg)
            task.spawn(function()
                KillerHub:Notify("❌ Error en Componente", errorMsg, 6, Color3.fromRGB(240, 50, 50))
            end)
            return false
        end
    end
    return true
end

-- 🛠 EXPOSICIÓN Y ACTUALIZACIÓN DINÁMICA DE FLAGS GLOBAL
local function updateGlobalFlags(flagName, value)
    Flags[flagName] = { CurrentValue = value }
    if getgenv().KillerHub then
        getgenv().KillerHub.Flags = Flags
    end
end

function KillerHub:SetPremiumIds(idTable) end

function KillerHub:SetFont(fontName)
    Config.SelectedFont = fontName
    saveConfig()
    local fontEnum = Enum.Font[fontName] or Enum.Font.GothamMedium
    for _, v in ipairs(ScreenGui:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
            v.Font = fontEnum
        end
    end
end

function KillerHub:AddTask(obj)
    table.insert(self._Trash, obj)
    return obj
end

-- 🛠 OPTIMIZACIÓN DE RENDIMIENTO GENERAL (Garbage Collection Integrado)
function KillerHub:Destroy()
    self:Unload()
end

function KillerHub:Unload()
    for _, conn in ipairs(Connections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    for _, item in ipairs(self._Trash) do
        if typeof(item) == "RBXScriptConnection" then pcall(function() item:Disconnect() end)
        elseif typeof(item) == "Instance" then pcall(function() item:Destroy() end) end
    end
    if ScreenGui then pcall(function() ScreenGui:Destroy() end) end
    
    -- Limpieza profunda de memoria
    table.clear(Connections)
    table.clear(self._Trash)
    table.clear(self.Tabs)
    table.clear(self.Frames)
    table.clear(self.Buttons)
    table.clear(self.AllElements)
    table.clear(self.TargetThemeElements)
    table.clear(self.Elements)
    
    if getgenv().KillerHub then getgenv().KillerHub = nil end
    warn("❌ KillerHub desunificado por completo y memoria liberada.")
end

function KillerHub:SetTheme(themeName)
    if not Themes[themeName] then return end
    CurrentTheme = Themes[themeName]
    Config.SelectedTheme = themeName
    saveConfig()
    
    MainFrame.BackgroundColor3 = CurrentTheme.BG_MAIN
    MainStroke.Color = CurrentTheme.BORDER
    Sidebar.BackgroundColor3 = CurrentTheme.BG_SIDEBAR
    SidebarLine.BackgroundColor3 = CurrentTheme.BORDER
    Title.TextColor3 = CurrentTheme.TEXT_WHITE
    DecorLine.BackgroundColor3 = CurrentTheme.ACCENT
    PerformanceLabel.TextColor3 = CurrentTheme.TEXT_MUTED
    SearchBoxContainer.BackgroundColor3 = CurrentTheme.BG_SECONDARY
    SearchInput.TextColor3 = CurrentTheme.TEXT_WHITE
    SearchInput.PlaceholderColor3 = CurrentTheme.TEXT_MUTED
    OpenCloseBtn.BackgroundColor3 = CurrentTheme.BG_MAIN
    FloatingStroke.Color = CurrentTheme.BORDER
    BtnIcon.ImageColor3 = menuVisible and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE
    
    BordeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CurrentTheme.BORDER),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
    })

    for _, v in ipairs(ScreenGui:GetDescendants()) do
        local role = v:GetAttribute("ThemeRole")
        if role == "BG_SECONDARY" then
            v.BackgroundColor3 = CurrentTheme.BG_SECONDARY
            local s = v:FindFirstChildWhichIsA("UIStroke") if s then s.Color = CurrentTheme.BORDER end
            local tl = v:FindFirstChildWhichIsA("TextLabel") if tl and not v:GetAttribute("CustomColorLabel") then tl.TextColor3 = CurrentTheme.ACCENT end
        elseif role == "TEXT_ACCENT" then
            v.TextColor3 = CurrentTheme.ACCENT
        end
    end
    
    for _, refreshCallback in ipairs(self.TargetThemeElements) do
        pcall(refreshCallback)
    end
    self:SetFont(Config.SelectedFont or "GothamMedium")
end

-- ============================================================================
-- 🎨 PANEL COMPARTIDO DE COLOR PICKER (Canvas SV + Hue + Preview centrado + Modo RGB)
-- Antes CreateColorPicker y CreateToggleColorPicker duplicaban ~150 líneas idénticas.
-- Se centraliza aquí: menos memoria de script, un único punto de mantenimiento,
-- y así ambos widgets comparten exactamente el mismo comportamiento y optimizaciones.
-- ============================================================================
local function BuildColorPickerPanel(MasterFrame, ColorBtn, flagColor, savedColor, contentTop, fireCallback)
    -- 🎨 CANVAS SV MÁS AMPLIO (V4.3): la previsualización cromática ahora ocupa mucha
    -- más extensión horizontal (172px vs 128px). Esto mejora drásticamente la precisión
    -- al elegir tonos claros/oscuros con el dedo o el mouse, especialmente en móvil.
    local Canvas = create("ImageLabel", {
        Position = UDim2.new(0, 12, 0, contentTop),
        Size = UDim2.new(0, 172, 0, 128),
        Image = "rbxassetid://4155801252",
        BackgroundColor3 = color3FromHSV(color3ToHSV(savedColor)),
        BorderSizePixel = 0,
        Active = true
    }, MasterFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, Canvas)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(45, 45, 50)}, Canvas)

    local SVPickerKnob = create("Frame", {Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0}, Canvas)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, SVPickerKnob)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(0, 0, 0)}, SVPickerKnob)

    local HueSlider = create("Frame", {Position = UDim2.new(0, 192, 0, contentTop), Size = UDim2.new(0, 20, 0, 128), BorderSizePixel = 0, Active = true}, MasterFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, HueSlider)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(45, 45, 50)}, HueSlider)
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Rotation = 90
    }, HueSlider)
    local HueKnob = create("Frame", {Size = UDim2.new(1, 4, 0, 4), Position = UDim2.new(0.5, -2, 0, -2), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0}, HueSlider)
    create("UICorner", {CornerRadius = UDim.new(0, 2)}, HueKnob)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(0, 0, 0)}, HueKnob)

    -- Columna derecha auto-centrada, empujada para acomodar el Canvas más ancho
    local InfoColumn = create("Frame", {Position = UDim2.new(0, 224, 0, contentTop), Size = UDim2.new(1, -236, 0, 128), BackgroundTransparency = 1}, MasterFrame)

    local PreviewFrame = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0, 58, 0, 58),
        BackgroundColor3 = savedColor
    }, InfoColumn)
    create("UICorner", {CornerRadius = UDim.new(0, 10)}, PreviewFrame)
    create("UIStroke", {Thickness = 1.5, Color = Color3.fromRGB(55, 55, 62), Transparency = 0.1}, PreviewFrame)

    local HexBox = create("TextBox", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 68),
        Size = UDim2.new(1, -8, 0, 26),
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        Text = "",
        PlaceholderText = "FFFFFF",
        PlaceholderColor3 = Color3.fromRGB(100, 105, 115),
        TextColor3 = CurrentTheme.TEXT_WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Center
    }, InfoColumn)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, HexBox)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(45, 45, 50)}, HexBox)

    -- 🌈 Toggle "Modo RGB": activa un recorrido automático de tono (arcoíris) adaptado al tema
    local RainbowRow = create("Frame", {Position = UDim2.new(0, 12, 0, contentTop + 136), Size = UDim2.new(1, -24, 0, 30), BackgroundColor3 = Color3.fromRGB(20, 20, 24), BackgroundTransparency = 0.3}, MasterFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, RainbowRow)
    local RainbowStroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, RainbowRow)
    local RainbowLabel = create("TextLabel", {Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "Modo RGB (Arcoíris)", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamMedium, TextSize = 11.5, TextXAlignment = Enum.TextXAlignment.Left}, RainbowRow)
    local RainbowBtn = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""}, RainbowRow)
    local RTrack = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -44, 0.5, -9), BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, RainbowRow)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, RTrack)
    local RKnob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, RTrack)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, RKnob)

    local h, s, v = color3ToHSV(savedColor)
    local rainbowActive = Config[flagColor .. "_Rainbow"] == true
    local rainbowConn = nil

    local pendingSave = false
    local function requestSave()
        if pendingSave then return end
        pendingSave = true
        task.defer(function() saveConfig() pendingSave = false end)
    end

    local function paintVisuals(col)
        SVPickerKnob.Position = UDim2.new(s, -6, 1 - v, -6)
        HueKnob.Position = UDim2.new(0.5, -10, h, -2)
        Canvas.BackgroundColor3 = color3FromHSV(h, 1, 1)
        PreviewFrame.BackgroundColor3 = col
        setSwatchColor(ColorBtn, col)
        if not HexBox:IsFocused() then
            HexBox.Text = stringFormat("#%02X%02X%02X", mathRound(col.R * 255), mathRound(col.G * 255), mathRound(col.B * 255))
        end
    end

    -- Guardado inmediato pero "debounced" a un solo writefile por frame,
    -- evita I/O redundante mientras se arrastra sin perder persistencia en tiempo real
    local function refreshColor(skipCallback)
        local col = color3FromHSV(h, s, v)
        Config[flagColor] = {col.R, col.G, col.B}
        updateGlobalFlags(flagColor, col)
        paintVisuals(col)
        requestSave()
        if not skipCallback then fireCallback(col) end
    end

    local function setRainbowVisual(active)
        RTrack.BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)
        RKnob.Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        RainbowLabel.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
    end

    -- ⚡ Ciclo de tono por Heartbeat con guardado y callback LIMITADOS por tiempo (throttle):
    -- sin esto, el modo arcoíris dispararía writefile()/callback ~60 veces por segundo y
    -- causaría lag; así se mantiene fluido a 60fps mientras solo persiste 1 vez/seg
    local rbSaveAcc, rbCallbackAcc = 0, 0
    local function rainbowStep(dt)
        h = (h + dt * 0.15) % 1
        local col = color3FromHSV(h, s, v)
        Config[flagColor] = {col.R, col.G, col.B}
        updateGlobalFlags(flagColor, col)
        paintVisuals(col)
        rbSaveAcc = rbSaveAcc + dt
        rbCallbackAcc = rbCallbackAcc + dt
        if rbSaveAcc >= 1 then rbSaveAcc = 0 saveConfig() end
        if rbCallbackAcc >= 0.1 then rbCallbackAcc = 0 fireCallback(col) end
    end

    local function setRainbow(active, skipSave)
        rainbowActive = active
        Config[flagColor .. "_Rainbow"] = active
        setRainbowVisual(active)
        if rainbowConn then rainbowConn:Disconnect() rainbowConn = nil end
        if active then
            rbSaveAcc, rbCallbackAcc = 0, 0
            rainbowConn = connect(RunService.Heartbeat, rainbowStep)
        elseif not skipSave then
            saveConfig()
        end
    end

    connect(RainbowBtn.MouseButton1Click, function()
        playUISound()
        setRainbow(not rainbowActive)
    end)

    local function updateSV(input)
        local pctX = mathClamp((input.Position.X - Canvas.AbsolutePosition.X) / Canvas.AbsoluteSize.X, 0, 1)
        local pctY = 1 - mathClamp((input.Position.Y - Canvas.AbsolutePosition.Y) / Canvas.AbsoluteSize.Y, 0, 1)
        s = pctX
        v = pctY
        refreshColor()
    end

    local function updateHue(input)
        local pctY = mathClamp((input.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
        h = pctY
        refreshColor()
    end

    -- Entrada Hex editable: al perder el foco (Enter o click afuera) recalcula todo
    connect(HexBox.FocusLost, function()
        local raw = HexBox.Text:gsub("#", ""):upper()
        if #raw == 6 and raw:match("^%x+$") then
            local r = tonumber(raw:sub(1, 2), 16)
            local g = tonumber(raw:sub(3, 4), 16)
            local b = tonumber(raw:sub(5, 6), 16)
            if rainbowActive then setRainbow(false) end
            h, s, v = color3ToHSV(color3FromRGB(r, g, b))
            refreshColor()
        else
            refreshColor() -- texto inválido: restaura el hex al color actual
        end
    end)

    -- Drags táctiles multi-touch independientes con control de scrolling en pestaña
    local svDragging = false
    local svActiveInput = nil
    local svDragConn, svEndConn

    connect(Canvas.InputBegan, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not svDragging then
            svDragging = true
            svActiveInput = input
            setTabScrolling(MasterFrame, false)
            updateSV(input)

            svDragConn = connect(UserInputService.InputChanged, function(changedInput)
                if svDragging and (changedInput == svActiveInput) then
                    updateSV(changedInput)
                end
            end)

            svEndConn = connect(UserInputService.InputEnded, function(endedInput)
                if endedInput == svActiveInput then
                    svDragging = false
                    svActiveInput = nil
                    setTabScrolling(MasterFrame, true)
                    saveConfig()
                    if svDragConn then svDragConn:Disconnect() svDragConn = nil end
                    if svEndConn then svEndConn:Disconnect() svEndConn = nil end
                end
            end)
        end
    end)

    local hueDragging = false
    local hueActiveInput = nil
    local hueDragConn, hueEndConn

    connect(HueSlider.InputBegan, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not hueDragging then
            hueDragging = true
            hueActiveInput = input
            if rainbowActive then setRainbow(false) end -- mover el tono a mano sale del modo automático
            setTabScrolling(MasterFrame, false)
            updateHue(input)

            hueDragConn = connect(UserInputService.InputChanged, function(changedInput)
                if hueDragging and (changedInput == hueActiveInput) then
                    updateHue(changedInput)
                end
            end)

            hueEndConn = connect(UserInputService.InputEnded, function(endedInput)
                if endedInput == hueActiveInput then
                    hueDragging = false
                    hueActiveInput = nil
                    setTabScrolling(MasterFrame, true)
                    saveConfig()
                    if hueDragConn then hueDragConn:Disconnect() hueDragConn = nil end
                    if hueEndConn then hueEndConn:Disconnect() hueEndConn = nil end
                end
            end)
        end
    end)

    -- Limpieza de memoria: si el contenedor se destruye a mitad de un arrastre o con el
    -- modo RGB activo (cambio de pestaña, cierre del hub, etc.) se desconecta todo
    connect(MasterFrame.Destroying, function()
        if svDragConn then svDragConn:Disconnect() svDragConn = nil end
        if svEndConn then svEndConn:Disconnect() svEndConn = nil end
        if hueDragConn then hueDragConn:Disconnect() hueDragConn = nil end
        if hueEndConn then hueEndConn:Disconnect() hueEndConn = nil end
        if rainbowConn then rainbowConn:Disconnect() rainbowConn = nil end
    end)

    setRainbowVisual(rainbowActive)
    if rainbowActive then task.defer(function() setRainbow(true, true) end) end

    return {
        RefreshInit = function() refreshColor(true) end,
        SetColor = function(newColor)
            if rainbowActive then setRainbow(false) end
            h, s, v = color3ToHSV(newColor)
            refreshColor()
        end,
        Sync = function()
            local col = Flags[flagColor].CurrentValue
            setSwatchColor(ColorBtn, col)
            PreviewFrame.BackgroundColor3 = col
        end,
        ApplyTheme = function()
            RainbowStroke.Color = CurrentTheme.BORDER
            setRainbowVisual(rainbowActive)
        end
    }
end

-- ============================================================================
-- 📌 SISTEMA DE SHORTCUTS FLOTANTES NATIVOS (V4.3)
-- Convierte cualquier Toggle o Button de la interfaz en un acceso directo
-- flotante sobre la pantalla del juego. Todo el estado (forma, tamaño,
-- opacidad, posición, bloqueo) se persiste automáticamente en Config.Shortcuts
-- y se restaura entre sesiones.
-- ============================================================================
if type(Config.Shortcuts) ~= "table" then Config.Shortcuts = {} end

-- Colores de acento del "handle" ↖ por tema. Para los temas cuyo ACCENT es
-- blanco/gris (Obsidian, Classic Dark) se fuerza un color distintivo para que
-- el estado activo del handle se perciba claramente.
local ShortcutAccentOverrides = {
    ["Obsidian"] = Color3.fromRGB(120, 40, 200),   -- morado void sobre negro
    ["Classic Dark"] = Color3.fromRGB(215, 35, 35), -- rojo intenso
}
local function getShortcutAccent()
    return ShortcutAccentOverrides[Config.SelectedTheme] or CurrentTheme.ACCENT
end

-- Contenedor global sobre el ScreenGui para los botones flotantes en pantalla.
local ShortcutsLayer = create("Frame", {
    Name = "ShortcutsLayer",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex = 5,
}, ScreenGui)

-- Modal centralizado (una sola instancia reutilizable).
local ShortcutModal = create("Frame", {
    Name = "ShortcutModal",
    Size = UDim2.new(0, 320, 0, 300),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = CurrentTheme.BG_MAIN,
    BackgroundTransparency = 0.05,
    Visible = false,
    ZIndex = 50,
    Active = true,
}, ScreenGui)
create("UICorner", {CornerRadius = UDim.new(0, 12)}, ShortcutModal)
local ShortcutModalStroke = create("UIStroke", {Thickness = 1.5, Color = CurrentTheme.BORDER}, ShortcutModal)

local function styleShortcutModal()
    ShortcutModal.BackgroundColor3 = CurrentTheme.BG_MAIN
    ShortcutModalStroke.Color = CurrentTheme.BORDER
end

local ShortcutModalTitle = create("TextLabel", {
    Size = UDim2.new(1, -24, 0, 24),
    Position = UDim2.new(0, 12, 0, 10),
    BackgroundTransparency = 1,
    Text = "Shortcut",
    TextColor3 = CurrentTheme.TEXT_WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 51,
}, ShortcutModal)

local ShortcutModalClose = create("TextButton", {
    Size = UDim2.new(0, 26, 0, 26),
    Position = UDim2.new(1, -34, 0, 8),
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    Text = "×",
    TextColor3 = CurrentTheme.TEXT_WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    ZIndex = 51,
}, ShortcutModal)
create("UICorner", {CornerRadius = UDim.new(0, 6)}, ShortcutModalClose)

-- Helpers para construir controles dentro del modal
local function modalSectionLabel(txt, yPos)
    return create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 14),
        Position = UDim2.new(0, 12, 0, yPos),
        BackgroundTransparency = 1,
        Text = txt,
        TextColor3 = CurrentTheme.TEXT_MUTED,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 51,
    }, ShortcutModal)
end

local shapeLabel = modalSectionLabel("FORMA", 42)
local shapeRow = create("Frame", {Size = UDim2.new(1, -24, 0, 34), Position = UDim2.new(0, 12, 0, 58), BackgroundTransparency = 1, ZIndex = 51}, ShortcutModal)
local shapeLayout = create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, shapeRow)

local function mkShapeBtn(id, txt, order)
    local b = create("TextButton", {
        Name = id,
        Size = UDim2.new(0, 90, 1, 0),
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        Text = txt,
        TextColor3 = CurrentTheme.TEXT_WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        LayoutOrder = order,
        ZIndex = 52,
    }, shapeRow)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, b)
    create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, b)
    return b
end
local shapeCircle = mkShapeBtn("Circle", "● Circle", 1)
local shapeSquare = mkShapeBtn("Square", "▢ Square", 2)
local shapeRounded = mkShapeBtn("Rounded", "▬ Rounded", 3)

-- Sliders (helper simplificado local para el modal)
local function mkModalSlider(labelText, yBase, minV, maxV)
    local wrap = create("Frame", {Size = UDim2.new(1, -24, 0, 36), Position = UDim2.new(0, 12, 0, yBase), BackgroundTransparency = 1, ZIndex = 51}, ShortcutModal)
    local lbl = create("TextLabel", {Size = UDim2.new(1, -60, 0, 14), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, Text = labelText, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 52}, wrap)
    local valLbl = create("TextLabel", {Size = UDim2.new(0, 56, 0, 14), Position = UDim2.new(1, -56, 0, 0), BackgroundTransparency = 1, Text = "", TextColor3 = getShortcutAccent(), Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 52}, wrap)
    local track = create("Frame", {Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0, 22), BackgroundColor3 = Color3.fromRGB(35, 35, 40), ZIndex = 52}, wrap)
    create("UICorner", {CornerRadius = UDim.new(0, 3)}, track)
    local fill = create("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = getShortcutAccent(), ZIndex = 53}, track)
    create("UICorner", {CornerRadius = UDim.new(0, 3)}, fill)
    local knob = create("TextButton", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, -7, 0.5, -7), BackgroundColor3 = Color3.fromRGB(245, 245, 245), Text = "", AutoButtonColor = false, ZIndex = 54}, track)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, knob)

    local onChange
    local function setVal(v, fire)
        v = mathClamp(v, minV, maxV)
        local pct = (v - minV) / (maxV - minV)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -7, 0.5, -7)
        if maxV <= 1 then valLbl.Text = stringFormat("%.2f", v) else valLbl.Text = tostring(mathRound(v)) end
        if fire and onChange then onChange(v) end
    end
    local dragging = false
    local activeIn
    local dragConn, endConn
    local function snap(input)
        local pct = mathClamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        setVal(minV + pct * (maxV - minV), true)
    end
    connect(knob.InputBegan, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragging then
            dragging = true; activeIn = input; snap(input)
            dragConn = connect(UserInputService.InputChanged, function(ci)
                if dragging and ci == activeIn then snap(ci) end
            end)
            endConn = connect(UserInputService.InputEnded, function(ei)
                if ei == activeIn then
                    dragging = false; activeIn = nil
                    if dragConn then dragConn:Disconnect() dragConn = nil end
                    if endConn then endConn:Disconnect() endConn = nil end
                end
            end)
        end
    end)
    return {
        Set = setVal,
        OnChange = function(cb) onChange = cb end,
        Refresh = function() fill.BackgroundColor3 = getShortcutAccent() valLbl.TextColor3 = getShortcutAccent() end,
    }
end

local sizeLabel = modalSectionLabel("TAMAÑO", 102)
local sizeSlider = mkModalSlider("Escala del botón (px)", 118, 20, 100)
local opacityLabel = modalSectionLabel("OPACIDAD", 160)
local opacitySlider = mkModalSlider("Transparencia del fondo", 176, 0, 1)

-- Lock toggle
local lockWrap = create("Frame", {Size = UDim2.new(1, -24, 0, 34), Position = UDim2.new(0, 12, 0, 218), BackgroundColor3 = Color3.fromRGB(20, 20, 24), BackgroundTransparency = 0.3, ZIndex = 51}, ShortcutModal)
create("UICorner", {CornerRadius = UDim.new(0, 6)}, lockWrap)
create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, lockWrap)
local lockLabel = create("TextLabel", {Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = "🔒 Bloquear posición (Lock)", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 52}, lockWrap)
local lockBtn = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 53}, lockWrap)
local lockTrack = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = Color3.fromRGB(40, 40, 45), ZIndex = 53}, lockWrap)
create("UICorner", {CornerRadius = UDim.new(1, 0)}, lockTrack)
local lockKnob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Color3.fromRGB(245, 245, 245), ZIndex = 54}, lockTrack)
create("UICorner", {CornerRadius = UDim.new(1, 0)}, lockKnob)

-- Enable/Disable shortcut (bottom)
local enableBtn = create("TextButton", {
    Size = UDim2.new(1, -24, 0, 30),
    Position = UDim2.new(0, 12, 1, -42),
    BackgroundColor3 = getShortcutAccent(),
    Text = "Crear acceso directo",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    ZIndex = 52,
}, ShortcutModal)
create("UICorner", {CornerRadius = UDim.new(0, 8)}, enableBtn)

-- Estado interno del modal: apunta al shortcut en edición
local currentModalEntry = nil
local ShortcutRegistry = {} -- [label] = {handle, floatBtn, entry, kind, getStateText, callback}

local function applyShapeVisual(button, corner, shape)
    if shape == "Circle" then
        corner.CornerRadius = UDim.new(1, 0)
        button.Size = UDim2.new(0, button.Size.X.Offset, 0, button.Size.X.Offset) -- forzar cuadrado
    elseif shape == "Square" then
        corner.CornerRadius = UDim.new(0, 12)
    else -- Rounded
        corner.CornerRadius = UDim.new(0, 8)
    end
end

-- Drag optimizado, tolerante a multi-touch (arrastrar con un dedo, girar cámara con otro)
-- Solo captura el input específico que inició sobre el botón; ignora inputs paralelos.
local function makeShortcutDraggable(button, entryProvider)
    local dragging = false
    local activeInput
    local moveConn, endConn
    local startPos, dragStart
    connect(button.InputBegan, function(input)
        local entry = entryProvider()
        if not entry or entry.locked then return end
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragging then
            dragging = true
            activeInput = input
            dragStart = input.Position
            startPos = button.Position
            moveConn = connect(UserInputService.InputChanged, function(ci)
                if not dragging or ci ~= activeInput then return end
                local delta = ci.Position - dragStart
                local vp = Camera.ViewportSize
                local sz = button.AbsoluteSize
                local nx = mathClamp(startPos.X.Offset + delta.X, 0, vp.X - sz.X)
                local ny = mathClamp(startPos.Y.Offset + delta.Y, 0, vp.Y - sz.Y)
                button.Position = UDim2.new(0, nx, 0, ny)
            end)
            endConn = connect(UserInputService.InputEnded, function(ei)
                if ei ~= activeInput then return end
                dragging = false
                activeInput = nil
                if moveConn then moveConn:Disconnect() moveConn = nil end
                if endConn then endConn:Disconnect() endConn = nil end
                local e = entryProvider()
                if e then
                    e.x = button.Position.X.Offset
                    e.y = button.Position.Y.Offset
                    saveConfig()
                end
            end)
        end
    end)
end

local function renderShortcut(label)
    local reg = ShortcutRegistry[label]
    if not reg then return end
    local entry = Config.Shortcuts[label]
    if not entry then return end
    if reg.floatBtn then reg.floatBtn:Destroy() reg.floatBtn = nil end
    if not entry.enabled then return end

    local shape = entry.shape or "Rounded"
    local size = entry.size or 46
    local opacity = entry.opacity or 0.85
    local w = (shape == "Rounded") and math.floor(size * 2.4) or size
    local h = size

    local btn = create("TextButton", {
        Name = "Shortcut_" .. label,
        Size = UDim2.new(0, w, 0, h),
        Position = UDim2.new(0, entry.x or 60, 0, entry.y or 200),
        BackgroundColor3 = CurrentTheme.BG_MAIN,
        BackgroundTransparency = 1 - opacity,
        AutoButtonColor = false,
        Text = "",
        Active = true,
        ZIndex = 6,
    }, ShortcutsLayer)
    local corner = create("UICorner", {CornerRadius = UDim.new(0, 8)}, btn)
    local stroke = create("UIStroke", {Thickness = 1.2, Color = getShortcutAccent()}, btn)
    applyShapeVisual(btn, corner, shape)

    local lbl = create("TextLabel", {
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.new(0, 4, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = CurrentTheme.TEXT_WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = shape == "Rounded" and 11 or 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 7,
    }, btn)

    local function refreshText()
        if reg.getStateText then
            lbl.Text = reg.getStateText()
        else
            lbl.Text = label
        end
    end
    refreshText()
    reg.refreshText = refreshText
    reg.floatBtn = btn

    -- Distinguir tap corto (activar) de arrastre (mover): usamos umbral de distancia.
    local pressStart, pressPos, pressInput
    connect(btn.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            pressStart = tick()
            pressPos = input.Position
            pressInput = input
        end
    end)
    connect(btn.InputEnded, function(input)
        if input == pressInput and pressStart then
            local dt = tick() - pressStart
            local moved = (input.Position - pressPos).Magnitude
            pressStart = nil
            if dt < 0.35 and moved < 8 then
                -- Tap: dispara callback y refresca el label si es toggle
                if reg.callback then task.spawn(reg.callback) end
                task.defer(refreshText)
            end
        end
    end)

    makeShortcutDraggable(btn, function() return Config.Shortcuts[label] end)
end

local function refreshHandleVisual(handle, active)
    if not handle then return end
    local accent = getShortcutAccent()
    if active then
        handle.BackgroundColor3 = accent
        handle.TextColor3 = Color3.fromRGB(255, 255, 255)
        local s = handle:FindFirstChildWhichIsA("UIStroke")
        if s then s.Color = accent end
    else
        handle.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        handle.TextColor3 = CurrentTheme.TEXT_MUTED
        local s = handle:FindFirstChildWhichIsA("UIStroke")
        if s then s.Color = CurrentTheme.BORDER end
    end
end

local function setShortcutEnabled(label, enabled)
    local entry = Config.Shortcuts[label]
    if not entry then return end
    entry.enabled = enabled
    saveConfig()
    renderShortcut(label)
    local reg = ShortcutRegistry[label]
    if reg then refreshHandleVisual(reg.handle, enabled) end
end

-- Repaint helper accesible fuera del open, para reusar en el ciclo de vida
local function paintShapeButtons()
    local entry = currentModalEntry and Config.Shortcuts[currentModalEntry] or nil
    local sel = entry and (entry.shape or "Rounded") or nil
    for _, b in ipairs({shapeCircle, shapeSquare, shapeRounded}) do
        local isSel = (b.Name == sel)
        b.BackgroundColor3 = isSel and getShortcutAccent() or Color3.fromRGB(25, 25, 30)
        b.TextColor3 = isSel and Color3.fromRGB(255, 255, 255) or CurrentTheme.TEXT_WHITE
    end
end

local function openShortcutModal(label)
    local entry = Config.Shortcuts[label]
    if not entry then return end
    currentModalEntry = label
    ShortcutModalTitle.Text = "Shortcut · " .. label
    paintShapeButtons()
    sizeSlider.Set(entry.size or 46, false)
    opacitySlider.Set(entry.opacity or 0.85, false)
    lockTrack.BackgroundColor3 = entry.locked and getShortcutAccent() or Color3.fromRGB(40, 40, 45)
    lockKnob.Position = entry.locked and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    lockLabel.TextColor3 = entry.locked and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
    enableBtn.Text = entry.enabled and "Quitar acceso directo" or "Crear acceso directo"
    enableBtn.BackgroundColor3 = getShortcutAccent()
    sizeSlider.Refresh(); opacitySlider.Refresh()
    styleShortcutModal()
    ShortcutModal.Visible = true
end

-- Conexiones registradas UNA sola vez (evita leak al abrir/cerrar el modal repetidamente)
sizeSlider.OnChange(function(v)
    if not currentModalEntry then return end
    local e = Config.Shortcuts[currentModalEntry]; if not e then return end
    e.size = mathRound(v); saveConfig(); renderShortcut(currentModalEntry)
end)
opacitySlider.OnChange(function(v)
    if not currentModalEntry then return end
    local e = Config.Shortcuts[currentModalEntry]; if not e then return end
    e.opacity = v; saveConfig(); renderShortcut(currentModalEntry)
end)
for _, b in ipairs({shapeCircle, shapeSquare, shapeRounded}) do
    connect(b.MouseButton1Click, function()
        if not currentModalEntry then return end
        local e = Config.Shortcuts[currentModalEntry]; if not e then return end
        e.shape = b.Name; saveConfig(); paintShapeButtons(); renderShortcut(currentModalEntry)
    end)
end

connect(ShortcutModalClose.MouseButton1Click, function() ShortcutModal.Visible = false end)
connect(lockBtn.MouseButton1Click, function()
    if not currentModalEntry then return end
    local entry = Config.Shortcuts[currentModalEntry]; if not entry then return end
    entry.locked = not entry.locked; saveConfig()
    lockTrack.BackgroundColor3 = entry.locked and getShortcutAccent() or Color3.fromRGB(40, 40, 45)
    lockKnob.Position = entry.locked and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    lockLabel.TextColor3 = entry.locked and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
end)
connect(enableBtn.MouseButton1Click, function()
    if not currentModalEntry then return end
    local entry = Config.Shortcuts[currentModalEntry]; if not entry then return end
    setShortcutEnabled(currentModalEntry, not entry.enabled)
    enableBtn.Text = entry.enabled and "Quitar acceso directo" or "Crear acceso directo"
end)

-- Actualiza el color del handle y del botón flotante cuando cambia el tema
table.insert(KillerHub.TargetThemeElements, function()
    styleShortcutModal()
    enableBtn.BackgroundColor3 = getShortcutAccent()
    for label, reg in pairs(ShortcutRegistry) do
        local entry = Config.Shortcuts[label]
        refreshHandleVisual(reg.handle, entry and entry.enabled)
        if entry and entry.enabled then renderShortcut(label) end
    end
end)

-- API pública: adjunta un handle ↖ a la izquierda de una fila y registra el shortcut.
-- kind: "toggle" | "button". getStateText: opcional, string dinámica p/ el botón flotante.
local function attachShortcutHandle(rowFrame, label, kind, callback, getStateText)
    if Config.Shortcuts[label] == nil then
        Config.Shortcuts[label] = {
            enabled = false, shape = "Rounded", size = 46, opacity = 0.85,
            locked = false, x = 60, y = 200,
        }
    end
    local entry = Config.Shortcuts[label]

    local handle = create("TextButton", {
        Name = "SC_Handle",
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, 4, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(22, 22, 26),
        Text = "↖",
        TextColor3 = CurrentTheme.TEXT_MUTED,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        AutoButtonColor = false,
        ZIndex = 3,
    }, rowFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, handle)
    create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, handle)
    refreshHandleVisual(handle, entry.enabled)

    ShortcutRegistry[label] = {
        handle = handle, entry = entry, kind = kind,
        getStateText = getStateText, callback = callback,
    }

    connect(handle.MouseButton1Click, function()
        playUISound()
        openShortcutModal(label)
    end)

    if entry.enabled then task.defer(function() renderShortcut(label) end) end
    return handle
end

-- API para refrescar el texto del botón flotante cuando cambia el estado del toggle
local function refreshShortcutText(label)
    local reg = ShortcutRegistry[label]
    if reg and reg.refreshText then reg.refreshText() end
end


local TabMethods = {}
TabMethods.__index = TabMethods

function TabMethods:RegisterElement(inst, textLabel, tabName)
    table.insert(KillerHub.AllElements, {Instance = inst, Label = textLabel, Tab = tabName})
    -- 🩹 FIX DE RENDIMIENTO: antes esto llamaba a KillerHub:SetFont(), que recorre
    -- TODOS los descendientes del ScreenGui, por cada widget nuevo creado. Con N
    -- elementos eso es O(n²) solo para construir el menú (perceptible con GUIs
    -- grandes, especialmente en móvil). Como el widget recién creado ya nace con
    -- la fuente por defecto de Roblox, basta con aplicarle la fuente actual
    -- únicamente a él y a sus propios descendientes.
    local fontEnum = Enum.Font[Config.SelectedFont] or Enum.Font.GothamMedium
    task.defer(function()
        if not inst or not inst.Parent then return end
        if inst:IsA("TextLabel") or inst:IsA("TextBox") or inst:IsA("TextButton") then
            inst.Font = fontEnum
        end
        for _, v in ipairs(inst:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
                v.Font = fontEnum
            end
        end
    end)
end

function TabMethods:CreateParagraph(title, text)
    if not SafeAssert("CreateParagraph", {
        ["title"] = {value = title, types = {"string"}},
        ["text"] = {value = text, types = {"string"}}
    }) then return end

    local Frame = create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.3}, self.Frame)
    Frame:SetAttribute("ThemeRole", "BG_SECONDARY") Frame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, Frame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Frame)
    
    local Tl = create("TextLabel", {Size = UDim2.new(1, -24, 0, 16), Position = UDim2.new(0, 12, 0, 4), BackgroundTransparency = 1, Text = title, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Frame)
    Tl:SetAttribute("ThemeRole", "TEXT_ACCENT")
    local Tx = create("TextLabel", {Size = UDim2.new(1, -24, 0, 24), Position = UDim2.new(0, 12, 0, 20), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamMedium, TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, Frame)
    
    table.insert(KillerHub.TargetThemeElements, function()
        Tx.TextColor3 = CurrentTheme.TEXT_MUTED
    end)
    self:RegisterElement(Frame, Tl, self.Frame.Name)
    
    local paraObj = {
        SetTitle = function(_, t) Tl.Text = t end,
        SetText = function(_, t) Tx.Text = t end
    }
    KillerHub.Elements[title] = paraObj
    return paraObj
end

function TabMethods:CreateSection(text)
    if not SafeAssert("CreateSection", {
        ["text"] = {value = text, types = {"string"}}
    }) then return end

    local SectionFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1}, self.Frame)
    local AccentLine = create("Frame", {Size = UDim2.new(0, 3, 1, -6), Position = UDim2.new(0, 2, 0, 3), BackgroundColor3 = CurrentTheme.ACCENT, BorderSizePixel = 0}, SectionFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 1)}, AccentLine)
    
    local Label = create("TextLabel", {Size = UDim2.new(1, -15, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = string.upper(text), TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left}, SectionFrame)
    Label:SetAttribute("ThemeRole", "TEXT_ACCENT")
    
    table.insert(KillerHub.TargetThemeElements, function()
        AccentLine.BackgroundColor3 = CurrentTheme.ACCENT
    end)
    
    self:RegisterElement(SectionFrame, Label, self.Frame.Name)
    
    local secObj = {
        SetText = function(_, newText) Label.Text = string.upper(newText) end
    }
    KillerHub.Elements[text] = secObj
    return secObj
end

function TabMethods:CreateToggle(flagName, text, callback)
    if not SafeAssert("CreateToggle", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil then Config[flagName] = false end
    updateGlobalFlags(flagName, Config[flagName])
    
    local ToggleButton = create("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4, Text = "", AutoButtonColor = false}, self.Frame)
    ToggleButton:SetAttribute("ThemeRole", "BG_SECONDARY") ToggleButton:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, ToggleButton)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, ToggleButton)
    
    local ToggleLabel = create("TextLabel", {Size = UDim2.new(1, -92, 1, 0), Position = UDim2.new(0, 32, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Config[flagName] and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12}, ToggleButton)
    local Track = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = Config[flagName] and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)}, ToggleButton)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Track)
    local Knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = Config[flagName] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    local function stateUpdate()
        local active = Flags[flagName].CurrentValue
        ToggleLabel.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
        TweenService:Create(Track, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)
        }):Play()
        TweenService:Create(Knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
    end
    
    local function executeSet(bool)
        updateGlobalFlags(flagName, bool) Config[flagName] = bool saveConfig()
        task.spawn(stateUpdate)
        task.spawn(callback, bool)
    end

    connect(ToggleButton.MouseButton1Click, function()
        playUISound()
        executeSet(not Flags[flagName].CurrentValue)
    end)
    
    table.insert(KillerHub.TargetThemeElements, stateUpdate)
    task.spawn(function() stateUpdate() pcall(callback, Flags[flagName].CurrentValue) end)

    addInteractiveFeedback(ToggleButton)
    self:RegisterElement(ToggleButton, ToggleLabel, self.Frame.Name)

    -- 📌 Shortcut flotante nativo (V4.3): tap del handle abre el modal;
    -- el botón flotante replica el toggle mostrando "Nombre: ON/OFF".
    attachShortcutHandle(ToggleButton, text, "toggle", function()
        executeSet(not Flags[flagName].CurrentValue)
    end, function()
        local st = Flags[flagName] and Flags[flagName].CurrentValue
        return text .. ": " .. (st and "ON" or "OFF")
    end)
    -- Hook adicional para refrescar el texto del shortcut cuando cambia el toggle desde la UI
    connect(ToggleButton.MouseButton1Click, function()
        task.defer(function() refreshShortcutText(text) end)
    end)
    
    local toggleObj = {
        Set = function(_, bool) executeSet(bool) end,
        BindToKey = function(self, keycode)
            local keyConn = connect(UserInputService.InputBegan, function(input, gp)
                if not gp and input.KeyCode == keycode then
                    playUISound()
                    executeSet(not Flags[flagName].CurrentValue)
                end
            end)
            table.insert(Connections, keyConn)
        end,
        BindToState = function(self, evaluationFunction, checkInterval)
            checkInterval = checkInterval or 0.5
            task.spawn(function()
                while task.wait(checkInterval) do
                    if not ScreenGui or not ScreenGui.Parent then break end
                    local success, result = pcall(evaluationFunction)
                    if success and typeof(result) == "boolean" then
                        if Flags[flagName].CurrentValue ~= result then
                            executeSet(result)
                        end
                    end
                end
            end)
        end
    }
    
    KillerHub.Elements[flagName] = toggleObj
    return toggleObj
end

function TabMethods:CreatePremiumToggle(flagName, text, callback)
    return self:CreateToggle(flagName, text, callback)
end

function TabMethods:CreateToggleSlider(flagToggle, flagSlider, text, min, max, callbackToggle, callbackSlider)
    if not SafeAssert("CreateToggleSlider", {
        ["flagToggle"] = {value = flagToggle, types = {"string"}},
        ["flagSlider"] = {value = flagSlider, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["min"] = {value = min, types = {"number"}},
        ["max"] = {value = max, types = {"number"}},
        ["callbackToggle"] = {value = callbackToggle, types = {"function"}},
        ["callbackSlider"] = {value = callbackSlider, types = {"function"}}
    }) then return end

    if Config[flagToggle] == nil then Config[flagToggle] = false end
    if Config[flagSlider] == nil then Config[flagSlider] = min end
    updateGlobalFlags(flagToggle, Config[flagToggle])
    updateGlobalFlags(flagSlider, Config[flagSlider])
    
    local TSFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4}, self.Frame)
    TSFrame:SetAttribute("ThemeRole", "BG_SECONDARY") TSFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, TSFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, TSFrame)
    
    local ToggleButton = create("TextButton", {Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Text = ""}, TSFrame)
    local ToggleLabel = create("TextLabel", {Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Config[flagToggle] and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12}, ToggleButton)
    
    local Track = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = Config[flagToggle] and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)}, ToggleButton)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Track)
    local Knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = Config[flagToggle] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    local SliderContainer = create("Frame", {Size = UDim2.new(1, -24, 0, 20), Position = UDim2.new(0, 12, 0, 27), BackgroundTransparency = 1}, TSFrame)

    -- Caja de valor estilo "textbox" oscura semitransparente, separada del track
    local ValueBoxBg = create("Frame", {Size = UDim2.new(0, 50, 1, 0), Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.35}, SliderContainer)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, ValueBoxBg)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(45, 45, 50), Transparency = 0.3}, ValueBoxBg)
    local ValueBox = create("TextBox", {Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center, ClearTextOnFocus = false}, ValueBoxBg)
    ValueBox:SetAttribute("ThemeRole", "TEXT_ACCENT")
    
    local STrack = create("Frame", {Size = UDim2.new(1, -80, 0, 6), Position = UDim2.new(0, 0, 0.5, -3), BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, SliderContainer)
    create("UICorner", {CornerRadius = UDim.new(0, 3)}, STrack)
    local SFill = create("Frame", {BackgroundColor3 = CurrentTheme.ACCENT}, STrack)
    create("UICorner", {CornerRadius = UDim.new(0, 3)}, SFill)
    
    local SKnob = create("TextButton", {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, -6, 0.5, -6), BackgroundColor3 = CurrentTheme.TEXT_WHITE, Text = "", AutoButtonColor = false}, STrack)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, SKnob)

    local function stateUpdate()
        local active = Flags[flagToggle].CurrentValue
        ToggleLabel.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
        Track.BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)
        Knob.Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    end

    -- Mismo formato flexible que CreateSlider: enteros sin decimales, y hasta 3 cifras en rangos 0-1
    local function formatValue(v)
        if max <= 1 then
            return string.format("%.3f", v)
        elseif v % 1 ~= 0 then
            return string.format("%.2f", v)
        else
            return tostring(math.floor(v))
        end
    end

    local function runSliderValue(v, skipCallback)
        v = math.clamp(v, min, max) 
        updateGlobalFlags(flagSlider, v) Config[flagSlider] = v saveConfig()
        local pct = (max == min) and 0 or (v - min) / (max - min)
        SFill.Size = UDim2.new(pct, 0, 1, 0)
        SKnob.Position = UDim2.new(pct, -6, 0.5, -6)
        ValueBox.Text = formatValue(v)
        if not skipCallback then pcall(callbackSlider, v) end
    end

    connect(ToggleButton.MouseButton1Click, function()
        local nextState = not Flags[flagToggle].CurrentValue
        updateGlobalFlags(flagToggle, nextState) Config[flagToggle] = nextState saveConfig() playUISound()
        stateUpdate() pcall(callbackToggle, nextState)
    end)

    connect(ValueBox.FocusLost, function()
        local inputNum = tonumber(ValueBox.Text)
        if not inputNum then runSliderValue(Flags[flagSlider].CurrentValue) else runSliderValue(inputNum) end
    end)

    local sliding = false
    local function snap(input)
        local pct = math.clamp((input.Position.X - STrack.AbsolutePosition.X) / STrack.AbsoluteSize.X, 0, 1)
        runSliderValue(min + (pct * (max - min)))
    end

    local dragConn, endConn
    connect(SKnob.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true snap(input)
            dragConn = connect(UserInputService.InputChanged, function(changedInput)
                if sliding and (changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput.UserInputType == Enum.UserInputType.Touch) then snap(changedInput) end
            end)
            endConn = connect(UserInputService.InputEnded, function(endedInput)
                if endedInput.UserInputType == Enum.UserInputType.MouseButton1 or endedInput.UserInputType == Enum.UserInputType.Touch then
                    sliding = false if dragConn then dragConn:Disconnect() end if endConn then endConn:Disconnect() end
                end
            end)
        end
    end)

    table.insert(KillerHub.TargetThemeElements, function()
        SFill.BackgroundColor3 = CurrentTheme.ACCENT
        stateUpdate() runSliderValue(Flags[flagSlider].CurrentValue, true)
    end)

    task.spawn(function()
        stateUpdate() runSliderValue(Flags[flagSlider].CurrentValue, true)
        pcall(callbackToggle, Flags[flagToggle].CurrentValue) pcall(callbackSlider, Flags[flagSlider].CurrentValue)
    end)

    addInteractiveFeedback(ToggleButton)
    self:RegisterElement(TSFrame, ToggleLabel, self.Frame.Name)
    
    local tsObj = {
        SetToggle = function(_, bool) updateGlobalFlags(flagToggle, bool) Config[flagToggle] = bool saveConfig() stateUpdate() pcall(callbackToggle, bool) end,
        SetSlider = function(_, value) runSliderValue(value) end
    }
    KillerHub.Elements[flagToggle] = tsObj
    return tsObj
end

function TabMethods:CreateSlider(flagName, text, min, max, callback)
    if not SafeAssert("CreateSlider", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["min"] = {value = min, types = {"number"}},
        ["max"] = {value = max, types = {"number"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil then Config[flagName] = min end
    updateGlobalFlags(flagName, Config[flagName])
    
    local SliderFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, Active = true}, self.Frame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -12, 0, 16), Position = UDim2.new(0, 2, 0, 2), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, SliderFrame)

    -- Caja de valor estilo "textbox" oscura semitransparente, separada del track (a un lado)
    local ValueBoxBg = create("Frame", {Size = UDim2.new(0, 54, 0, 20), Position = UDim2.new(1, -2, 0, 22), AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.35}, SliderFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, ValueBoxBg)
    create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(45, 45, 50), Transparency = 0.3}, ValueBoxBg)
    local ValueBox = create("TextBox", {Size = UDim2.new(1, -8, 1, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, ClearTextOnFocus = false}, ValueBoxBg)
    ValueBox:SetAttribute("ThemeRole", "TEXT_ACCENT")

    -- Track más corto (ya no ocupa todo el ancho horizontal) y un poco más grueso
    local Track = create("Frame", {Size = UDim2.new(1, -86, 0, 8), Position = UDim2.new(0, 2, 0, 26), BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, SliderFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, Track)
    local Fill = create("Frame", {BackgroundColor3 = CurrentTheme.ACCENT}, Track)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, Fill)
    
    local Knob = create("TextButton", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, -7, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE, Text = "", AutoButtonColor = false}, Track)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, Knob)

    -- Formato flexible: enteros como 1000 se muestran sin decimales, y los rangos 0-1
    -- (u otros con decimales) muestran hasta 3 cifras, permitiendo escribir 0.0, 0.00 o 0.000
    local function formatValue(v)
        if max <= 1 then
            return string.format("%.3f", v)
        elseif v % 1 ~= 0 then
            return string.format("%.2f", v)
        else
            return tostring(math.floor(v))
        end
    end

    local function runSliderValue(v, skipCallback)
        v = math.clamp(v, min, max) 
        updateGlobalFlags(flagName, v) Config[flagName] = v saveConfig()
        local pct = (max == min) and 0 or (v - min) / (max - min)
        Fill.Size = UDim2.new(pct, 0, 1, 0) Knob.Position = UDim2.new(pct, -7, 0.5, -7)
        ValueBox.Text = formatValue(v)
        if not skipCallback then pcall(callback, v) end
    end
    
    connect(ValueBox.FocusLost, function()
        local inputNum = tonumber(ValueBox.Text)
        if not inputNum then runSliderValue(Flags[flagName].CurrentValue) else runSliderValue(inputNum) end
    end)
    
    local sliding = false
    local function snap(input)
        local pct = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        runSliderValue(min + (pct * (max - min)))
    end
    
    local dragConn, endConn
    connect(Knob.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true snap(input)
            dragConn = connect(UserInputService.InputChanged, function(changedInput)
                if sliding and (changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput.UserInputType == Enum.UserInputType.Touch) then snap(changedInput) end
            end)
            endConn = connect(UserInputService.InputEnded, function(endedInput)
                if endedInput.UserInputType == Enum.UserInputType.MouseButton1 or endedInput.UserInputType == Enum.UserInputType.Touch then
                    sliding = false if dragConn then dragConn:Disconnect() end if endConn then endConn:Disconnect() end
                end
            end)
        end
    end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        Fill.BackgroundColor3 = CurrentTheme.ACCENT
        runSliderValue(Flags[flagName].CurrentValue, true)
    end)

    task.spawn(function() runSliderValue(Flags[flagName].CurrentValue, true) pcall(callback, Flags[flagName].CurrentValue) end)
    self:RegisterElement(SliderFrame, Label, self.Frame.Name)
    
    local sliderObj = {
        Set = function(_, value) runSliderValue(value) end,
        BindToPing = function(self, baseFactor, updateInterval)
            baseFactor = baseFactor or 0.15
            updateInterval = updateInterval or 0.5
            task.spawn(function()
                while task.wait(updateInterval) do
                    if not ScreenGui or not ScreenGui.Parent then break end
                    local ping = 0
                    pcall(function()
                        if Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerToClientPing") then
                            ping = Stats.Network.ServerToClientPing:GetValue()
                        else
                            ping = LocalPlayer:GetNetworkPing() * 1000
                        end
                    end)
                    local smartValue = ping * baseFactor
                    runSliderValue(smartValue)
                end
            end)
        end
    }
    
    KillerHub.Elements[flagName] = sliderObj
    return sliderObj
end

function TabMethods:CreateDropdown(flagName, text, options, callback)
    if not SafeAssert("CreateDropdown", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["options"] = {value = options, types = {"table"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil then Config[flagName] = options[1] or "" end
    updateGlobalFlags(flagName, Config[flagName])
    
    local DDFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4, ClipsDescendants = true}, self.Frame)
    DDFrame:SetAttribute("ThemeRole", "BG_SECONDARY") DDFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, DDFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, DDFrame)
    local Trigger = create("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Text = ""}, DDFrame)
    
    local Label = create("TextLabel", {Size = UDim2.new(0.5, -12, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Trigger)
    local SelLabel = create("TextLabel", {Size = UDim2.new(0.5, -38, 1, 0), Position = UDim2.new(1, -38, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = Flags[flagName].CurrentValue, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd}, Trigger)
    SelLabel:SetAttribute("ThemeRole", "TEXT_ACCENT")
    local Arrow = create("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -22, 0.5, -10), BackgroundTransparency = 1, Text = "▼", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 11}, Trigger)
    
    local hasSearch = #options > 6
    local searchHeight = hasSearch and 30 or 0
    local SearchBox
    
    if hasSearch then
        SearchBox = create("TextBox", {Size = UDim2.new(1, -16, 0, 24), Position = UDim2.new(0, 8, 0, 36), BackgroundColor3 = Color3.fromRGB(25, 25, 30), Text = "", PlaceholderText = "Filtrar opciones...", PlaceholderColor3 = CurrentTheme.TEXT_MUTED, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, ClearTextOnFocus = false, Visible = false}, DDFrame)
        create("UICorner", {CornerRadius = UDim.new(0, 5)}, SearchBox)
        create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, SearchBox)
    end
    
    local OptsScroll = create("ScrollingFrame", {Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 36 + searchHeight), BackgroundTransparency = 1, ScrollBarThickness = 2}, DDFrame)
    local layout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, OptsScroll)

    local open = false
    
    local function setDropdownOpen(shouldOpen)
        open = shouldOpen
        local targetH = open and math.min(layout.AbsoluteContentSize.Y, 120) or 0
        if SearchBox then SearchBox.Visible = open if not open then SearchBox.Text = "" end end
        
        TweenService:Create(DDFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 36 + targetH + searchHeight + (open and 6 or 0))}):Play()
        TweenService:Create(OptsScroll, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -16, 0, targetH)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = open and 180 or 0}):Play()
        OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end

    connect(Trigger.MouseButton1Click, function()
        playUISound()
        setDropdownOpen(not open)
    end)
    
    local function selectOption(name)
        updateGlobalFlags(flagName, name) Config[flagName] = name saveConfig() SelLabel.Text = name open = false
        if SearchBox then SearchBox.Text = "" SearchBox.Visible = false end
        TweenService:Create(DDFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 36)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
        pcall(callback, name)
    end

    local function makeOptions()
        for _, child in ipairs(OptsScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for i, name in ipairs(options) do
            local OptBtn = create("TextButton", {Size = UDim2.new(1, -4, 0, 26), BackgroundColor3 = Color3.fromRGB(25, 25, 30), Text = name, TextColor3 = (name == Flags[flagName].CurrentValue) and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, LayoutOrder = i}, OptsScroll)
            create("UICorner", {CornerRadius = UDim.new(0, 5)}, OptBtn)
            
            connect(OptBtn.MouseButton1Click, function()
                playUISound()
                selectOption(name)
                makeOptions()
            end)
            addInteractiveFeedback(OptBtn)
        end
        OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end

    if SearchBox then
        connect(SearchBox:GetPropertyChangedSignal("Text"), function()
            local filter = string.lower(SearchBox.Text)
            for _, child in ipairs(OptsScroll:GetChildren()) do
                if child:IsA("TextButton") then child.Visible = (filter == "") or string.find(string.lower(child.Text), filter) and true or false end
            end
            task.defer(function()
                if not open then return end
                local targetH = math.min(layout.AbsoluteContentSize.Y, 120)
                DDFrame.Size = UDim2.new(1, 0, 0, 36 + targetH + searchHeight + 6)
                OptsScroll.Size = UDim2.new(1, -16, 0, targetH)
                OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
            end)
        end)
    end

    table.insert(KillerHub.TargetThemeElements, function()
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        Arrow.TextColor3 = CurrentTheme.TEXT_MUTED
        if SearchBox then SearchBox.PlaceholderColor3 = CurrentTheme.TEXT_MUTED SearchBox.TextColor3 = CurrentTheme.TEXT_WHITE end
        makeOptions()
    end)

    makeOptions()
    task.spawn(function() if Flags[flagName].CurrentValue ~= "" then pcall(callback, Flags[flagName].CurrentValue) end end)

    addInteractiveFeedback(Trigger)
    self:RegisterElement(DDFrame, Label, self.Frame.Name)
    
    local ddObj = {
        Refresh = function(_, newOptions) 
            options = newOptions 
            hasSearch = #options > 6 
            searchHeight = hasSearch and 30 or 0 
            if SearchBox then SearchBox.Visible = open and hasSearch end 
            makeOptions() 
        end,
        BindToDynamicList = function(self, queryFunction, refreshInterval)
            refreshInterval = refreshInterval or 2.0
            task.spawn(function()
                while task.wait(refreshInterval) do
                    if not ScreenGui or not ScreenGui.Parent then break end
                    local success, newList = pcall(queryFunction)
                    if success and type(newList) == "table" then
                        self:Refresh(newList)
                    end
                end
            end)
        end
    }
    
    KillerHub.Elements[flagName] = ddObj
    return ddObj
end

function TabMethods:CreateMultiDropdown(flagName, text, options, callback)
    if not SafeAssert("CreateMultiDropdown", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["options"] = {value = options, types = {"table"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil or type(Config[flagName]) ~= "table" then Config[flagName] = {} end
    updateGlobalFlags(flagName, Config[flagName])
    
    local MFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4, ClipsDescendants = true}, self.Frame)
    MFrame:SetAttribute("ThemeRole", "BG_SECONDARY") MFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, MFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, MFrame)
    local Trigger = create("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Text = ""}, MFrame)
    
    local Label = create("TextLabel", {Size = UDim2.new(0.5, -12, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Trigger)
    local SelLabel = create("TextLabel", {Size = UDim2.new(0.5, -38, 1, 0), Position = UDim2.new(1, -38, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = "...", TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd}, Trigger)
    SelLabel:SetAttribute("ThemeRole", "TEXT_ACCENT")
    local Arrow = create("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -22, 0.5, -10), BackgroundTransparency = 1, Text = "▼", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 11}, Trigger)
    
    local OptsScroll = create("ScrollingFrame", {Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 36), BackgroundTransparency = 1, ScrollBarThickness = 2}, MFrame)
    local layout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, OptsScroll)

    local function updateText()
        local selected = {}
        for _, opt in ipairs(options) do if Config[flagName][opt] then table.insert(selected, opt) end end
        if #selected == 0 then SelLabel.Text = "Ninguno" elseif #selected > 2 then SelLabel.Text = "[" .. tostring(#selected) .. " Seleccionados]" else SelLabel.Text = table.concat(selected, ", ") end
    end

    local open = false
    connect(Trigger.MouseButton1Click, function()
        open = not open playUISound()
        local targetH = open and math.min(layout.AbsoluteContentSize.Y, 120) or 0
        TweenService:Create(MFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 36 + targetH + (open and 6 or 0))}):Play()
        TweenService:Create(OptsScroll, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -16, 0, targetH)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = open and 180 or 0}):Play()
        OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    local cacheButtons = {}
    local function makeList()
        for _, child in ipairs(OptsScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        table.clear(cacheButtons)
        
        for i, name in ipairs(options) do
            local isChosen = Config[flagName][name] or false
            local OptBtn = create("TextButton", {Size = UDim2.new(1, -4, 0, 26), BackgroundColor3 = isChosen and CurrentTheme.BG_MAIN or Color3.fromRGB(25, 25, 30), Text = name, TextColor3 = isChosen and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, LayoutOrder = i}, OptsScroll)
            create("UICorner", {CornerRadius = UDim.new(0, 5)}, OptBtn)
            cacheButtons[name] = OptBtn
            
            connect(OptBtn.MouseButton1Click, function()
                local nextState = not Config[flagName][name]
                Config[flagName][name] = nextState
                saveConfig() playUISound() updateText()
                updateGlobalFlags(flagName, Config[flagName])
                
                TweenService:Create(OptBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = nextState and CurrentTheme.BG_MAIN or Color3.fromRGB(25, 25, 30),
                    TextColor3 = nextState and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE
                }):Play()
                pcall(callback, Config[flagName])
            end)
            addInteractiveFeedback(OptBtn)
        end
        OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end

    table.insert(KillerHub.TargetThemeElements, function()
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        makeList()
    end)

    makeList() updateText()
    task.spawn(pcall, callback, Config[flagName])
    addInteractiveFeedback(Trigger)
    self:RegisterElement(MFrame, Label, self.Frame.Name)
    
    local mddObj = {
        GetSelected = function()
            local selected = {}
            for opt, val in pairs(Config[flagName]) do if val then table.insert(selected, opt) end end
            return selected
        end
    }
    KillerHub.Elements[flagName] = mddObj
end

-- ============================================================================
-- 🎨 COLOR PICKERS 2D PREMIUM (HSV / S-V CANVAS + TONO ARCOIRIS)
-- ============================================================================
function TabMethods:CreateToggleColorPicker(flagToggle, flagColor, text, defaultColor, callbackToggle, callbackColor)
    if not SafeAssert("CreateToggleColorPicker", {
        ["flagToggle"] = {value = flagToggle, types = {"string"}},
        ["flagColor"] = {value = flagColor, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["defaultColor"] = {value = defaultColor, types = {"Color3"}},
        ["callbackToggle"] = {value = callbackToggle, types = {"function"}},
        ["callbackColor"] = {value = callbackColor, types = {"function"}}
    }) then return end

    if Config[flagToggle] == nil then Config[flagToggle] = false end
    local savedColor = getSafeColor(flagColor, defaultColor)
    Config[flagColor] = {savedColor.R, savedColor.G, savedColor.B}
    updateGlobalFlags(flagToggle, Config[flagToggle])
    updateGlobalFlags(flagColor, savedColor)

    local CLOSED_H, OPEN_H = 36, 226 -- +1 fila para el toggle de Modo RGB, respecto al panel anterior

    local MasterFrame = create("Frame", {Size = UDim2.new(1, 0, 0, CLOSED_H), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4, ClipsDescendants = true}, self.Frame)
    MasterFrame:SetAttribute("ThemeRole", "BG_SECONDARY") MasterFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, MasterFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, MasterFrame)

    local MainTrigger = create("TextButton", {Size = UDim2.new(1, -80, 0, CLOSED_H), BackgroundTransparency = 1, Text = ""}, MasterFrame)
    local Label = create("TextLabel", {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Config[flagToggle] and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12}, MainTrigger)

    local Track = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = Config[flagToggle] and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)}, MainTrigger)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Track)
    local Knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = Config[flagToggle] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    local ColorBtn = create("TextButton", {Size = UDim2.new(0, 26, 0, 18), Position = UDim2.new(1, -38, 0, 9), BackgroundColor3 = savedColor, Text = ""}, MasterFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, ColorBtn)

    local Panel = BuildColorPickerPanel(MasterFrame, ColorBtn, flagColor, savedColor, 44, function(col)
        task.spawn(function() pcall(callbackColor, col) end)
    end)

    local function stateUpdate()
        local active = Flags[flagToggle].CurrentValue
        Track.BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 45)
        Knob.Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        Label.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
        Panel.Sync()
    end

    connect(MainTrigger.MouseButton1Click, function()
        local nextVal = not Flags[flagToggle].CurrentValue
        updateGlobalFlags(flagToggle, nextVal)
        Config[flagToggle] = nextVal saveConfig() playUISound()
        stateUpdate() pcall(callbackToggle, nextVal)
    end)

    local open = false
    connect(ColorBtn.MouseButton1Click, function() 
        open = not open playUISound() 
        TweenService:Create(MasterFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, open and OPEN_H or CLOSED_H)}):Play()
        if not open then saveConfig() end -- 💾 Autoguardado explícito al cerrar el menú del color picker
    end)
    
    table.insert(KillerHub.TargetThemeElements, function() stateUpdate() Panel.ApplyTheme() end)
    Panel.RefreshInit()
    task.spawn(function() stateUpdate() pcall(callbackToggle, Flags[flagToggle].CurrentValue) pcall(callbackColor, Flags[flagColor].CurrentValue) end)

    addInteractiveFeedback(MainTrigger) addInteractiveFeedback(ColorBtn)
    self:RegisterElement(MasterFrame, Label, self.Frame.Name)

    local tsObj = {
        SetToggle = function(_, bool)
            updateGlobalFlags(flagToggle, bool) Config[flagToggle] = bool saveConfig() stateUpdate() pcall(callbackToggle, bool)
        end,
        SetColor = function(_, newColor) Panel.SetColor(newColor) end
    }
    KillerHub.Elements[flagToggle] = tsObj
    return tsObj
end

function TabMethods:CreateColorPicker(flagColor, text, defaultColor, callback)
    if not SafeAssert("CreateColorPicker", {
        ["flagColor"] = {value = flagColor, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["defaultColor"] = {value = defaultColor, types = {"Color3"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    local savedColor = getSafeColor(flagColor, defaultColor)
    Config[flagColor] = {savedColor.R, savedColor.G, savedColor.B}
    updateGlobalFlags(flagColor, savedColor)

    local CLOSED_H, OPEN_H = 36, 226 -- +1 fila para el toggle de Modo RGB, respecto al panel anterior

    local MasterFrame = create("Frame", {Size = UDim2.new(1, 0, 0, CLOSED_H), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4, ClipsDescendants = true}, self.Frame)
    MasterFrame:SetAttribute("ThemeRole", "BG_SECONDARY") MasterFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, MasterFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, MasterFrame)

    local Trigger = create("TextButton", {Size = UDim2.new(1, 0, 0, CLOSED_H), BackgroundTransparency = 1, Text = ""}, MasterFrame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Trigger)
    
    local ColorBtn = create("TextButton", {Size = UDim2.new(0, 30, 0, 18), Position = UDim2.new(1, -42, 0.5, -9), BackgroundColor3 = savedColor, Text = ""}, Trigger)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, ColorBtn)

    local Panel = BuildColorPickerPanel(MasterFrame, ColorBtn, flagColor, savedColor, 44, function(col)
        task.spawn(function() pcall(callback, col) end)
    end)

    local open = false
    connect(ColorBtn.MouseButton1Click, function() 
        open = not open playUISound() 
        TweenService:Create(MasterFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, open and OPEN_H or CLOSED_H)}):Play()
        if not open then saveConfig() end -- 💾 Autoguardado explícito al cerrar el menú del color picker
    end)
    
    table.insert(KillerHub.TargetThemeElements, Panel.ApplyTheme)

    Panel.RefreshInit()
    addInteractiveFeedback(Trigger) addInteractiveFeedback(ColorBtn)
    self:RegisterElement(MasterFrame, Label, self.Frame.Name)

    local cpObj = {
        Set = function(_, newColor) Panel.SetColor(newColor) end
    }
    KillerHub.Elements[flagColor] = cpObj
    return cpObj
end

-- ============================================================================
-- 🔓 ELEMENTOS RESTANTES (BOTONES, CONFIG, INPUTS, TECLAS)
-- ============================================================================
function TabMethods:CreateClipboardButton(text, textToCopy)
    if not SafeAssert("CreateClipboardButton", {
        ["text"] = {value = text, types = {"string"}},
        ["textToCopy"] = {value = textToCopy, types = {"string"}}
    }) then return end

    local Frame = create("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4}, self.Frame)
    Frame:SetAttribute("ThemeRole", "BG_SECONDARY") Frame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, Frame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Frame)
    
    local Button = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""}, Frame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Button)
    local StatusLabel = create("TextLabel", {Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(1, -12, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = "Copiar", TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right}, Button)
    StatusLabel:SetAttribute("ThemeRole", "TEXT_ACCENT")
    
    local copying = false
    connect(Button.MouseButton1Click, function()
        if copying then return end copying = true playUISound()
        local setClip = setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if setClip then pcall(setClip, textToCopy) end
        StatusLabel.Text = "¡Copiado! ✓" StatusLabel.TextColor3 = Color3.fromRGB(40, 235, 40)
        task.delay(1.5, function() StatusLabel.Text = "Copiar" StatusLabel.TextColor3 = CurrentTheme.ACCENT copying = false end)
    end)
    
    table.insert(KillerHub.TargetThemeElements, function() Label.TextColor3 = CurrentTheme.TEXT_WHITE if not copying then StatusLabel.TextColor3 = CurrentTheme.ACCENT end end)
    addInteractiveFeedback(Button)
    self:RegisterElement(Frame, Label, self.Frame.Name)
    return {SetText = function(_, newText) Label.Text = newText end, SetTarget = function(_, newTarget) textToCopy = newTarget end}
end

function TabMethods:CreateInput(flagName, text, placeholder, callback)
    if not SafeAssert("CreateInput", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["placeholder"] = {value = placeholder, types = {"string"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil then Config[flagName] = "" end
    updateGlobalFlags(flagName, Config[flagName])

    local InpFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4}, self.Frame)
    InpFrame:SetAttribute("ThemeRole", "BG_SECONDARY") InpFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, InpFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, InpFrame)
    
    local Label = create("TextLabel", {Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, InpFrame)
    local Box = create("TextBox", {Size = UDim2.new(0, 120, 0, 24), Position = UDim2.new(1, -12, 0.5, -12), AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = Color3.fromRGB(25, 25, 30), Text = Flags[flagName].CurrentValue, PlaceholderText = placeholder, PlaceholderColor3 = Color3.fromRGB(100, 105, 115), TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, ClearTextOnFocus = false}, InpFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, Box)
    create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Box)
    
    local history = {}
    local historyIndex = 0
    
    local function evaluateInputText(val)
        if string.sub(val, 1, 1) == "=" then
            local mathExpression = string.sub(val, 2)
            local safeExpression = string.match(mathExpression, "^[%d%.%+%-%*%/%s%(%)]+$")
            if safeExpression then
                local loadFunc, err = loadstring("return " .. safeExpression)
                if loadFunc then
                    local s, res = pcall(loadFunc)
                    if s and tonumber(res) then
                        return tostring(res)
                    end
                end
            end
        end
        return val
    end

    connect(Box.FocusLost, function()
        local rawText = Box.Text
        local processedText = evaluateInputText(rawText)
        Box.Text = processedText
        
        if processedText ~= "" and history[1] ~= processedText then
            table.insert(history, 1, processedText)
            if #history > 8 then table.remove(history, 9) end
        end
        historyIndex = 0

        updateGlobalFlags(flagName, processedText)
        Config[flagName] = processedText 
        saveConfig() 
        pcall(callback, processedText) 
    end)

    connect(UserInputService.InputBegan, function(input)
        if Box:HasFocus() then
            if input.KeyCode == Enum.KeyCode.Up then
                if historyIndex < #history then
                    historyIndex = historyIndex + 1
                    Box.Text = history[historyIndex]
                end
            elseif input.KeyCode == Enum.KeyCode.Down then
                if historyIndex > 1 then
                    historyIndex = historyIndex - 1
                    Box.Text = history[historyIndex]
                elseif historyIndex == 1 then
                    historyIndex = 0
                    Box.Text = ""
                end
            end
        end
    end)

    task.spawn(pcall, callback, Flags[flagName].CurrentValue)
    self:RegisterElement(InpFrame, Label, self.Frame.Name)
    
    local inputObj = {
        Set = function(_, val) 
            Box.Text = val 
            updateGlobalFlags(flagName, val)
            Config[flagName] = val 
            saveConfig() 
            pcall(callback, val) 
        end,
        GetHistory = function() return history end
    }
    KillerHub.Elements[flagName] = inputObj
    return inputObj
end

function TabMethods:CreateButton(text, callback)
    if not SafeAssert("CreateButton", {
        ["text"] = {value = text, types = {"string"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    local Button = create("TextButton", {Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.3, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamBold, TextSize = 12}, self.Frame)
    Button:SetAttribute("ThemeRole", "BG_SECONDARY") Button:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, Button)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Button)
    
    connect(Button.MouseButton1Click, function() playUISound() pcall(callback) end)
    addInteractiveFeedback(Button)
    self:RegisterElement(Button, Button, self.Frame.Name)

    -- 📌 Shortcut flotante nativo (V4.3) para botones de acción
    attachShortcutHandle(Button, text, "button", function()
        pcall(callback)
    end, function() return text end)
    
    local btnObj = {
        Fire = function() pcall(callback) end
    }
    KillerHub.Elements[text] = btnObj
    return btnObj
end

function TabMethods:CreateKeybind(flagName, text, defaultKey, callback)
    if not SafeAssert("CreateKeybind", {
        ["flagName"] = {value = flagName, types = {"string"}},
        ["text"] = {value = text, types = {"string"}},
        ["defaultKey"] = {value = defaultKey, types = {"EnumItem"}},
        ["callback"] = {value = callback, types = {"function"}}
    }) then return end

    if Config[flagName] == nil then Config[flagName] = defaultKey.Name end
    updateGlobalFlags(flagName, Config[flagName])

    local KFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.4}, self.Frame)
    KFrame:SetAttribute("ThemeRole", "BG_SECONDARY") KFrame:SetAttribute("CustomColorLabel", true)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, KFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, KFrame)
    
    local Lbl = create("TextLabel", {Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, KFrame)
    local BBtn = create("TextButton", {Size = UDim2.new(0, 85, 0, 24), Position = UDim2.new(1, -12, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(30, 30, 35), Text = Config[flagName], TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11}, KFrame)
    BBtn:SetAttribute("ThemeRole", "TEXT_ACCENT")
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, BBtn)
    create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, BBtn)
    
    local listening = false
    connect(BBtn.MouseButton1Click, function() listening = true BBtn.Text = "..." playUISound() end)
    
    connect(UserInputService.InputBegan, function(input, gp)
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false Config[flagName] = input.KeyCode.Name 
                updateGlobalFlags(flagName, input.KeyCode.Name)
                saveConfig() BBtn.Text = input.KeyCode.Name pcall(callback, input.KeyCode)
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 or input.KeyCode == Enum.KeyCode.ButtonX or input.KeyCode == Enum.KeyCode.ButtonY then
                listening = false Config[flagName] = input.UserInputType.Name 
                updateGlobalFlags(flagName, input.UserInputType.Name)
                saveConfig() BBtn.Text = input.UserInputType.Name pcall(callback, input.UserInputType)
            end
        end
    end)

    task.spawn(function()
        local key = Enum.KeyCode[Flags[flagName].CurrentValue] or Enum.UserInputType[Flags[flagName].CurrentValue]
        if key then pcall(callback, key) end
    end)

    addInteractiveFeedback(BBtn)
    self:RegisterElement(KFrame, Lbl, self.Frame.Name)
end

function KillerHub:CreateTab(name, iconId)
    if not SafeAssert("CreateTab", {
        ["name"] = {value = name, types = {"string"}},
        ["iconId"] = {value = iconId, types = {"string", "nil"}}
    }) then return end

    local frame = create("ScrollingFrame", {Name = name .. "Frame", Size = UDim2.new(1, -24, 1, -24), Position = UDim2.new(0, 12, 0, 12), BackgroundColor3 = CurrentTheme.BG_MAIN, BackgroundTransparency = 0.5, Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = CurrentTheme.ACCENT}, ContentContainer)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, frame)
    local stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, frame)
    
    local layout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)}, frame)
    create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}, frame)
    
    local sizeChangedConn = layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20) 
    end)
    table.insert(Connections, sizeChangedConn)

    local btn = create("TextButton", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = ""}, (name == "Settings" and SettingsContainer or SidebarTabsContainer))
    local btnLabel = create("TextLabel", {Size = UDim2.new(1, iconId and -24 or 0, 1, 0), Position = UDim2.new(0, iconId and 24 or 0, 0, 0), BackgroundTransparency = 1, Text = name, TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left}, btn)

    local iconImg
    if iconId then iconImg = create("ImageLabel", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 4, 0.5, -7), BackgroundTransparency = 1, Image = iconId, ImageColor3 = CurrentTheme.TEXT_MUTED}, btn) end
    local line = create("Frame", {Name = "IndicatorLine", Size = UDim2.new(0, 2.5, 0, 14), Position = UDim2.new(0, -4, 0.5, -7), BackgroundColor3 = CurrentTheme.ACCENT, BorderSizePixel = 0, BackgroundTransparency = 1}, btn)
    create("UICorner", {CornerRadius = UDim.new(0, 1)}, line)
    
    local isFirstTab = true for _, _ in pairs(KillerHub.Frames) do isFirstTab = false break end
    KillerHub.Frames[name] = frame KillerHub.Buttons[name] = btn
    -- Se guarda la referencia una sola vez (en vez de FindFirstChild en cada click de pestaña):
    -- más rápido y sin buscar en el árbol de instancias cada vez que se cambia de pestaña
    KillerHub.TabRegistry[name] = {Frame = frame, Btn = btn, Label = btnLabel, Icon = iconImg, Line = line}

    local function selectTab()
        for tName, reg in pairs(KillerHub.TabRegistry) do
            if tName == name then
                reg.Frame.Visible = true
                reg.Label.TextColor3 = CurrentTheme.ACCENT -- pestaña activa: color del tema elegido, no un blanco genérico
                reg.Line.BackgroundTransparency = 0
                if reg.Icon then reg.Icon.ImageColor3 = CurrentTheme.ACCENT end
            else
                reg.Frame.Visible = false
                reg.Label.TextColor3 = CurrentTheme.TEXT_MUTED
                reg.Line.BackgroundTransparency = 1
                if reg.Icon then reg.Icon.ImageColor3 = CurrentTheme.TEXT_MUTED end
            end
        end
        KillerHub.CurrentTab = name
    end
    connect(btn.MouseButton1Click, function() if KillerHub.CurrentTab ~= name then selectTab() playUISound() end end)
    if isFirstTab or name == "Settings" then task.spawn(selectTab) end
    
    table.insert(KillerHub.TargetThemeElements, function()
        frame.BackgroundColor3 = CurrentTheme.BG_MAIN
        stroke.Color = CurrentTheme.BORDER
        line.BackgroundColor3 = CurrentTheme.ACCENT
        if KillerHub.CurrentTab == name then
            btnLabel.TextColor3 = CurrentTheme.ACCENT
            if iconImg then iconImg.ImageColor3 = CurrentTheme.ACCENT end
        else
            btnLabel.TextColor3 = CurrentTheme.TEXT_MUTED
            if iconImg then iconImg.ImageColor3 = CurrentTheme.TEXT_MUTED end
        end
    end)

    local tabObj = setmetatable({ Frame = frame }, TabMethods)
    KillerHub.Tabs[name] = tabObj return tabObj
end

-- 🔎 BÚSQUEDA GLOBAL ACTIVA (V4.3): filtra en tiempo real solo los elementos
-- de la PESTAÑA ACTUAL con .Visible, sin tocar elementos de otras pestañas
-- (así no se rompe el layout cuando el usuario cambia de tab con el filtro puesto).
local searchThread
connect(SearchInput:GetPropertyChangedSignal("Text"), function()
    if searchThread then task.cancel(searchThread) end
    searchThread = task.defer(function()
        task.wait(0.08)
        local q = string.lower(SearchInput.Text)
        local activeTab = KillerHub.CurrentTab
        local count = 0
        for _, el in pairs(KillerHub.AllElements) do
            if el.Instance and el.Label then
                if el.Tab ~= activeTab then
                    -- No tocamos otras pestañas: si el usuario navega, verá su contenido intacto
                else
                    el.Instance.Visible = (q == "") and true or (string.find(string.lower(el.Label.Text or ""), q, 1, true) and true or false)
                end
            end
            count = count + 1
            if count % 30 == 0 then task.wait() end
        end
    end)
end)
-- Al cambiar de pestaña, restablecemos el filtro para que la nueva pestaña se vea completa
-- (evita entrar a un tab y encontrarlo "vacío" por un filtro previo aplicado a otro tab).

-- ============================================================================
-- 🔓 CONFIGURACIÓN BASE OBLIGATORIA (SETTINGS)
-- ============================================================================
local SettingsTab = KillerHub:CreateTab("Settings", "rbxassetid://10747372517")
SettingsTab:CreateSection("Personalización")
SettingsTab:CreateDropdown("SelectedTheme", "Tema Visual:", {"Obsidian", "Void Premium", "Midnight Emerald", "Classic Dark", "Sakura Blossom", "Blood"}, function(selected) KillerHub:SetTheme(selected) end)

local TopFonts = {
    "Gotham", "GothamMedium", "GothamBold", "GothamBlack", "Roboto", "RobotoMono", 
    "SourceSans", "SourceSansBold", "Ubuntu", "FredokaOne", "Arcade", "SciFi"
}
SettingsTab:CreateDropdown("SelectedFont", "Fuente de Texto:", TopFonts, function(selected) KillerHub:SetFont(selected) end)
SettingsTab:CreateSlider("UiOpacity", "Opacidad del Vidrio", 0.3, 1, function(v) updateUiOpacity() end)

SettingsTab:CreateSection("Controles del Menú")
SettingsTab:CreateKeybind("ToggleKey", "Cerrar / Abrir Menu (PC)", Enum.KeyCode.RightControl, function(key)
    print("Se presionó la tecla: " .. tostring(key))
end)
SettingsTab:CreateSlider("ToggleBtnSize", "Tamaño de Botón Flotante", 30, 80, function(v) updateButtonSize() end)
SettingsTab:CreateSlider("Volume", "Volumen Interfaz", 0, 1, function(v) Config.Volume = v end)
SettingsTab:CreateSlider("GuiWidth", "Ajustar Ancho Ventana", 0, 1, function(v) updateGuiSize() end)
SettingsTab:CreateSlider("GuiHeight", "Ajustar Alto Ventana", 0, 1, function(v) updateGuiSize() end)

SettingsTab:CreateSection("Configuración Multi-Juego")
SettingsTab:CreateParagraph("💾 Perfil automático por Place ID", "Tus ajustes se guardan por juego. Este es el ID exacto del lugar actual:\nGame ID: " .. CURRENT_PLACE_ID .. "\nArchivo: " .. CONFIG_FILE)

SettingsTab:CreateSection("Seguridad y Limpieza")
SettingsTab:CreateParagraph("⚠️ ADVERTENCIA DE APAGADO", "Si decides apagar el script (Unload), la interfaz se cerrará y se eliminará por completo de la memoria.")
SettingsTab:CreateButton("Apagar Script por Completo (Unload)", function() KillerHub:Unload() end)

task.defer(function() KillerHub:SetTheme(Config.SelectedTheme or "Obsidian") end)

-- Publicación y Sincronización Inicial de Flags globales
getgenv().KillerHub = KillerHub
getgenv().KillerHub.Flags = Flags

return KillerHub
