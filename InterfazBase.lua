-- ============================================================================
-- 👻 KILLER HUB UNIVERSAL FRAMEWORK | ULTRA-OPTIMIZED MOBILE API (V2.1)
-- 🧑‍💻 Desarrollado por: Paolo
-- 📱 Fix: Dropdowns completamente funcionales y visibles
-- ============================================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Contenedor seguro multi-ejecutor móvil
local TargetParent = (gethui and gethui()) or (pcall(function() return CoreGui.Name end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

if TargetParent:FindFirstChild("KillerHub_Universal") then
    TargetParent.KillerHub_Universal:Destroy()
end

-- ============================================================================
-- 🎨 SINOPSIS DE TEMAS VISUALES
-- ============================================================================
local Themes = {
    ["Crimson Dark"] = {
        BG_MAIN = Color3.fromRGB(11, 11, 13),
        BG_SIDEBAR = Color3.fromRGB(14, 14, 16),
        BG_SECONDARY = Color3.fromRGB(18, 18, 22),
        ACCENT = Color3.fromRGB(235, 35, 35),
        TEXT_WHITE = Color3.fromRGB(245, 245, 245),
        TEXT_MUTED = Color3.fromRGB(140, 130, 130),
        BORDER = Color3.fromRGB(38, 28, 28)
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
    ["Cyberpunk Violet"] = {
        BG_MAIN = Color3.fromRGB(12, 10, 15),
        BG_SIDEBAR = Color3.fromRGB(16, 13, 20),
        BG_SECONDARY = Color3.fromRGB(22, 17, 28),
        ACCENT = Color3.fromRGB(180, 40, 255),
        TEXT_WHITE = Color3.fromRGB(250, 250, 250),
        TEXT_MUTED = Color3.fromRGB(140, 130, 150),
        BORDER = Color3.fromRGB(38, 28, 42)
    },
    ["Classic Dark"] = {
        BG_MAIN = Color3.fromRGB(15, 15, 15),
        BG_SIDEBAR = Color3.fromRGB(20, 20, 20),
        BG_SECONDARY = Color3.fromRGB(25, 25, 25),
        ACCENT = Color3.fromRGB(245, 245, 245),
        TEXT_WHITE = Color3.fromRGB(245, 245, 245),
        TEXT_MUTED = Color3.fromRGB(130, 130, 130),
        BORDER = Color3.fromRGB(40, 40, 40)
    }
}

local CurrentTheme = Themes["Crimson Dark"]

-- ============================================================================
-- 💾 SISTEMA DE CONFIGURACIÓN
-- ============================================================================
local CONFIG_FILE = "KillerHub_Universal_Config.json"
local DefaultConfig = {
    Volume = 0.5, ToggleKey = "RightControl", SelectedTheme = "Crimson Dark",
    GuiWidth = 0.466, GuiHeight = 0.4
}
local Config = {} local Flags = {}

local function copyTable(target, source)
    for k, v in pairs(source) do
        if type(v) == "table" then target[k] = {} copyTable(target[k], v) else target[k] = v end
    end
end
copyTable(Config, DefaultConfig)

local function saveConfig()
    if writefile then pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(Config)) end) end
end

pcall(function()
    if isfile and readfile and isfile(CONFIG_FILE) then
        local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(data) == "table" then for k, v in pairs(data) do Config[k] = v end end
    end
end)

if Themes[Config.SelectedTheme] then CurrentTheme = Themes[Config.SelectedTheme] end

local function create(instanceType, properties, parent)
    local obj = Instance.new(instanceType)
    for prop, val in pairs(properties) do obj[prop] = val end
    if parent then obj.Parent = parent end
    return obj
end

local function playUISound()
    if not Config.Volume or Config.Volume <= 0 then return end
    local sound = create("Sound", {SoundId = "rbxassetid://101735926591481", Volume = Config.Volume}, SoundService)
    sound:Play() Debris:AddItem(sound, 1.5)
end

-- ============================================================================
-- 🖥 INTERFAZ BASE TOTALMENTE ADAPTABLE
-- ============================================================================
local ScreenGui = create("ScreenGui", {Name = "KillerHub_Universal", IgnoreGuiInset = true, ResetOnSpawn = false}, TargetParent)
local MainFrame = create("Frame", {Name = "MainFrame", BackgroundColor3 = CurrentTheme.BG_MAIN, BorderSizePixel = 0, Active = true, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0)}, ScreenGui)
local MainStroke = create("UIStroke", {Thickness = 1.2, Color = CurrentTheme.BORDER}, MainFrame)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, MainFrame)

