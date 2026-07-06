-- ===========================================================================
-- 👻 KILLER HUB UNIVERSAL FRAMEWORK | CRIMSON DARK PREMIUM EDITION (V2.8.0)
-- 🧑‍💻 Desarrollado por: Paolo & AI Optimizer
-- 📱 Fix: Auto-Guardado Universal, Anti-Bypass Premium & Opacidad Extrema
-- 🔐 Security Layer: Anti-Tamper, Account Lock & Premium Verification Engine
-- ===========================================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Contenedor seguro multi-ejecutor móvil
local TargetParent = (gethui and gethui()) or (pcall(function() return game:GetService("CoreGui").Name end) and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")

if TargetParent:FindFirstChild("KillerHub_Universal") then
    TargetParent.KillerHub_Universal:Destroy()
end

-- ============================================================================
-- 🎨 PALETAS DE ESTILO (RENOVADO: NEGRO ABSOLUTO, ROJO SANGRE Y TEXTOS LIMPIOS)
-- ============================================================================
local Themes = {
    ["Black Glass"] = {
        BG_MAIN = Color3.fromRGB(10, 10, 12),          -- Negro Sólido Limpio
        BG_SIDEBAR = Color3.fromRGB(6, 6, 8),          -- Sidebar Mate sin doble capa
        BG_SECONDARY = Color3.fromRGB(18, 18, 22),     -- Contenedores internos oscuros
        ACCENT = Color3.fromRGB(205, 16, 16),          -- Rojo Sangre Puro
        TEXT_WHITE = Color3.fromRGB(245, 245, 245),
        TEXT_MUTED = Color3.fromRGB(130, 135, 145),
        BORDER = Color3.fromRGB(35, 35, 40)            -- Bordes oscuros, minimalistas y limpies
    },
    ["Void Premium"] = {
        BG_MAIN = Color3.fromRGB(8, 5, 12),
        BG_SIDEBAR = Color3.fromRGB(11, 8, 16),
        BG_SECONDARY = Color3.fromRGB(15, 11, 22),
        ACCENT = Color3.fromRGB(138, 43, 226),
        TEXT_WHITE = Color3.fromRGB(245, 240, 255),
        TEXT_MUTED = Color3.fromRGB(130, 115, 145),
        BORDER = Color3.fromRGB(40, 20, 65)
    },
    ["Midnight Emerald"] = {
        BG_MAIN = Color3.fromRGB(10, 12, 11),
        BG_SIDEBAR = Color3.fromRGB(13, 16, 14),
        BG_SECONDARY = Color3.fromRGB(16, 22, 18),
        ACCENT = Color3.fromRGB(0, 230, 115),
        TEXT_WHITE = Color3.fromRGB(245, 245, 245),
        TEXT_MUTED = Color3.fromRGB(130, 140, 130),
        BORDER = Color3.fromRGB(28, 38, 32)
    },
    ["Classic Dark"] = {
        BG_MAIN = Color3.fromRGB(15, 15, 15),
        BG_SIDEBAR = Color3.fromRGB(20, 20, 20),
        BG_SECONDARY = Color3.fromRGB(25, 25, 25),
        ACCENT = Color3.fromRGB(245, 245, 245),
        TEXT_WHITE = Color3.fromRGB(245, 245, 245),
        TEXT_MUTED = Color3.fromRGB(130, 130, 130),
        BORDER = Color3.fromRGB(40, 40, 40)
    },
    ["Blood"] = {
        BG_MAIN = Color3.fromRGB(10, 10, 10),
        BG_SIDEBAR = Color3.fromRGB(14, 12, 12),
        BG_SECONDARY = Color3.fromRGB(18, 14, 14),
        ACCENT = Color3.fromRGB(185, 15, 15),
        TEXT_WHITE = Color3.fromRGB(255, 255, 255),
        TEXT_MUTED = Color3.fromRGB(135, 105, 105),
        BORDER = Color3.fromRGB(46, 20, 20)
    }
}

local CurrentTheme = Themes["Black Glass"]

-- ============================================================================
-- 📦 API CORE Y MOTOR REACTIVO + ECO-SYSTEM PREMIUM
-- ============================================================================
local KillerHub = {
    Tabs = {}, Frames = {}, Buttons = {}, Config = {}, Flags = {},
    CurrentTab = nil, AllElements = {}, TargetThemeElements = {}, _Trash = {},
    PremiumIDs = { 11224455930, 312419911 }, -- Agrega tu ID de roblox aquí si deseas
    PremiumFeatures = {} -- Mapeo estricto interno para saber qué banderas son Premium
}

-- Verificar si el jugador actual tiene acceso Premium real
local function checkPremiumAccess()
    if getgenv().KillerHub and getgenv().KillerHub.OwnerID then
        if LocalPlayer.UserId == getgenv().KillerHub.OwnerID then return true end
    end
    if _G.IsPremium == true then return true end
    return table.find(KillerHub.PremiumIDs, LocalPlayer.UserId) ~= nil
end

-- ============================================================================
-- 💾 SISTEMA DE CONFIGURACIÓN AVANZADO + PROTECCIÓN INTEGRADA ANTI-TAMPER
-- ============================================================================
local CONFIG_FILE = "KillerHub_Core_Config.json"
local DefaultConfig = {
    Volume = 0.5, ToggleKey = "RightControl", SelectedTheme = "Black Glass", SelectedFont = "GothamMedium",
    GuiWidth = 0.466, GuiHeight = 0.4, UiOpacity = 0.95, ToggleBtnSize = 46,
    MainFrameX = 0, MainFrameY = 0,
    BtnX = 15, BtnY = 100, SavedOwner = LocalPlayer.UserId
}

local function copyTable(target, source)
    for k, v in pairs(source) do
        if type(v) == "table" then 
            target[k] = {} 
            copyTable(target[k], v) 
        else 
            target[k] = v 
        end
    end
end
copyTable(KillerHub.Config, DefaultConfig)
local Config = KillerHub.Config
local Flags = KillerHub.Flags
local Connections = {}

local function connect(event, callback)
    local conn = event:Connect(callback)
    table.insert(Connections, conn)
    return conn
end

-- Filtro de Seguridad en Caliente al guardar
local function saveConfig()
    if writefile then 
        pcall(function() 
            local cleanConfig = {}
            for k, v in pairs(Config) do
                -- Si es una flag mapeada como premium y el usuario no tiene los permisos, forzar false antes de codificar
                if KillerHub.PremiumFeatures[k] and not checkPremiumAccess() then
                    cleanConfig[k] = false
                else
                    cleanConfig[k] = v
                end
            end
            writefile(CONFIG_FILE, HttpService:JSONEncode(cleanConfig)) 
        end) 
    end
end

local function create(instanceType, properties, parent)
    local obj = Instance.new(instanceType)
    for prop, val in pairs(properties) do obj[prop] = val end
    if parent then obj.Parent = parent end
    return obj
end

-- ============================================================================
-- 🖥 INTERFAZ BASE TOTALMENTE ADAPTABLE
-- ============================================================================
local ScreenGui = create("ScreenGui", {Name = "KillerHub_Universal", IgnoreGuiInset = false, ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets, ResetOnSpawn = false, DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, TargetParent)

local function playUISound()
    if not Config.Volume or Config.Volume <= 0 then return end
    local sound = create("Sound", {SoundId = "rbxassetid://101735926591481", Volume = Config.Volume}, ScreenGui)
    sound:Play() Debris:AddItem(sound, 1.5)
end

local MainFrame = create("Frame", {Name = "MainFrame", BackgroundColor3 = CurrentTheme.BG_MAIN, BorderSizePixel = 0, Active = true, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, Config.MainFrameX or 0, 0.5, Config.MainFrameY or 0)}, ScreenGui)
local MainStroke = create("UIStroke", {Thickness = 1.2, Color = CurrentTheme.BORDER, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, MainFrame)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, MainFrame)

local function updateGuiSize()
    MainFrame.Size = UDim2.new(0, math.floor(430 + ((Config.GuiWidth or 0.466) * 280)), 0, math.floor(280 + ((Config.GuiHeight or 0.4) * 230)))
end
updateGuiSize()

local Topbar = create("Frame", {Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = CurrentTheme.BG_SIDEBAR, BorderSizePixel = 0, Active = true}, MainFrame)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, Topbar)
local TopbarPatch = create("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = CurrentTheme.BG_SIDEBAR, BorderSizePixel = 0}, Topbar)

local Title = create("TextLabel", {
    Size = UDim2.new(0, 250, 1, 0), Position = UDim2.new(0, 16, 0, 0), BackgroundTransparency = 1,
    Text = "Killer Hub | Premium 👻", TextColor3 = CurrentTheme.ACCENT,
    TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextSize = 13,
    TextStrokeTransparency = 1 
}, Topbar)

local PerformanceLabel = create("TextLabel", {
    Size = UDim2.new(0, 160, 1, 0), Position = UDim2.new(1, -15, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1,
    Text = "FPS: -- | PING: --", TextColor3 = CurrentTheme.TEXT_MUTED,
    TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.GothamMedium, TextSize = 11,
    TextStrokeTransparency = 1
}, Topbar)

task.spawn(function()
    while task.wait(1) do
        if ScreenGui and ScreenGui.Parent then
            local fps = math.floor(Workspace:GetRealPhysicsFPS())
            local ping = 0
            local successNetwork = pcall(function()
                if Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerToClientPing") then
                    ping = math.floor(Stats.Network.ServerToClientPing:GetValue())
                end
            end)
            if not successNetwork or ping == 0 then
                pcall(function() ping = math.floor(LocalPlayer:GetNetworkPing() * 1000) end)
            end
            PerformanceLabel.Text = string.format("FPS: %d | PING: %dms", fps, ping)
        else break end
    end
end)

local function makeDraggable(clickObject, dragObject)
    local dragging, dragStart, startPos, activeInput
    connect(clickObject.InputBegan, function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragging then
            dragging = true activeInput = input dragStart = input.Position startPos = dragObject.Position
        end
    end)
    connect(UserInputService.InputChanged, function(input)
        if dragging and input == activeInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            task.defer(function()
                if not dragging or activeInput ~= input then return end
                local delta = input.Position - dragStart
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
    connect(UserInputService.InputEnded, function(input)
        if input == activeInput then
            dragging = false activeInput = nil
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

makeDraggable(Topbar, MainFrame)

local Sidebar = create("Frame", {Name = "Sidebar", Size = UDim2.new(0, 125, 1, -42), Position = UDim2.new(0, 0, 0, 42), BackgroundColor3 = CurrentTheme.BG_SIDEBAR, BorderSizePixel = 0, Active = true}, MainFrame)
local SidebarLine = create("Frame", {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = CurrentTheme.BORDER, BorderSizePixel = 0}, Sidebar)

local SearchBoxContainer = create("Frame", {Size = UDim2.new(1, -12, 0, 26), Position = UDim2.new(0, 6, 0, 8), BackgroundColor3 = CurrentTheme.BG_SECONDARY}, Sidebar)
create("UICorner", {CornerRadius = UDim.new(0, 6)}, SearchBoxContainer)
local SearchStroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, SearchBoxContainer)

local SearchInput = create("TextBox", {
    Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1,
    PlaceholderText = "Buscar...", PlaceholderColor3 = CurrentTheme.TEXT_MUTED, Text = "",
    TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, ClearTextOnFocus = false
}, SearchBoxContainer)

local SidebarTabsContainer = create("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -85), Position = UDim2.new(0, 0, 0, 38), BackgroundTransparency = 1,
    ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), ScrollingDirection = Enum.ScrollingDirection.Y, BorderSizePixel = 0
}, Sidebar)
local tabsLayout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, SidebarTabsContainer)
create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, SidebarTabsContainer)

local tabsSizeConn = tabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SidebarTabsContainer.CanvasSize = UDim2.new(0, 0, 0, tabsLayout.AbsoluteContentSize.Y + 10)
end)
table.insert(Connections, tabsSizeConn)

local SettingsContainer = create("Frame", {Size = UDim2.new(1, -12, 0, 36), Position = UDim2.new(0, 6, 1, -42), BackgroundTransparency = 1}, Sidebar)
local ContentContainer = create("Frame", {Name = "ContentContainer", Size = UDim2.new(1, -125, 1, -42), Position = UDim2.new(0, 125, 0, 42), BackgroundTransparency = 1, Active = true}, MainFrame)

local OpenCloseBtn = create("TextButton", {Name = "KillerHubToggle", Size = UDim2.new(0, 46, 0, 46), Position = UDim2.new(0, Config.BtnX or 15, 0, Config.BtnY or 100), BackgroundColor3 = CurrentTheme.BG_MAIN, Text = "", Active = true}, ScreenGui)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, OpenCloseBtn)
local FloatingStroke = create("UIStroke", {Thickness = 1.2, Color = CurrentTheme.BORDER}, OpenCloseBtn)
local BtnIcon = create("ImageLabel", {Name = "Icon", Size = UDim2.new(1, 0, 1, 0), ScaleType = Enum.ScaleType.Crop, BackgroundTransparency = 1, Image = "rbxassetid://84689030731870", ImageColor3 = CurrentTheme.ACCENT}, OpenCloseBtn)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, BtnIcon)

makeDraggable(OpenCloseBtn, OpenCloseBtn)

local function updateUiOpacity()
    local opacity = Config.UiOpacity or 0.95
    MainFrame.BackgroundTransparency = 1 - opacity
    Topbar.BackgroundTransparency = 1 - opacity
    TopbarPatch.BackgroundTransparency = Topbar.BackgroundTransparency
    Sidebar.BackgroundTransparency = 1 - opacity
end

local function updateButtonSize()
    local s = Config.ToggleBtnSize or 46
    OpenCloseBtn.Size = UDim2.new(0, s, 0, s)
end

updateUiOpacity()
updateButtonSize()

local menuVisible = true
local function setMenuVisibility(visible)
    menuVisible = visible MainFrame.Visible = visible
    BtnIcon.ImageColor3 = visible and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE
end
connect(OpenCloseBtn.MouseButton1Click, function() playUISound() setMenuVisibility(not menuVisible) end)