local BordeGradient = create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 55)),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
    }), Rotation = 45
}, MainStroke)

local function updateGuiSize()
    MainFrame.Size = UDim2.new(0, math.floor(430 + ((Config.GuiWidth or 0.466) * 280)), 0, math.floor(280 + ((Config.GuiHeight or 0.4) * 230)))
end
updateGuiSize()

-- Topbar
local Topbar = create("Frame", {Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Color3.fromRGB(8, 8, 10), BorderSizePixel = 0, Active = true}, MainFrame)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, Topbar)
create("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = Color3.fromRGB(8, 8, 10), BorderSizePixel = 0}, Topbar)

local Title = create("TextLabel", {
    Size = UDim2.new(0, 250, 1, 0), Position = UDim2.new(0, 18, 0, 0), BackgroundTransparency = 1,
    Text = "Killer Hub | By Paolo 👻", TextColor3 = CurrentTheme.ACCENT,
    TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamBold, TextSize = 14
}, Topbar)
local DecorLine = create("Frame", {Size = UDim2.new(0, 50, 0, 2), Position = UDim2.new(0, 18, 1, -2), BackgroundColor3 = CurrentTheme.ACCENT, BorderSizePixel = 0}, Topbar)

-- Contador Híbrido de Rendimiento
local PerformanceLabel = create("TextLabel", {
    Size = UDim2.new(0, 160, 1, 0), Position = UDim2.new(1, -15, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1,
    Text = "FPS: -- | PING: --", TextColor3 = CurrentTheme.TEXT_MUTED,
    TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.GothamMedium, TextSize = 11
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

-- Arrastre de Ventana
local mainDragStart, mainStartPos, mainDraggingInput
Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDraggingInput = input mainDragStart = input.Position mainStartPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == mainDraggingInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mainDragStart
        MainFrame.Position = UDim2.new(mainStartPos.X.Scale, mainStartPos.X.Offset + delta.X, mainStartPos.Y.Scale, mainStartPos.Y.Offset + delta.Y)
    end
end)
Topbar.InputEnded:Connect(function(input) if input == mainDraggingInput then mainDraggingInput = nil end end)

-- Panel Lateral
local Sidebar = create("Frame", {Name = "Sidebar", Size = UDim2.new(0, 125, 1, -45), Position = UDim2.new(0, 0, 0, 45), BackgroundColor3 = CurrentTheme.BG_SIDEBAR, BorderSizePixel = 0, Active = true}, MainFrame)
local SidebarLine = create("Frame", {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = Color3.fromRGB(24, 24, 28), BorderSizePixel = 0}, Sidebar)

local SearchBoxContainer = create("Frame", {Size = UDim2.new(1, -12, 0, 26), Position = UDim2.new(0, 6, 0, 8), BackgroundColor3 = CurrentTheme.BG_SECONDARY}, Sidebar)
create("UICorner", {CornerRadius = UDim.new(0, 5)}, SearchBoxContainer)
local SearchStroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(30, 30, 36)}, SearchBoxContainer)

local SearchInput = create("TextBox", {
    Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1,
    PlaceholderText = "Buscar...", PlaceholderColor3 = CurrentTheme.TEXT_MUTED, Text = "",
    TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, ClearTextOnFocus = false
}, SearchBoxContainer)

local SidebarTabsContainer = create("Frame", {Size = UDim2.new(1, 0, 1, -85), Position = UDim2.new(0, 0, 0, 38), BackgroundTransparency = 1}, Sidebar)
create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, SidebarTabsContainer)
create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, SidebarTabsContainer)

local SettingsContainer = create("Frame", {Size = UDim2.new(1, -12, 0, 36), Position = UDim2.new(0, 6, 1, -42), BackgroundTransparency = 1}, Sidebar)
local ContentContainer = create("Frame", {Name = "ContentContainer", Size = UDim2.new(1, -125, 1, -45), Position = UDim2.new(0, 125, 0, 45), BackgroundTransparency = 1, Active = true}, MainFrame)