connect(UserInputService.InputBegan, function(input, gp)
    if not gp and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == (Config.ToggleKey or "RightControl") then
        playUISound() setMenuVisibility(not menuVisible)
    end
end)

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

function KillerHub:Unload()
    for _, conn in ipairs(Connections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    for _, item in ipairs(self._Trash) do
        if typeof(item) == "RBXScriptConnection" then pcall(function() item:Disconnect() end)
        elseif type(item) == "thread" then pcall(function() task.cancel(item) end)
        elseif typeof(item) == "Instance" then pcall(function() item:Destroy() end) end
    end
    if ScreenGui then ScreenGui:Destroy() end
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
    Title.TextColor3 = CurrentTheme.ACCENT
    PerformanceLabel.TextColor3 = CurrentTheme.TEXT_MUTED
    SearchBoxContainer.BackgroundColor3 = CurrentTheme.BG_SECONDARY
    SearchStroke.Color = CurrentTheme.BORDER
    SearchInput.TextColor3 = CurrentTheme.TEXT_WHITE
    SearchInput.PlaceholderColor3 = CurrentTheme.TEXT_MUTED
    OpenCloseBtn.BackgroundColor3 = CurrentTheme.BG_MAIN
    FloatingStroke.Color = CurrentTheme.BORDER
    BtnIcon.ImageColor3 = menuVisible and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE

    for _, refreshCallback in ipairs(KillerHub.TargetThemeElements) do
        pcall(refreshCallback)
    end
    self:SetFont(Config.SelectedFont or "GothamMedium")
end

local TabMethods = {}
TabMethods.__index = TabMethods

function TabMethods:RegisterElement(inst, textLabel, tabName)
    table.insert(KillerHub.AllElements, {Instance = inst, Label = textLabel, Tab = tabName})
    task.defer(function() KillerHub:SetFont(Config.SelectedFont or "GothamMedium") end)
end

function TabMethods:CreateParagraph(title, text)
    local Frame = create("Frame", {Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.1}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, Frame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Frame)
    
    local Tl = create("TextLabel", {Size = UDim2.new(1, -24, 0, 16), Position = UDim2.new(0, 12, 0, 5), BackgroundTransparency = 1, Text = title, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 1}, Frame)
    local Tx = create("TextLabel", {Size = UDim2.new(1, -24, 0, 22), Position = UDim2.new(0, 12, 0, 21), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamMedium, TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextStrokeTransparency = 1}, Frame)
    
    table.insert(KillerHub.TargetThemeElements, function()
        Frame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        Tl.TextColor3 = CurrentTheme.ACCENT
        Tx.TextColor3 = CurrentTheme.TEXT_MUTED
    end)
    self:RegisterElement(Frame, Tl, self.Frame.Name)
    return {SetTitle = function(_, t) Tl.Text = t end, SetText = function(_, t) Tx.Text = t end}
end

function TabMethods:CreateSection(text)
    local SectionFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1}, self.Frame)
    local Label = create("TextLabel", {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 4, 0, 0), BackgroundTransparency = 1, Text = string.upper(text), TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 0.1, TextStrokeTransparency = 1}, SectionFrame)
    
    table.insert(KillerHub.TargetThemeElements, function()
        Label.TextColor3 = CurrentTheme.ACCENT
    end)
    
    self:RegisterElement(SectionFrame, Label, self.Frame.Name)
    return {
        SetText = function(_, newText) Label.Text = string.upper(newText) end
    }
end