-- Botón Flotante Alternador de UI
local OpenCloseBtn = create("TextButton", {Name = "KillerHubToggle", Size = UDim2.new(0, 46, 0, 46), Position = UDim2.new(0, 15, 0, 100), BackgroundColor3 = CurrentTheme.BG_MAIN, Text = "", Active = true}, ScreenGui)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, OpenCloseBtn)
local FloatingStroke = create("UIStroke", {Thickness = 1.5, Color = CurrentTheme.BORDER}, OpenCloseBtn)
local BtnIcon = create("ImageLabel", {Name = "Icon", Size = UDim2.new(1, 0, 1, 0), ScaleType = Enum.ScaleType.Crop, BackgroundTransparency = 1, Image = "rbxassetid://79918418184450", ImageColor3 = CurrentTheme.ACCENT}, OpenCloseBtn)
create("UICorner", {CornerRadius = UDim.new(0, 10)}, BtnIcon)

local menuVisible = true
local function setMenuVisibility(visible)
    menuVisible = visible MainFrame.Visible = visible
    BtnIcon.ImageColor3 = visible and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE
end
OpenCloseBtn.MouseButton1Click:Connect(function() playUISound() setMenuVisibility(not menuVisible) end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == (Config.ToggleKey or "RightControl") then
        playUISound() setMenuVisibility(not menuVisible)
    end
end)

-- Arrastre del Botón Flotante
local dragStart, startPos, draggingInput
OpenCloseBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingInput = input dragStart = input.Position startPos = OpenCloseBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingInput and input == draggingInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        OpenCloseBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
OpenCloseBtn.InputEnded:Connect(function(input) if input == draggingInput then draggingInput = nil end end)

-- ============================================================================
-- 📦 API CORE Y MOTOR DE REDISEÑO REACTIVO CENTRAL
-- ============================================================================
local KillerHub = {
    Tabs = {}, Frames = {}, Buttons = {}, Config = Config, Flags = Flags,
    CurrentTab = nil, AllElements = {}, TargetThemeElements = {}
}

function KillerHub:Unload()
    if ScreenGui then ScreenGui:Destroy() end
    warn("❌ KillerHub desunificado por completo.")
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
    DecorLine.BackgroundColor3 = CurrentTheme.ACCENT
    PerformanceLabel.TextColor3 = CurrentTheme.TEXT_MUTED
    SearchBoxContainer.BackgroundColor3 = CurrentTheme.BG_SECONDARY
    SearchInput.TextColor3 = CurrentTheme.TEXT_WHITE
    SearchInput.PlaceholderColor3 = CurrentTheme.TEXT_MUTED
    OpenCloseBtn.BackgroundColor3 = CurrentTheme.BG_MAIN
    FloatingStroke.Color = CurrentTheme.BORDER
    BtnIcon.ImageColor3 = menuVisible and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE
    
    BordeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 55)),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
    })

    for _, refreshCallback in ipairs(KillerHub.TargetThemeElements) do
        pcall(refreshCallback)
    end
end

local TabMethods = {}
TabMethods.__index = TabMethods

function TabMethods:RegisterElement(inst, textLabel, tabName)
    table.insert(KillerHub.AllElements, {Instance = inst, Label = textLabel, Tab = tabName})
end

function TabMethods:CreateParagraph(title, text)
    local Frame = create("Frame", {Size = UDim2.new(1, 0, 0, 55), BackgroundColor3 = CurrentTheme.BG_SECONDARY}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, Frame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(28, 28, 34)}, Frame)
    
    local Tl = create("TextLabel", {Size = UDim2.new(1, -24, 0, 18), Position = UDim2.new(0, 12, 0, 6), BackgroundTransparency = 1, Text = title, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Frame)
    local Tx = create("TextLabel", {Size = UDim2.new(1, -24, 0, 26), Position = UDim2.new(0, 12, 0, 22), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamMedium, TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, Frame)
    
    table.insert(KillerHub.TargetThemeElements, function()
        Frame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        Tl.TextColor3 = CurrentTheme.ACCENT
        Tx.TextColor3 = CurrentTheme.TEXT_MUTED
    end)
    return {SetTitle = function(_, t) Tl.Text = t end, SetText = function(_, t) Tx.Text = t end}
end

function TabMethods:CreateSection(text)
    local Container = create("Frame", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1}, self.Frame)
    local Label = create("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = text:upper(), TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left}, Container)
    table.insert(KillerHub.TargetThemeElements, function() Label.TextColor3 = CurrentTheme.ACCENT end)
    return Container
end

function TabMethods:CreateToggle(flagName, text, callback)
    if Config[flagName] == nil then Config[flagName] = false end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    
    local ToggleButton = create("TextButton", {Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = CurrentTheme.BG_SECONDARY, Text = "", AutoButtonColor = false}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, ToggleButton)
    local Stroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(32, 32, 38)}, ToggleButton)
    
    local ToggleLabel = create("TextLabel", {Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Config[flagName] and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12}, ToggleButton)
    local Track = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = Config[flagName] and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 46)}, ToggleButton)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Track)
    local Knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = Config[flagName] and UDim2.new(1, -15, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    local function stateUpdate()
        local active = Flags[flagName].CurrentValue
        ToggleLabel.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
        Track.BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 46)
        Knob.Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        local nextState = not Flags[flagName].CurrentValue
        Flags[flagName].CurrentValue = nextState Config[flagName] = nextState saveConfig() playUISound() stateUpdate() pcall(callback, nextState)
    end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        ToggleButton.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        stateUpdate()
    end)

    task.spawn(callback, Flags[flagName].CurrentValue)
    self:RegisterElement(ToggleButton, ToggleLabel, self.Frame.Name)
    return {Set = function(_, bool) Flags[flagName].CurrentValue = bool Config[flagName] = bool saveConfig() stateUpdate() pcall(callback, bool) end}