function TabMethods:CreateToggle(flagName, text, callback, isPremium)
    if isPremium then KillerHub.PremiumFeatures[flagName] = true end
    local isAuthorized = not isPremium or checkPremiumAccess()
    
    -- [CAPA DE SEGURIDAD MÁXIMA]
    if isPremium and not isAuthorized then
        Config[flagName] = false
    end

    if Config[flagName] == nil then Config[flagName] = false end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    
    local displayTitle = isPremium and (isAuthorized and ("👑 " .. text) or ("🔒 " .. text)) or text
    local buttonBG = isAuthorized and CurrentTheme.BG_SECONDARY or Color3.fromRGB(20, 20, 25)
    
    local ToggleButton = create("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = buttonBG, BackgroundTransparency = 0.1, Text = "", AutoButtonColor = isAuthorized}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, ToggleButton)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, ToggleButton)
    
    local labelColor = isAuthorized and (Config[flagName] and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED) or Color3.fromRGB(80, 80, 90)
    local ToggleLabel = create("TextLabel", {Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = displayTitle, TextColor3 = labelColor, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12, TextStrokeTransparency = 1}, ToggleButton)
    
    local trackBG = isAuthorized and (Config[flagName] and CurrentTheme.ACCENT or Color3.fromRGB(30, 30, 35)) or Color3.fromRGB(20, 20, 22)
    local Track = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = trackBG}, ToggleButton)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Track)
    local Knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = Config[flagName] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    local function stateUpdate()
        isAuthorized = not isPremium or checkPremiumAccess()
        if isPremium and not isAuthorized then
            Flags[flagName].CurrentValue = false
            Config[flagName] = false
            ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            ToggleLabel.TextColor3 = Color3.fromRGB(80, 80, 90)
            ToggleLabel.Text = "🔒 " .. text
            Track.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
            Knob.Position = UDim2.new(0, 2, 0.5, -7)
            return
        end
        local active = Flags[flagName].CurrentValue
        ToggleButton.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        ToggleLabel.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
        ToggleLabel.Text = isPremium and ("👑 " .. text) or text
        
        TweenService:Create(Track, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(45, 45, 55)
        }):Play()
        
        TweenService:Create(Knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
    end
    
    connect(ToggleButton.MouseButton1Click, function()
        if isPremium and not checkPremiumAccess() then 
            warn("❌ [KillerHub Access] Esta función requiere acceso Premium.")
            return 
        end
        local nextState = not Flags[flagName].CurrentValue
        Flags[flagName].CurrentValue = nextState Config[flagName] = nextState saveConfig() playUISound()
        task.spawn(function() stateUpdate() end)
        task.spawn(callback, nextState)
    end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        stateUpdate()
        Stroke.Color = CurrentTheme.BORDER
    end)

    task.spawn(function()
        stateUpdate()
        if isAuthorized and Flags[flagName].CurrentValue then
            pcall(callback, true)
        end
    end)

    self:RegisterElement(ToggleButton, ToggleLabel, self.Frame.Name)
    return {Set = function(_, bool) 
        if isPremium and not checkPremiumAccess() then return end 
        Flags[flagName].CurrentValue = bool Config[flagName] = bool saveConfig() stateUpdate() pcall(callback, bool) 
    end}
end

function TabMethods:CreateToggleSlider(flagToggle, flagSlider, text, min, max, callbackToggle, callbackSlider, isPremium)
    if isPremium then 
        KillerHub.PremiumFeatures[flagToggle] = true 
        KillerHub.PremiumFeatures[flagSlider] = true
    end
    local isAuthorized = not isPremium or checkPremiumAccess()
    
    -- [CAPA DE SEGURIDAD MÁXIMA]
    if isPremium and not isAuthorized then
        Config[flagToggle] = false
    end

    if Config[flagToggle] == nil then Config[flagToggle] = false end
    if Config[flagSlider] == nil then Config[flagSlider] = min end
    Flags[flagToggle] = { CurrentValue = Config[flagToggle] }
    Flags[flagSlider] = { CurrentValue = Config[flagSlider] }
    
    local displayTitle = isPremium and (isAuthorized and ("👑 " .. text) or ("🔒 " .. text)) or text
    local buttonBG = isAuthorized and CurrentTheme.BG_SECONDARY or Color3.fromRGB(20, 20, 25)
    
    local TSFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = buttonBG, BackgroundTransparency = 0.1}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, TSFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, TSFrame)
    
    local ToggleButton = create("TextButton", {Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Text = "", AutoButtonColor = isAuthorized}, TSFrame)
    local labelColor = isAuthorized and (Config[flagToggle] and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED) or Color3.fromRGB(80, 80, 90)
    local ToggleLabel = create("TextLabel", {Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = displayTitle, TextColor3 = labelColor, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12, TextStrokeTransparency = 1}, ToggleButton)
    
    local trackBG = isAuthorized and (Config[flagToggle] and CurrentTheme.ACCENT or Color3.fromRGB(45, 45, 55)) or Color3.fromRGB(20, 20, 22)
    local Track = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = trackBG}, ToggleButton)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Track)
    local Knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = Config[flagToggle] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    local SliderContainer = create("Frame", {Size = UDim2.new(1, -24, 0, 16), Position = UDim2.new(0, 12, 0, 26), BackgroundTransparency = 1}, TSFrame)
    local ValueBox = create("TextBox", {Size = UDim2.new(0, 45, 1, 0), Position = UDim2.new(1, 0, 0, -2), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, ClearTextOnFocus = false, Editable = isAuthorized}, SliderContainer)
    
    local STrack = create("Frame", {Size = UDim2.new(1, -50, 0, 4), Position = UDim2.new(0, 0, 0.5, -2), BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, SliderContainer)
    create("UICorner", {CornerRadius = UDim.new(0, 2)}, STrack)
    local SFill = create("Frame", {BackgroundColor3 = isAuthorized and CurrentTheme.ACCENT or Color3.fromRGB(50, 50, 55)}, STrack)
    create("UICorner", {CornerRadius = UDim.new(0, 2)}, SFill)
    
    local SKnob = create("TextButton", {Size = UDim2.new(0, 10, 0, 10), BackgroundColor3 = CurrentTheme.TEXT_WHITE, Text = "", AutoButtonColor = isAuthorized}, STrack)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, SKnob)

    local function stateUpdate()
        isAuthorized = not isPremium or checkPremiumAccess()
        if isPremium and not isAuthorized then
            Flags[flagToggle].CurrentValue = false
            Config[flagToggle] = false
            TSFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            ToggleLabel.TextColor3 = Color3.fromRGB(80, 80, 90)
            ToggleLabel.Text = "🔒 " .. text
            Track.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
            Knob.Position = UDim2.new(0, 2, 0.5, -7)
            SFill.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            ValueBox.Text = "🔒"
            return
        end
        local active = Flags[flagToggle].CurrentValue
        TSFrame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        ToggleLabel.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
        ToggleLabel.Text = isPremium and ("👑 " .. text) or text
        Track.BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(45, 45, 55)
        Knob.Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        SFill.BackgroundColor3 = CurrentTheme.ACCENT
    end

    local function runSliderValue(v, skipCallback)
        if isPremium and not checkPremiumAccess() then return end
        v = math.clamp(v, min, max) Flags[flagSlider].CurrentValue = v Config[flagSlider] = v saveConfig()
        local pct = (max == min) and 0 or (v - min) / (max - min)
        
        SFill.Size = UDim2.new(pct, 0, 1, 0)
        SKnob.Position = UDim2.new(pct, -5, 0.5, -5)
        if max <= 1 then ValueBox.Text = string.format("%.2f", v) else ValueBox.Text = tostring(math.floor(v)) end
        if not skipCallback then pcall(callbackSlider, v) end
    end

    connect(ToggleButton.MouseButton1Click, function()
        if isPremium and not checkPremiumAccess() then return end
        local nextState = not Flags[flagToggle].CurrentValue
        Flags[flagToggle].CurrentValue = nextState Config[flagToggle] = nextState saveConfig() playUISound()
        stateUpdate() pcall(callbackToggle, nextState)
    end)

    connect(ValueBox.FocusLost, function()
        if isPremium and not checkPremiumAccess() then return end
        local inputNum = tonumber(ValueBox.Text)
        if not inputNum then runSliderValue(Flags[flagSlider].CurrentValue) else runSliderValue(inputNum) end
    end)

    local sliding = false
    local function snap(input)
        if isPremium and not checkPremiumAccess() then return end
        local pct = math.clamp((input.Position.X - STrack.AbsolutePosition.X) / STrack.AbsoluteSize.X, 0, 1)
        runSliderValue(min + (pct * (max - min)))
    end

    local dragConn, endConn
    connect(SKnob.InputBegan, function(input)
        if isPremium and not checkPremiumAccess() then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true snap(input)
            dragConn = UserInputService.InputChanged:Connect(function(changedInput)
                if sliding and (changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput.UserInputType == Enum.UserInputType.Touch) then snap(changedInput) end
            end)
            endConn = UserInputService.InputEnded:Connect(function(endedInput)
                if endedInput.UserInputType == Enum.UserInputType.MouseButton1 or endedInput.UserInputType == Enum.UserInputType.Touch then
                    sliding = false if dragConn then dragConn:Disconnect() end if endConn then endConn:Disconnect() end
                end
            end)
        end
    end)

    table.insert(KillerHub.TargetThemeElements, function()
        Stroke.Color = CurrentTheme.BORDER
        ValueBox.TextColor3 = CurrentTheme.ACCENT
        stateUpdate() runSliderValue(Flags[flagSlider].CurrentValue, true)
    end)

    task.spawn(function()
        stateUpdate() 
        if isAuthorized then
            runSliderValue(Flags[flagSlider].CurrentValue, true)
            if Flags[flagToggle].CurrentValue then pcall(callbackToggle, true) end
            pcall(callbackSlider, Flags[flagSlider].CurrentValue)
        end
    end)

    self:RegisterElement(TSFrame, ToggleLabel, self.Frame.Name)
    return {
        SetToggle = function(_, bool) if isPremium and not checkPremiumAccess() then return end Flags[flagToggle].CurrentValue = bool Config[flagToggle] = bool saveConfig() stateUpdate() pcall(callbackToggle, bool) end,
        SetSlider = function(_, value) if isPremium and not checkPremiumAccess() then return end runSliderValue(value) end
    }
end

function TabMethods:CreateSlider(flagName, text, min, max, callback)
    if Config[flagName] == nil then Config[flagName] = min end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    
    local SliderFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Active = true}, self.Frame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -60, 0, 18), Position = UDim2.new(0, 2, 0, 2), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 1}, SliderFrame)
    local ValueBox = create("TextBox", {Size = UDim2.new(0, 50, 0, 18), Position = UDim2.new(1, -2, 0, 2), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, ClearTextOnFocus = false}, SliderFrame)
    local Track = create("Frame", {Size = UDim2.new(1, -4, 0, 6), Position = UDim2.new(0, 2, 0, 24), BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, SliderFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 3)}, Track)
    local Fill = create("Frame", {BackgroundColor3 = CurrentTheme.ACCENT}, Track)
    create("UICorner", {CornerRadius = UDim.new(0, 3)}, Fill)
    
    local Knob = create("TextButton", {Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = CurrentTheme.TEXT_WHITE, Text = "", AutoButtonColor = false}, Track)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, Knob)

    local function runSliderValue(v, skipCallback)
        v = math.clamp(v, min, max) Flags[flagName].CurrentValue = v Config[flagName] = v saveConfig()
        local pct = (max == min) and 0 or (v - min) / (max - min)
        
        Fill.Size = UDim2.new(pct, 0, 1, 0)
        Knob.Position = UDim2.new(pct, -6, 0.5, -6)
        if max <= 1 then ValueBox.Text = string.format("%.2f", v) else ValueBox.Text = tostring(math.floor(v)) end
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
            dragConn = UserInputService.InputChanged:Connect(function(changedInput)
                if sliding and (changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput.UserInputType == Enum.UserInputType.Touch) then snap(changedInput) end
            end)
            endConn = UserInputService.InputEnded:Connect(function(endedInput)
                if endedInput.UserInputType == Enum.UserInputType.MouseButton1 or endedInput.UserInputType == Enum.UserInputType.Touch then
                    sliding = false if dragConn then dragConn:Disconnect() end if endConn then endConn:Disconnect() end
                end
            end)
        end
    end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        ValueBox.TextColor3 = CurrentTheme.ACCENT
        Fill.BackgroundColor3 = CurrentTheme.ACCENT
        runSliderValue(Flags[flagName].CurrentValue, true)
    end)

    task.spawn(function()
        runSliderValue(Flags[flagName].CurrentValue, true)
        pcall(callback, Flags[flagName].CurrentValue)
    end)

    self:RegisterElement(SliderFrame, Label, self.Frame.Name)
    return {Set = function(_, value) runSliderValue(value) end}
end