end

function TabMethods:CreateSlider(flagName, text, min, max, callback)
    if Config[flagName] == nil then Config[flagName] = min end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    
    local SliderFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, Active = true}, self.Frame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -60, 0, 18), Position = UDim2.new(0, 2, 0, 2), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, SliderFrame)
    local ValueBox = create("TextBox", {Size = UDim2.new(0, 50, 0, 18), Position = UDim2.new(1, -2, 0, 2), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, ClearTextOnFocus = false}, SliderFrame)
    local Track = create("Frame", {Size = UDim2.new(1, -4, 0, 6), Position = UDim2.new(0, 2, 0, 28), BackgroundColor3 = Color3.fromRGB(36, 36, 42)}, SliderFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 3)}, Track)
    local Fill = create("Frame", {BackgroundColor3 = CurrentTheme.ACCENT}, Track)
    create("UICorner", {CornerRadius = UDim.new(0, 3)}, Fill)
    local Knob = create("TextButton", {Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = CurrentTheme.TEXT_WHITE, Text = "", AutoButtonColor = false}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    local function runSliderValue(v)
        v = math.clamp(v, min, max) Flags[flagName].CurrentValue = v Config[flagName] = v saveConfig()
        local pct = (max == min) and 0 or (v - min) / (max - min)
        Fill.Size = UDim2.new(pct, 0, 1, 0) Knob.Position = UDim2.new(pct, -6, 0.5, -6)
        if max <= 1 then ValueBox.Text = string.format("%.2f", v) else ValueBox.Text = tostring(math.floor(v)) end
        pcall(callback, v)
    end
    
    local sliding = false
    local function snap(input)
        local pct = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        runSliderValue(min + (pct * (max - min)))
    end
    
    Knob.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true snap(input) end end)
    UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then snap(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        ValueBox.TextColor3 = CurrentTheme.ACCENT
        Fill.BackgroundColor3 = CurrentTheme.ACCENT
        runSliderValue(Flags[flagName].CurrentValue)
    end)

    runSliderValue(Flags[flagName].CurrentValue)
    self:RegisterElement(SliderFrame, Label, self.Frame.Name)
    return {Set = function(_, value) runSliderValue(value) end}
end