function TabMethods:CreateDropdown(flagName, text, options, callback)
    if Config[flagName] == nil then Config[flagName] = options[1] or "" end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    
    local DDFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.1, ClipsDescendants = true}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, DDFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, DDFrame)
    local Trigger = create("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = ""}, DDFrame)
    
    local Label = create("TextLabel", {Size = UDim2.new(0.5, -12, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 1}, Trigger)
    local SelLabel = create("TextLabel", {Size = UDim2.new(0.5, -38, 1, 0), Position = UDim2.new(1, -38, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = Flags[flagName].CurrentValue, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, TextStrokeTransparency = 1}, Trigger)
    local Arrow = create("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -22, 0.5, -10), BackgroundTransparency = 1, Text = "▼", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 11, TextStrokeTransparency = 1}, Trigger)
    
    local hasSearch = #options > 6
    local searchHeight = hasSearch and 30 or 0
    local SearchBox
    
    if hasSearch then
        SearchBox = create("TextBox", {
            Size = UDim2.new(1, -16, 0, 24), Position = UDim2.new(0, 8, 0, 34),
            BackgroundColor3 = Color3.fromRGB(24, 24, 28), Text = "", PlaceholderText = "Filtrar opciones...",
            PlaceholderColor3 = CurrentTheme.TEXT_MUTED, TextColor3 = CurrentTheme.TEXT_WHITE,
            Font = Enum.Font.GothamMedium, TextSize = 11, ClearTextOnFocus = false, Visible = false
        }, DDFrame)
        create("UICorner", {CornerRadius = UDim.new(0, 5)}, SearchBox)
        create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, SearchBox)
    end
    
    local OptsScroll = create("ScrollingFrame", {Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 34 + searchHeight), BackgroundTransparency = 1, ScrollBarThickness = 2}, DDFrame)
    local layout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, OptsScroll)

    local open = false
    connect(Trigger.MouseButton1Click, function()
        open = not open playUISound()
        local targetH = open and math.min(layout.AbsoluteContentSize.Y, 120) or 0
        if SearchBox then SearchBox.Visible = open if not open then SearchBox.Text = "" end end
        
        TweenService:Create(DDFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 34 + targetH + searchHeight + (open and 6 or 0))}):Play()
        TweenService:Create(OptsScroll, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -16, 0, targetH)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = open and 180 or 0}):Play()
        OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    local function makeOptions()
        for _, child in ipairs(OptsScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for i, name in ipairs(options) do
            local OptBtn = create("TextButton", {Size = UDim2.new(1, -4, 0, 28), BackgroundColor3 = Color3.fromRGB(26, 26, 32), Text = name, TextColor3 = (name == Flags[flagName].CurrentValue) and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, LayoutOrder = i}, OptsScroll)
            create("UICorner", {CornerRadius = UDim.new(0, 5)}, OptBtn)
            
            connect(OptBtn.MouseButton1Click, function()
                Flags[flagName].CurrentValue = name Config[flagName] = name saveConfig() SelLabel.Text = name playUISound() open = false
                if SearchBox then SearchBox.Text = "" SearchBox.Visible = false end
                TweenService:Create(DDFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 34)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0}):Play()
                pcall(callback, name) makeOptions()
            end)
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
                DDFrame.Size = UDim2.new(1, 0, 0, 34 + targetH + searchHeight + 6)
                OptsScroll.Size = UDim2.new(1, -16, 0, targetH)
                OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
            end)
        end)
    end

    table.insert(KillerHub.TargetThemeElements, function()
        DDFrame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        SelLabel.TextColor3 = CurrentTheme.ACCENT
        Arrow.TextColor3 = CurrentTheme.TEXT_MUTED
        if SearchBox then SearchBox.PlaceholderColor3 = CurrentTheme.TEXT_MUTED SearchBox.TextColor3 = CurrentTheme.TEXT_WHITE end
        makeOptions()
    end)

    makeOptions()
    
    task.spawn(function()
        if Flags[flagName].CurrentValue ~= "" then
            pcall(callback, Flags[flagName].CurrentValue)
        end
    end)

    self:RegisterElement(DDFrame, Label, self.Frame.Name)
    return {Refresh = function(_, newOptions) options = newOptions hasSearch = #options > 6 searchHeight = hasSearch and 30 or 0 if SearchBox then SearchBox.Visible = open and hasSearch end makeOptions() end}
end

function TabMethods:CreateMultiDropdown(flagName, text, options, callback)
    if Config[flagName] == nil or type(Config[flagName]) ~= "table" then Config[flagName] = {} end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    
    local MFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.1, ClipsDescendants = true}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, MFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, MFrame)
    local Trigger = create("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = ""}, MFrame)
    
    local Label = create("TextLabel", {Size = UDim2.new(0.5, -12, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 1}, Trigger)
    local SelLabel = create("TextLabel", {Size = UDim2.new(0.5, -38, 1, 0), Position = UDim2.new(1, -38, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = "...", TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, TextStrokeTransparency = 1}, Trigger)
    local Arrow = create("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -22, 0.5, -10), BackgroundTransparency = 1, Text = "▼", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 11, TextStrokeTransparency = 1}, Trigger)
    
    local OptsScroll = create("ScrollingFrame", {Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 34), BackgroundTransparency = 1, ScrollBarThickness = 2}, MFrame)
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
        
        TweenService:Create(MFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 34 + targetH + (open and 6 or 0))}):Play()
        TweenService:Create(OptsScroll, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -16, 0, targetH)}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = open and 180 or 0}):Play()
        OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    local function makeList()
        for _, child in ipairs(OptsScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for i, name in ipairs(options) do
            local isChosen = Config[flagName][name] or false
            local OptBtn = create("TextButton", {Size = UDim2.new(1, -4, 0, 28), BackgroundColor3 = isChosen and CurrentTheme.BG_MAIN or Color3.fromRGB(26, 26, 32), Text = name, TextColor3 = isChosen and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, LayoutOrder = i}, OptsScroll)
            create("UICorner", {CornerRadius = UDim.new(0, 5)}, OptBtn)
            
            connect(OptBtn.MouseButton1Click, function()
                Config[flagName][name] = not Config[flagName][name]
                saveConfig() playUISound() updateText() makeList() pcall(callback, Config[flagName])
            end)
        end
        OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end

    table.insert(KillerHub.TargetThemeElements, function()
        MFrame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        SelLabel.TextColor3 = CurrentTheme.ACCENT
        makeList()
    end)

    makeList() updateText()
    task.spawn(pcall, callback, Config[flagName])
    self:RegisterElement(MFrame, Label, self.Frame.Name)
end

function TabMethods:CreateToggleColorPicker(flagToggle, flagColor, text, defaultColor, callbackToggle, callbackColor)
    if Config[flagToggle] == nil then Config[flagToggle] = false end
    if Config[flagColor] == nil then Config[flagColor] = {defaultColor.R, defaultColor.G, defaultColor.B} end
    Flags[flagToggle] = { CurrentValue = Config[flagToggle] }
    Flags[flagColor] = { CurrentValue = Color3.new(unpack(Config[flagColor])) }

    local MasterFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.1, ClipsDescendants = true}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, MasterFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, MasterFrame)

    local MainTrigger = create("TextButton", {Size = UDim2.new(1, -80, 0, 34), BackgroundTransparency = 1, Text = ""}, MasterFrame)
    local Label = create("TextLabel", {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Config[flagToggle] and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12, TextStrokeTransparency = 1}, MainTrigger)

    local Track = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = Config[flagToggle] and CurrentTheme.ACCENT or Color3.fromRGB(45, 45, 55)}, MainTrigger)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Track)
    local Knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = Config[flagToggle] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    local ColorBtn = create("TextButton", {Size = UDim2.new(0, 26, 0, 18), Position = UDim2.new(1, -38, 0, 8), BackgroundColor3 = Flags[flagColor].CurrentValue, Text = ""}, MasterFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, ColorBtn)

    local SlidersContainer = create("Frame", {Size = UDim2.new(1, -24, 0, 80), Position = UDim2.new(0, 12, 0, 40), BackgroundTransparency = 1}, MasterFrame)
    create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, SlidersContainer)

    local function stateUpdate()
        local active = Flags[flagToggle].CurrentValue
        Track.BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(45, 45, 55)
        Knob.Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        Label.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
    end

    connect(MainTrigger.MouseButton1Click, function()
        Flags[flagToggle].CurrentValue = not Flags[flagToggle].CurrentValue
        Config[flagToggle] = Flags[flagToggle].CurrentValue saveConfig() playUISound()
        stateUpdate() pcall(callbackToggle, Flags[flagToggle].CurrentValue)
    end)

    local function createMiniSlider(labelTxt, colorValueIndex, sliderColor)
        local Row = create("Frame", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1}, SlidersContainer)
        create("TextLabel", {Size = UDim2.new(0, 15, 1, 0), BackgroundTransparency = 1, Text = labelTxt, TextColor3 = sliderColor, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 1}, Row)
        local TrackS = create("Frame", {Size = UDim2.new(1, -25, 0, 4), Position = UDim2.new(0, 20, 0.5, -2), BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, Row)
        local FillS = create("Frame", {Size = UDim2.new(Config[flagColor][colorValueIndex], 0, 1, 0), BackgroundColor3 = sliderColor}, TrackS)
        local KnobS = create("TextButton", {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(Config[flagColor][colorValueIndex], -5, 0.5, -5), BackgroundColor3 = CurrentTheme.TEXT_WHITE, Text = ""}, TrackS)
        create("UICorner", {CornerRadius = UDim.new(1, 0)}, KnobS)

        local isSliding = false
        local function updateColor()
            local col = Color3.new(Config[flagColor][1], Config[flagColor][2], Config[flagColor][3])
            Flags[flagColor].CurrentValue = col ColorBtn.BackgroundColor3 = col saveConfig() pcall(callbackColor, col)
        end
        local function snap(input)
            local pct = math.clamp((input.Position.X - TrackS.AbsolutePosition.X) / TrackS.AbsoluteSize.X, 0, 1)
            FillS.Size = UDim2.new(pct, 0, 1, 0) KnobS.Position = UDim2.new(pct, -5, 0.5, -5)
            Config[flagColor][colorValueIndex] = pct updateColor()
        end
        
        connect(KnobS.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isSliding = true snap(input)
                local dragConn = UserInputService.InputChanged:Connect(function(changedInput)
                    if isSliding and (changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput.UserInputType == Enum.UserInputType.Touch) then snap(changedInput) end
                end)
                local endConn = UserInputService.InputEnded:Connect(function(endedInput)
                    if endedInput.UserInputType == Enum.UserInputType.MouseButton1 or endedInput.UserInputType == Enum.UserInputType.Touch then
                        isSliding = false if dragConn then dragConn:Disconnect() end if endConn then endConn:Disconnect() end
                    end
                end)
            end
        end)
    end

    createMiniSlider("R", 1, Color3.fromRGB(235, 40, 40))
    createMiniSlider("G", 2, Color3.fromRGB(40, 235, 40))
    createMiniSlider("B", 3, Color3.fromRGB(40, 40, 235))

    local open = false
    connect(ColorBtn.MouseButton1Click, function() 
        open = not open playUISound() 
        TweenService:Create(MasterFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, open and 125 or 34)}):Play()
    end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        MasterFrame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        stateUpdate()
    end)

    task.spawn(function()
        stateUpdate()
        if Flags[flagToggle].CurrentValue then pcall(callbackToggle, true) end
        pcall(callbackColor, Flags[flagColor].CurrentValue)
    end)

    self:RegisterElement(MasterFrame, Label, self.Frame.Name)
end