-- 📌 DROPDOWN FIJADO (Ya no elimina el UIListLayout interno)
function TabMethods:CreateDropdown(flagName, text, options, callback)
    if Config[flagName] == nil then Config[flagName] = options[1] or "" end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    
    local DDFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = CurrentTheme.BG_SECONDARY, ClipsDescendants = true}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, DDFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(32, 32, 38)}, DDFrame)
    
    local Trigger = create("TextButton", {Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Text = ""}, DDFrame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -140, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Trigger)
    local SelLabel = create("TextLabel", {Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(1, -38, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = Flags[flagName].CurrentValue, TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right}, Trigger)
    local Arrow = create("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -22, 0.5, -10), BackgroundTransparency = 1, Text = "▼", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 11}, Trigger)
    
    local OptsScroll = create("ScrollingFrame", {Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 42), BackgroundTransparency = 1, ScrollBarThickness = 2}, DDFrame)
    local layout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, OptsScroll)

    local open = false
    Trigger.MouseButton1Click:Connect(function()
        open = not open playUISound()
        local targetH = open and math.min(layout.AbsoluteContentSize.Y, 120) or 0
        DDFrame.Size = UDim2.new(1, 0, 0, 42 + targetH + (open and 6 or 0))
        OptsScroll.Size = UDim2.new(1, -16, 0, targetH) OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
        Arrow.Rotation = open and 180 or 0
    end)
    
    local function makeOptions()
        for _, child in ipairs(OptsScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for i, name in ipairs(options) do
            local OptBtn = create("TextButton", {Size = UDim2.new(1, -4, 0, 28), BackgroundColor3 = Color3.fromRGB(24, 24, 30), Text = name, TextColor3 = (name == Flags[flagName].CurrentValue) and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, LayoutOrder = i}, OptsScroll)
            create("UICorner", {CornerRadius = UDim.new(0, 4)}, OptBtn)
            OptBtn.MouseButton1Click:Connect(function()
                Flags[flagName].CurrentValue = name Config[flagName] = name saveConfig() SelLabel.Text = name playUISound() open = false
                DDFrame.Size = UDim2.new(1, 0, 0, 42) Arrow.Rotation = 0 pcall(callback, name) makeOptions()
            end)
        end
    end

    table.insert(KillerHub.TargetThemeElements, function()
        DDFrame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        SelLabel.TextColor3 = CurrentTheme.ACCENT
        Arrow.TextColor3 = CurrentTheme.TEXT_MUTED
        makeOptions()
    end)

    makeOptions()
    task.spawn(callback, Flags[flagName].CurrentValue)
    self:RegisterElement(DDFrame, Label, self.Frame.Name)
    return {Refresh = function(_, newOptions) options = newOptions makeOptions() end}
end

-- 📌 MULTI-DROPDOWN FIJADO
function TabMethods:CreateMultiDropdown(flagName, text, options, callback)
    if Config[flagName] == nil or type(Config[flagName]) ~= "table" then Config[flagName] = {} end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    
    local MFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = CurrentTheme.BG_SECONDARY, ClipsDescendants = true}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, MFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(32, 32, 38)}, MFrame)
    
    local Trigger = create("TextButton", {Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Text = ""}, MFrame)
    local Label = create("TextLabel", {Size = UDim2.new(1, -140, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, Trigger)
    local SelLabel = create("TextLabel", {Size = UDim2.new(0, 120, 1, 0), Position = UDim2.new(1, -38, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Text = "...", TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Right}, Trigger)
    local Arrow = create("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -22, 0.5, -10), BackgroundTransparency = 1, Text = "▼", TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 11}, Trigger)
    
    local OptsScroll = create("ScrollingFrame", {Size = UDim2.new(1, -16, 0, 0), Position = UDim2.new(0, 8, 0, 42), BackgroundTransparency = 1, ScrollBarThickness = 2}, MFrame)
    local layout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, OptsScroll)

    local function updateText()
        local selected = {}
        for _, opt in ipairs(options) do if Config[flagName][opt] then table.insert(selected, opt) end end
        SelLabel.Text = (#selected == 0) and "Ninguno" or table.concat(selected, ", ")
    end

    local open = false
    Trigger.MouseButton1Click:Connect(function()
        open = not open playUISound()
        local targetH = open and math.min(layout.AbsoluteContentSize.Y, 120) or 0
        MFrame.Size = UDim2.new(1, 0, 0, 42 + targetH + (open and 6 or 0))
        OptsScroll.Size = UDim2.new(1, -16, 0, targetH) OptsScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
        Arrow.Rotation = open and 180 or 0
    end)

    local function makeList()
        for _, child in ipairs(OptsScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for i, name in ipairs(options) do
            local isChosen = Config[flagName][name] or false
            local OptBtn = create("TextButton", {Size = UDim2.new(1, -4, 0, 28), BackgroundColor3 = isChosen and CurrentTheme.BG_MAIN or Color3.fromRGB(24, 24, 30), Text = name, TextColor3 = isChosen and CurrentTheme.ACCENT or CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, LayoutOrder = i}, OptsScroll)
            create("UICorner", {CornerRadius = UDim.new(0, 4)}, OptBtn)
            
            OptBtn.MouseButton1Click:Connect(function()
                Config[flagName][name] = not Config[flagName][name]
                saveConfig() playUISound() updateText() makeList() pcall(callback, Config[flagName])
            end)
        end
    end

    table.insert(KillerHub.TargetThemeElements, function()
        MFrame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        Label.TextColor3 = CurrentTheme.TEXT_WHITE
        SelLabel.TextColor3 = CurrentTheme.ACCENT
        makeList()
    end)

    makeList() updateText()
    task.spawn(callback, Flags[flagName].CurrentValue)
    self:RegisterElement(MFrame, Label, self.Frame.Name)
end

function TabMethods:CreateToggleColorPicker(flagToggle, flagColor, text, defaultColor, callbackToggle, callbackColor)
    if Config[flagToggle] == nil then Config[flagToggle] = false end
    if Config[flagColor] == nil then Config[flagColor] = {defaultColor.R, defaultColor.G, defaultColor.B} end
    Flags[flagToggle] = { CurrentValue = Config[flagToggle] }
    Flags[flagColor] = { CurrentValue = Color3.new(unpack(Config[flagColor])) }

    local MasterFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = CurrentTheme.BG_SECONDARY, ClipsDescendants = true}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, MasterFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(32, 32, 38)}, MasterFrame)

    local MainTrigger = create("TextButton", {Size = UDim2.new(1, -80, 0, 42), BackgroundTransparency = 1, Text = ""}, MasterFrame)
    local Label = create("TextLabel", {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Config[flagToggle] and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12}, MainTrigger)

    local Track = create("Frame", {Size = UDim2.new(0, 34, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = Config[flagToggle] and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 46)}, MainTrigger)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Track)
    local Knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = Config[flagToggle] and UDim2.new(1, -15, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = CurrentTheme.TEXT_WHITE}, Track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, Knob)

    local ColorBtn = create("TextButton", {Size = UDim2.new(0, 26, 0, 18), Position = UDim2.new(1, -38, 0, 12), BackgroundColor3 = Flags[flagColor].CurrentValue, Text = ""}, MasterFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, ColorBtn)

    local SlidersContainer = create("Frame", {Size = UDim2.new(1, -24, 0, 80), Position = UDim2.new(0, 12, 0, 44), BackgroundTransparency = 1}, MasterFrame)
    create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}, SlidersContainer)

    local function stateUpdate()
        local active = Flags[flagToggle].CurrentValue
        Track.BackgroundColor3 = active and CurrentTheme.ACCENT or Color3.fromRGB(40, 40, 46)
        Knob.Position = active and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        Label.TextColor3 = active and CurrentTheme.TEXT_WHITE or CurrentTheme.TEXT_MUTED
    end

    MainTrigger.MouseButton1Click:Connect(function()
        Flags[flagToggle].CurrentValue = not Flags[flagToggle].CurrentValue
        Config[flagToggle] = Flags[flagToggle].CurrentValue saveConfig() playUISound() stateUpdate() pcall(callbackToggle, Flags[flagToggle].CurrentValue)
    end)

    local function createMiniSlider(labelTxt, colorValueIndex, sliderColor)
        local Row = create("Frame", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1}, SlidersContainer)
        create("TextLabel", {Size = UDim2.new(0, 15, 1, 0), BackgroundTransparency = 1, Text = labelTxt, TextColor3 = sliderColor, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left}, Row)
        local TrackS = create("Frame", {Size = UDim2.new(1, -25, 0, 4), Position = UDim2.new(0, 20, 0.5, -2), BackgroundColor3 = Color3.fromRGB(30, 30, 35)}, Row)
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
        KnobS.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isSliding = true snap(input) end end)
        UserInputService.InputChanged:Connect(function(input) if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then snap(input) end end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isSliding = false end end)
    end

    createMiniSlider("R", 1, Color3.fromRGB(235, 40, 40))
    createMiniSlider("G", 2, Color3.fromRGB(40, 235, 40))
    createMiniSlider("B", 3, Color3.fromRGB(40, 40, 235))

    local open = false
    ColorBtn.MouseButton1Click:Connect(function() open = not open playUISound() MasterFrame.Size = UDim2.new(1, 0, 0, open and 130 or 42) end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        MasterFrame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
        stateUpdate()
    end)

    stateUpdate()
    task.spawn(callbackToggle, Flags[flagToggle].CurrentValue)
    task.spawn(callbackColor, Flags[flagColor].CurrentValue)
    self:RegisterElement(MasterFrame, Label, self.Frame.Name)
end

function TabMethods:CreateInput(flagName, text, placeholder, callback)
    if Config[flagName] == nil then Config[flagName] = "" end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    local InpFrame = create("Frame", {Name = flagName, Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = CurrentTheme.BG_SECONDARY}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, InpFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(32, 32, 38)}, InpFrame)
    
    local Label = create("TextLabel", {Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, InpFrame)
    local Box = create("TextBox", {Size = UDim2.new(0, 120, 0, 26), Position = UDim2.new(1, -12, 0.5, -13), AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = Color3.fromRGB(26, 26, 32), Text = Flags[flagName].CurrentValue, PlaceholderText = placeholder, PlaceholderColor3 = Color3.fromRGB(90, 90, 100), TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 11, ClearTextOnFocus = false}, InpFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, Box)
    
    Box.FocusLost:Connect(function() Flags[flagName].CurrentValue = Box.Text Config[flagName] = Box.Text saveConfig() pcall(callback, Box.Text) end)
    
    table.insert(KillerHub.TargetThemeElements, function()
        InpFrame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
    end)
    self:RegisterElement(InpFrame, Label, self.Frame.Name)
end

function TabMethods:CreateButton(text, callback)
    local Button = create("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.fromRGB(25, 25, 32), Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamBold, TextSize = 12}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, Button)
    local Stroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(38, 38, 45)}, Button)
    
    Button.MouseButton1Click:Connect(function() playUISound() pcall(callback) end)
    table.insert(KillerHub.TargetThemeElements, function()
        Button.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        Stroke.Color = CurrentTheme.BORDER
    end)
    self:RegisterElement(Button, Button, self.Frame.Name)