function TabMethods:CreateColorPicker(flagColor, text, defaultColor, callback)
    if Config[flagColor] == nil then Config[flagColor] = {defaultColor.R, defaultColor.G, defaultColor.B} end
    Flags[flagColor] = { CurrentValue = Color3.new(unpack(Config[flagColor])) }

    local MasterFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.1, ClipsDescendants = true}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, MasterFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, MasterFrame)

    local Trigger = create("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = ""}, MasterFrame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 1}, Trigger)

    local ColorBtn = create("TextButton", {Size = UDim2.new(0, 30, 0, 18), Position = UDim2.new(1, -42, 0.5, -9), BackgroundColor3 = Flags[flagColor].CurrentValue, Text = ""}, Trigger)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, ColorBtn)

    local SlidersContainer = create("Frame", {Size = UDim2.new(1, -24, 0, 80), Position = UDim2.new(0, 12, 0, 40), BackgroundTransparency = 1}, MasterFrame)
    create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, SlidersContainer)

    local function createMiniSlider(labelTxt, colorValueIndex, sliderColor)
        local Row = create("Frame", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1}, SlidersContainer)
        create("TextLabel", {Size = UDim2.new(0, 15, 1, 0), BackgroundTransparency = 1, Text = labelTxt, TextColor3 = sliderColor, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 1}, Row)
        
        local TrackS = create("Frame", {Size = UDim2.new(1, -25, 0, 4), Position = UDim2.new(0, 20, 0.5, -2), BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, Row)
        local FillS = create("Frame", {Size = UDim2.new(Config[flagColor][colorValueIndex], 0, 1, 0), BackgroundColor3 = sliderColor}, TrackS)
        local KnobS = create("TextButton", {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(Config[flagColor][colorValueIndex], -5, 0.5, -5), BackgroundColor3 = CurrentTheme.TEXT_WHITE, Text = ""}, TrackS)
        create("UICorner", {CornerRadius = UDim.new(1, 0)}, KnobS)

        local isSliding = false
        local function updateColor()
            local col = Color3.new(Config[flagColor][1], Config[flagColor][2], Config[flagColor][3])
            Flags[flagColor].CurrentValue = col ColorBtn.BackgroundColor3 = col saveConfig() pcall(callback, col)
        end
        
        local function snap(input)
            local pct = math.clamp((input.Position.X - TrackS.AbsolutePosition.X) / TrackS.AbsoluteSize.X, 0, 1)
            FillS.Size = UDim2.new(pct, 0, 1, 0) KnobS.Position = UDim2.new(pct, -5, 0.5, -5)
            Config[flagColor][colorValueIndex] = pct updateColor()
        end
        
        connect(KnobS.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isSliding = true snap(input)
                local dragConn = UserInputService.InputChanged:Connect(function(changedInput)
                    if isSliding and (changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput.UserInputType == Enum.UserInputType.Touch) then snap(changedInput) end
                end)
                local endConn = UserInputService.InputEnded:Connect(function(endedInput)
                    if endedInput.UserInputType == Enum.UserInputType.MouseButton1 or endedInput.UserInputType == Enum.UserInputType.Touch then
                        isSliding = false if dragConn then dragConn:Disconnect() end if endConn then endConn:Disconnect() end
                    end
                end)
            end
        end)
    end

    createMiniSlider("R", 1, Color3.fromRGB(235, 40, 40))
    createMiniSlider("G", 2, Color3.fromRGB(40, 235, 40))
    createMiniSlider("B", 3, Color3.fromRGB(40, 40, 235))

    local open = false
    connect(Trigger.MouseButton1Click, function() 
        open = not open playUISound() 
        TweenService:Create(MasterFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, open and 125 or 34)}):Play()
    end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        MasterFrame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        ColorBtn.BackgroundColor3 = Flags[flagColor].CurrentValue
    end)

    task.spawn(pcall, callback, Flags[flagColor].CurrentValue)
    self:RegisterElement(MasterFrame, Label, self.Frame.Name)
end

function TabMethods:CreateClipboardButton(text, textToCopy)
    local Frame = create("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.1}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, Frame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Frame)
    
    local Button = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""}, Frame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 1}, Button)
    local StatusLabel = create("TextLabel", {Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(1, -12, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = "Copiar", TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, TextStrokeTransparency = 1}, Button)
    
    local copying = false
    connect(Button.MouseButton1Click, function()
        if copying then return end copying = true playUISound()
        local setClip = setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if setClip then pcall(setClip, textToCopy) end
        StatusLabel.Text = "¡Copiado! ✓" StatusLabel.TextColor3 = Color3.fromRGB(40, 235, 40)
        task.delay(1.5, function() StatusLabel.Text = "Copiar" StatusLabel.TextColor3 = CurrentTheme.ACCENT copying = false end)
    end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        Frame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        if not copying then StatusLabel.TextColor3 = CurrentTheme.ACCENT end
    end)
    
    self:RegisterElement(Frame, Label, self.Frame.Name)
end

function TabMethods:CreateInput(flagName, text, placeholder, callback)
    if Config[flagName] == nil then Config[flagName] = "" end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    
    local InpFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.1}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, InpFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, InpFrame)
    
    local Label = create("TextLabel", {Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 1}, InpFrame)
    local Box = create("TextBox", {Size = UDim2.new(0, 120, 0, 24), Position = UDim2.new(1, -12, 0.5, -12), AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = Color3.fromRGB(24, 24, 28), Text = Flags[flagName].CurrentValue, PlaceholderText = placeholder, PlaceholderColor3 = Color3.fromRGB(90, 95, 105), TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, ClearTextOnFocus = false}, InpFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, Box)
    create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Box)
    
    connect(Box.FocusLost, function() Flags[flagName].CurrentValue = Box.Text Config[flagName] = Box.Text saveConfig() pcall(callback, Box.Text) end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        InpFrame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        Box.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    end)

    task.spawn(pcall, callback, Flags[flagName].CurrentValue)
    self:RegisterElement(InpFrame, Label, self.Frame.Name)
end

function TabMethods:CreateButton(text, callback)
    local Button = create("TextButton", {Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamBold, TextSize = 12}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, Button)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, Button)
    
    connect(Button.MouseButton1Click, function() playUISound() pcall(callback) end)
    table.insert(KillerHub.TargetThemeElements, function()
        Button.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
    end)
    self:RegisterElement(Button, Button, self.Frame.Name)
end

function TabMethods:CreateKeybind(flagName, text, defaultKey, callback)
    if Config[flagName] == nil then Config[flagName] = defaultKey.Name end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    
    local KFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = CurrentTheme.BG_SECONDARY, BackgroundTransparency = 0.1}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, KFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, KFrame)
    
    local Lbl = create("TextLabel", {Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 1}, KFrame)
    local BBtn = create("TextButton", {Size = UDim2.new(0, 85, 0, 24), Position = UDim2.new(1, -12, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(26, 26, 32), Text = Config[flagName], TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11}, KFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 5)}, BBtn)
    create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, BBtn)
    
    local listening = false
    connect(BBtn.MouseButton1Click, function() listening = true BBtn.Text = "..." playUISound() end)
    connect(UserInputService.InputBegan, function(input, gp)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false Config[flagName] = input.KeyCode.Name Flags[flagName].CurrentValue = input.KeyCode.Name
            saveConfig() BBtn.Text = input.KeyCode.Name pcall(callback, input.KeyCode)
        end
    end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        KFrame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        BBtn.TextColor3 = CurrentTheme.ACCENT
    end)

    task.spawn(function()
        local key = Enum.KeyCode[Flags[flagName].CurrentValue]
        if key then pcall(callback, key) end
    end)

    self:RegisterElement(KFrame, Lbl, self.Frame.Name)