end

function TabMethods:CreateKeybind(flagName, text, defaultKey, callback)
    if Config[flagName] == nil then Config[flagName] = defaultKey.Name end
    Flags[flagName] = { CurrentValue = Config[flagName] }
    local KFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = CurrentTheme.BG_SECONDARY}, self.Frame)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, KFrame)
    local Stroke = create("UIStroke", {Thickness = 1, Color = Color3.fromRGB(32, 32, 38)}, KFrame)
    
    local Lbl = create("TextLabel", {Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = CurrentTheme.TEXT_WHITE, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, KFrame)
    local BBtn = create("TextButton", {Size = UDim2.new(0, 85, 0, 26), Position = UDim2.new(1, -12, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(30, 30, 36), Text = Config[flagName], TextColor3 = CurrentTheme.ACCENT, Font = Enum.Font.GothamBold, TextSize = 11}, KFrame)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, BBtn)
    
    local listening = false
    BBtn.MouseButton1Click:Connect(function() listening = true BBtn.Text = "..." playUISound() end)
    UserInputService.InputBegan:Connect(function(input, gp)
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
    self:RegisterElement(KFrame, Lbl, self.Frame.Name)
end

-- ============================================================================
-- 🔓 ENGINES DE CREACIÓN DE PESTAÑAS (TABS)
-- ============================================================================
function KillerHub:CreateTab(name, iconId)
    local frame = create("ScrollingFrame", {
        Name = name .. "Frame", Size = UDim2.new(1, -24, 1, -24), Position = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = CurrentTheme.BG_SECONDARY, Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = CurrentTheme.ACCENT
    }, ContentContainer)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, frame)
    local stroke = create("UIStroke", {Thickness = 1, Color = CurrentTheme.BORDER}, frame)
    
    local layout = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)}, frame)
    create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, frame)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20) end)

    local btn = create("TextButton", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = ""}, (name == "Settings" and SettingsContainer or SidebarTabsContainer))
    local btnLabel = create("TextLabel", {Size = UDim2.new(1, iconId and -24 or 0, 1, 0), Position = UDim2.new(0, iconId and 24 or 0, 0, 0), BackgroundTransparency = 1, Text = name, TextColor3 = CurrentTheme.TEXT_MUTED, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, btn)

    local iconImg
    if iconId then
        iconImg = create("ImageLabel", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 4, 0.5, -7), BackgroundTransparency = 1, Image = iconId, ImageColor3 = CurrentTheme.TEXT_MUTED}, btn)
    end
    local line = create("Frame", {Name = "IndicatorLine", Size = UDim2.new(0, 2, 0, 14), Position = UDim2.new(0, -4, 0.5, -7), BackgroundColor3 = CurrentTheme.ACCENT, BorderSizePixel = 0, BackgroundTransparency = 1}, btn)
    create("UICorner", {CornerRadius = UDim.new(0, 1)}, line)
    
    local isFirstTab = true for _, _ in pairs(KillerHub.Frames) do isFirstTab = false break end
    KillerHub.Frames[name] = frame KillerHub.Buttons[name] = btn
    
    local function selectTab()
        for tName, tFrame in pairs(KillerHub.Frames) do
            local tBtn = KillerHub.Buttons[tName] local tLine = tBtn:FindFirstChild("IndicatorLine") local tLabel = tBtn:FindFirstChildWhichIsA("TextLabel")
            local tIcon = tBtn:FindFirstChildWhichIsA("ImageLabel")
            if tName == name then 
                tFrame.Visible = true 
                if tLabel then tLabel.TextColor3 = CurrentTheme.TEXT_WHITE end 
                if tLine then tLine.BackgroundTransparency = 0 end
                if tIcon then tIcon.ImageColor3 = CurrentTheme.TEXT_WHITE end
            else 
                tFrame.Visible = false 
                if tLabel then tLabel.TextColor3 = CurrentTheme.TEXT_MUTED end 
                if tLine then tLine.BackgroundTransparency = 1 end 
                if tIcon then tIcon.ImageColor3 = CurrentTheme.TEXT_MUTED end
            end
        end
        KillerHub.CurrentTab = name
    end
    btn.MouseButton1Click:Connect(function() if KillerHub.CurrentTab ~= name then selectTab() playUISound() end end)
    if isFirstTab or name == "Settings" then task.spawn(selectTab) end
    
    table.insert(KillerHub.TargetThemeElements, function()
        frame.BackgroundColor3 = CurrentTheme.BG_SECONDARY
        stroke.Color = CurrentTheme.BORDER
        line.BackgroundColor3 = CurrentTheme.ACCENT
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

SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(SearchInput.Text)
    for _, el in pairs(KillerHub.AllElements) do
        if el.Instance and el.Label then el.Instance.Visible = (q == "") and true or (string.find(string.lower(el.Label.Text or ""), q) and true or false) end
    end
end)