end

-- ============================================================================
-- 🔓 ENGINES DE CREACIÓN DE PESTAÑAS (TABS)
-- ============================================================================
function KillerHub:CreateTab(name, iconId)
    local frame = create("ScrollingFrame", {
        Name = name .. "Frame", Size = UDim2.new(1, -24, 1, -24), Position = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = CurrentTheme.BG_MAIN, BackgroundTransparency = 0.2, Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = CurrentTheme.ACCENT
    }, ContentContainer)
    create("UICorner", {CornerRadius = UDim.new(0, 8)}, frame)
    local stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, frame)
    
    local layout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, frame)
    create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, frame)
    
    local sizeChangedConn = layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20) 
    end)
    table.insert(Connections, sizeChangedConn)

    local btn = create("TextButton", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = ""}, (name == "Settings" and SettingsContainer or SidebarTabsContainer))
    -- MODIFICACIÓN: TextSize ligeramente incrementado a 14 para mayor visibilidad
    local btnLabel = create("TextLabel", {Size = UDim2.new(1, iconId and -24 or 0, 1, 0), Position = UDim2.new(0, iconId and 24 or 0, 0, 0), BackgroundTransparency = 1, Text = name, TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextStrokeTransparency = 1}, btn)

    local iconImg
    if iconId then
        iconImg = create("ImageLabel", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 4, 0.5, -7), BackgroundTransparency = 1, Image = iconId, ImageColor3 = CurrentTheme.TEXT_MUTED}, btn)
    end
    
    local isFirstTab = true for _, _ in pairs(KillerHub.Frames) do isFirstTab = false break end
    KillerHub.Frames[name] = frame KillerHub.Buttons[name] = btn
    
    local function selectTab()
        for tName, tFrame in pairs(KillerHub.Frames) do
            local tBtn = KillerHub.Buttons[tName] local tLabel = tBtn:FindFirstChildWhichIsA("TextLabel")
            local tIcon = tBtn:FindFirstChildWhichIsA("ImageLabel")
            if tName == name then 
                tFrame.Visible = true 
                if tLabel then tLabel.TextColor3 = CurrentTheme.TEXT_WHITE end 
                if tIcon then tIcon.ImageColor3 = CurrentTheme.TEXT_WHITE end
            else 
                tFrame.Visible = false 
                if tLabel then tLabel.TextColor3 = CurrentTheme.TEXT_MUTED end 
                if tIcon then tIcon.ImageColor3 = CurrentTheme.TEXT_MUTED end
            end
        end
        KillerHub.CurrentTab = name
    end
    connect(btn.MouseButton1Click, function() if KillerHub.CurrentTab ~= name then selectTab() playUISound() end end)
    if isFirstTab or name == "Settings" then task.spawn(selectTab) end
    
    table.insert(KillerHub.TargetThemeElements, function()
        frame.BackgroundColor3 = CurrentTheme.BG_MAIN
        stroke.Color = CurrentTheme.BORDER
        if KillerHub.CurrentTab == name then
            btnLabel.TextColor3 = CurrentTheme.TEXT_WHITE
            if iconImg then iconImg.ImageColor3 = CurrentTheme.TEXT_WHITE end
        else
            btnLabel.TextColor3 = CurrentTheme.TEXT_MUTED
            if iconImg then iconImg.ImageColor3 = CurrentTheme.TEXT_MUTED end
        end
    end)

    local tabObj = setmetatable({ Frame = frame }, TabMethods)
    KillerHub.Tabs[name] = tabObj return tabObj
end

local searchThread
connect(SearchInput:GetPropertyChangedSignal("Text"), function()
    if searchThread then task.cancel(searchThread) end
    searchThread = task.delay(0.04, function()
        local q = string.lower(SearchInput.Text)
        for _, el in pairs(KillerHub.AllElements) do
            if el.Instance and el.Label then el.Instance.Visible = (q == "") and true or (string.find(string.lower(el.Label.Text or ""), q) and true or false) end
        end
    end)
end)

-- ============================================================================
-- 💾 CARGA PREVIA DEL CONFIG DE FORMA SEGURA (IGNORA BYPASS PREMIUM)
-- ============================================================================
pcall(function()
    if isfile and readfile and isfile(CONFIG_FILE) then
        local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(data) == "table" then
            if data.SavedOwner and data.SavedOwner ~= LocalPlayer.UserId then
                warn("⚠️ [KillerHub Security] Cuenta cruzada detectada. Reajustando credenciales.")
                Config.SavedOwner = LocalPlayer.UserId
                saveConfig()
            else
                for k, v in pairs(data) do 
                    Config[k] = v 
                end 
            end
        end
    end
end)
Config.SavedOwner = LocalPlayer.UserId

-- ============================================================================
-- 🔓 CONFIGURACIÓN BASE OBLIGATORIA (SETTINGS)
-- ============================================================================
local SettingsTab = KillerHub:CreateTab("Settings", "rbxassetid://10747372517")
SettingsTab:CreateSection("Personalización")
SettingsTab:CreateDropdown("SelectedTheme", "Tema Visual:", {"Black Glass", "Void Premium", "Midnight Emerald", "Classic Dark", "Blood"}, function(selected) KillerHub:SetTheme(selected) end)

local TopFonts = {
    "Gotham", "GothamMedium", "GothamBold", "GothamBlack",
    "Roboto", "RobotoMono", "SourceSans", "SourceSansBold", "Ubuntu"
}
SettingsTab:CreateDropdown("SelectedFont", "Fuente de Texto:", TopFonts, function(selected)
    KillerHub:SetFont(selected)
end)

-- MODIFICACIÓN: Rango mínimo reducido de 0.6 a 0.10 para máxima transparencia
SettingsTab:CreateSlider("UiOpacity", "Opacidad del Menú", 0.10, 1, function(v) updateUiOpacity() end)

SettingsTab:CreateSection("Controles del Menú")
SettingsTab:CreateKeybind("ToggleKey", "Cerrar / Abrir Menu (PC)", Enum.KeyCode.RightControl)
SettingsTab:CreateSlider("ToggleBtnSize", "Tamaño de Botón Flotante", 30, 80, function(v) updateButtonSize() end)
SettingsTab:CreateSlider("Volume", "Volumen Interfaz", 0, 1, function(v) Config.Volume = v end)
SettingsTab:CreateSlider("GuiWidth", "Ajustar Ancho Ventana", 0, 1, function(v) updateGuiSize() end)
SettingsTab:CreateSlider("GuiHeight", "Ajustar Alto Ventana", 0, 1, function(v) updateGuiSize() end)

SettingsTab:CreateSection("Seguridad y Limpieza")
SettingsTab:CreateParagraph("⚠️ ADVERTENCIA DE APAGADO", "Si decides apagar el script (Unload), la interfaz se cerrará y se eliminará por completo de la memoria.")
SettingsTab:CreateButton("Apagar Script por Completo (Unload)", function() KillerHub:Unload() end)

task.defer(function()
    KillerHub:SetTheme(Config.SelectedTheme or "Black Glass")
end)

getgenv().KillerHub = KillerHub
return KillerHub