-- ============================================================================
-- 🔓 CONFIGURACIÓN BASE OBLIGATORIA (SETTINGS)
-- ============================================================================
local SettingsTab = KillerHub:CreateTab("Settings", "rbxassetid://10747372517")
SettingsTab:CreateSection("Personalización")
SettingsTab:CreateDropdown("SelectedTheme", "Tema Visual:", {"Crimson Dark", "Midnight Emerald", "Cyberpunk Violet", "Classic Dark"}, function(selected) KillerHub:SetTheme(selected) end)

SettingsTab:CreateSection("Controles del Menú")
SettingsTab:CreateKeybind("ToggleKey", "Cerrar / Abrir Menu (PC)", Enum.KeyCode.RightControl)
SettingsTab:CreateSlider("Volume", "Volumen Interfaz", 0, 1, function(v) Config.Volume = v end)
SettingsTab:CreateSlider("GuiWidth", "Ajustar Ancho Ventana", 0, 1, function(v) updateGuiSize() end)
SettingsTab:CreateSlider("GuiHeight", "Ajustar Alto Ventana", 0, 1, function(v) updateGuiSize() end)

SettingsTab:CreateSection("Seguridad y Limpieza")
SettingsTab:CreateParagraph("⚠️ ADVERTENCIA DE APAGADO", "Si decides apagar el script (Unload), la interfaz se cerrará y se eliminará por completo de la memoria del juego. Todas las funciones de automatización se detendrán.")
SettingsTab:CreateButton("Apagar Script por Completo (Unload)", function() KillerHub:Unload() end)

getgenv().KillerHub = KillerHub
warn([[

  _  _  _  _  _                     _    _         _       
 | |/ / (_)| | |                   | |  | |       | |      
 | ' /   _ | | |  ___  _ __        | |__| |_   _  | |__    
 |  <   | || | | / _ \| '__|       |  __  | | | | | '_ \   
 | . \  | || | ||  __/| |          | |  | | |_| | | |_) |  
 |_|\_\ |_||_|_| \___||_|          |_|  |_|\__,_| |_.__/   
                                                           
                ____   __     __                           
               |  _ \  \ \   / /                           
               | |_) |  \ \_/ /                            
               |  _ <    \   /                             
               | |_) |    | |                              
               |____/     |_|                              
                                                           
  _____                 _                                  
 |  __ \               | |                                 
 | |__) | __ _   ___   | |  ___                            
 |  ___/ / _` | / _ \  | | / _ \                           
 | |    | (_| || (_) | | || (_) |                          
 |_|     \__,_| \___/  |_| \___/                           
                                                           

]])
return KillerHub
