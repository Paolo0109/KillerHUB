local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- Evitar duplicados de la interfaz
if CoreGui:FindFirstChild("KillerHub_MM2") then
    CoreGui.KillerHub_MM2:Destroy()
end

-- ============================================================================
-- 💾 SISTEMA DE CONFIGURACIÓN AUTOMÁTICA (AUTO-SAVE)
-- ============================================================================
local FILE_NAME = "KillerHub_MM2_Config.json"
local Config = {
    Highlights = false,
    Boxes = false,
    Names = false,
    NameSize = 0.3,
    GunHighlight = false,
    GunEspName = false,
    MenuOpacity = 1,
    ButtonOpacity = 1,
    GuiWidth = 0.466,  
    GuiHeight = 0.4,   
    Volume = 0.5,       
}

local function saveConfig()
    if writefile then
        local success, json = pcall(function() return HttpService:JSONEncode(Config) end)
        if success then writefile(FILE_NAME, json) end
    end
end

local function loadConfig()
    if isfile and readfile and isfile(FILE_NAME) then
        local success, json = pcall(function() return readfile(FILE_NAME) end)
        if success then
            local success2, data = pcall(function() return HttpService:JSONDecode(json) end)
            if success2 and type(data) == "table" then
                for k, v in pairs(data) do Config[k] = v end
            end
        end
    end
end

loadConfig()

-- ============================================================================
-- 🔊 REPRODUCTOR DE SONIDOS
-- ============================================================================
local function playUISound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://101735926591481" 
    sound.Volume = Config.Volume or 0.5          
    sound.Parent = SoundService
    sound:Play()
    Debris:AddItem(sound, 2)
end

-- PALETA DE COLORES PREMIUM
local BG_MAIN = Color3.fromRGB(12, 12, 12)  
local BG_SIDEBAR = Color3.fromRGB(16, 16, 16)
local BG_SECONDARY = Color3.fromRGB(20, 20, 20) 
local ACCENT_GREEN = Color3.fromRGB(0, 230, 115) 
local TEXT_WHITE = Color3.fromRGB(245, 245, 245)
local TEXT_MUTED = Color3.fromRGB(120, 120, 120)
local BORDER_COLOR = Color3.fromRGB(35, 35, 35)

-- CONTENEDOR PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillerHub_MM2"
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame") 
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = BG_MAIN
MainFrame.BorderSizePixel = 0
MainFrame.Active = true 
MainFrame.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 1 MainStroke.Color = BORDER_COLOR MainStroke.Parent = MainFrame
local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 8) MainCorner.Parent = MainFrame

local function updateGuiSize()
    local wPercent = Config.GuiWidth or 0.466
    local hPercent = Config.GuiHeight or 0.4
    local finalWidth = math.floor(400 + (wPercent * 300))  
    local finalHeight = math.floor(250 + (hPercent * 250)) 
    MainFrame.Size = UDim2.new(0, finalWidth, 0, finalHeight)
end
updateGuiSize()
MainFrame.Position = UDim2.new(0.5, -MainFrame.AbsoluteSize.X/2, 0.5, -MainFrame.AbsoluteSize.Y/2)

-- Topbar con tu nuevo título personalizado 👻
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 45)
Topbar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Topbar.BorderSizePixel = 0
Topbar.Active = true
Topbar.Parent = MainFrame
local TopbarCorner = Instance.new("UICorner") TopbarCorner.CornerRadius = UDim.new(0, 8) TopbarCorner.Parent = Topbar

local TopbarLine = Instance.new("Frame")
TopbarLine.Size = UDim2.new(1, 0, 0, 10)
TopbarLine.Position = UDim2.new(0, 0, 1, -10)
TopbarLine.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
TopbarLine.BorderSizePixel = 0
TopbarLine.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Killer Hub  |  by Paolo 👻" 
Title.TextColor3 = ACCENT_GREEN 
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Topbar

local DecorLine = Instance.new("Frame")
DecorLine.Size = UDim2.new(0, 60, 0, 2)
DecorLine.Position = UDim2.new(0, 18, 1, -2)
DecorLine.BackgroundColor3 = ACCENT_GREEN
DecorLine.BorderSizePixel = 0
DecorLine.Parent = Topbar

-- ARRASTRE FLUIDO DE VENTANA
local mainDragStart, mainStartPos, mainDraggingInput
Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDraggingInput = input
        mainDragStart = input.Position
        mainStartPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == mainDraggingInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mainDragStart
        MainFrame.Position = UDim2.new(mainStartPos.X.Scale, mainStartPos.X.Offset + delta.X, mainStartPos.Y.Scale, mainStartPos.Y.Offset + delta.Y)
    end
end)
Topbar.InputEnded:Connect(function(input)
    if input == mainDraggingInput then mainDraggingInput = nil end
end)

-- BARRA LATERAL IZQUIERDA
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 110, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = BG_SIDEBAR
Sidebar.BorderSizePixel = 0
Sidebar.Active = true
Sidebar.Parent = MainFrame
local SidebarStroke = Instance.new("UIStroke") SidebarStroke.Thickness = 1 SidebarStroke.Color = Color3.fromRGB(24, 24, 24) SidebarStroke.Parent = Sidebar

local SidebarTabsContainer = Instance.new("Frame")
SidebarTabsContainer.Size = UDim2.new(1, 0, 1, -60)
SidebarTabsContainer.BackgroundTransparency = 1
SidebarTabsContainer.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout") SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder SidebarLayout.Padding = UDim.new(0, 6) SidebarLayout.Parent = SidebarTabsContainer
local SidebarPadding = Instance.new("UIPadding") SidebarPadding.PaddingTop = UDim.new(0, 12) SidebarPadding.PaddingLeft = UDim.new(0, 8) SidebarPadding.PaddingRight = UDim.new(0, 8) SidebarPadding.Parent = SidebarTabsContainer

local SettingsContainer = Instance.new("Frame")
SettingsContainer.Size = UDim2.new(1, -16, 0, 40)
SettingsContainer.Position = UDim2.new(0, 8, 1, -48)
SettingsContainer.BackgroundTransparency = 1
SettingsContainer.Parent = Sidebar

-- CONTENEDOR DE PÁGINAS
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -110, 1, -45)
ContentContainer.Position = UDim2.new(0, 110, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Active = true
ContentContainer.Parent = MainFrame

-- BOTÓN FLOTANTE RECTANGULAR
local OpenCloseBtn = Instance.new("TextButton")
OpenCloseBtn.Name = "KillerHubToggle"
OpenCloseBtn.Size = UDim2.new(0, 48, 0, 48)
OpenCloseBtn.Position = UDim2.new(
    Config.ToggleScaleX or 0, Config.ToggleOffsetX or 25, 
    Config.ToggleScaleY or 0, Config.ToggleOffsetY or 120
)
OpenCloseBtn.BackgroundColor3 = BG_MAIN
OpenCloseBtn.Text = "K" 
OpenCloseBtn.TextColor3 = ACCENT_GREEN
OpenCloseBtn.Font = Enum.Font.GothamBold
OpenCloseBtn.TextSize = 18 
OpenCloseBtn.Active = true 
OpenCloseBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner") BtnCorner.CornerRadius = UDim.new(0, 8) BtnCorner.Parent = OpenCloseBtn
local BtnStroke = Instance.new("UIStroke") BtnStroke.Thickness = 1.5 BtnStroke.Color = Color3.fromRGB(45, 45, 45) BtnStroke.Parent = OpenCloseBtn

task.spawn(function()
    local alpha = 1 - (Config.ButtonOpacity or 1)
    OpenCloseBtn.BackgroundTransparency = alpha
    OpenCloseBtn.TextTransparency = alpha
    BtnStroke.Transparency = alpha
end)

local menuVisible = true
OpenCloseBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    OpenCloseBtn.Text = menuVisible and "K" or "H"
    OpenCloseBtn.TextColor3 = menuVisible and ACCENT_GREEN or TEXT_WHITE
    playUISound()
end)

local dragStart = nil local startPos = nil local draggingInput = nil
OpenCloseBtn.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        draggingInput = input; dragStart = input.Position; startPos = OpenCloseBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingInput and input == draggingInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        OpenCloseBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
OpenCloseBtn.InputEnded:Connect(function(input) 
    if input == draggingInput then 
        draggingInput = nil 
        Config.ToggleScaleX = OpenCloseBtn.Position.X.Scale
        Config.ToggleOffsetX = OpenCloseBtn.Position.X.Offset
        Config.ToggleScaleY = OpenCloseBtn.Position.Y.Scale
        Config.ToggleOffsetY = OpenCloseBtn.Position.Y.Offset
        saveConfig()
    end 
end)

-- ============================================================================
-- 🚀 NÚCLEO DE LA API: INTERFAZ DE DESARROLLO (UI LIBRARY ENGINE)
-- ============================================================================
local KillerHub = {
    Tabs = {},
    Frames = {},
    Buttons = {},
    CurrentTab = nil
}

-- MÉTODOS DE ELEMENTOS (Se heredan a cada pestaña automáticamente)
local TabMethods = {}
TabMethods.__index = TabMethods

function TabMethods:CreateToggle(configName, text, callback)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = configName
    ToggleButton.Size = UDim2.new(1, 0, 0, 44)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Active = true
    ToggleButton.Parent = self.Frame

    local ToggleCorner = Instance.new("UICorner") ToggleCorner.CornerRadius = UDim.new(0, 6) ToggleCorner.Parent = ToggleButton
    local ToggleStroke = Instance.new("UIStroke") ToggleStroke.Thickness = 1 ToggleStroke.Color = Color3.fromRGB(36, 36, 36) ToggleStroke.Parent = ToggleButton

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 14, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = TEXT_MUTED
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Font = Enum.Font.GothamMedium
    ToggleLabel.TextSize = 13
    ToggleLabel.Parent = ToggleButton

    local SwitchTrack = Instance.new("Frame")
    SwitchTrack.Size = UDim2.new(0, 36, 0, 20)
    SwitchTrack.Position = UDim2.new(1, -50, 0.5, -10)
    SwitchTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SwitchTrack.Parent = ToggleButton
    local TrackCorner = Instance.new("UICorner") TrackCorner.CornerRadius = UDim.new(1, 0) TrackCorner.Parent = SwitchTrack

    local SwitchKnob = Instance.new("Frame")
    SwitchKnob.Size = UDim2.new(0, 14, 0, 14)
    SwitchKnob.BackgroundColor3 = TEXT_WHITE
    SwitchKnob.Parent = SwitchTrack
    local KnobCorner = Instance.new("UICorner") KnobCorner.CornerRadius = UDim.new(1, 0) KnobCorner.Parent = SwitchKnob

    if Config[configName] == nil then Config[configName] = false end
    local state = Config[configName]
    
    local function updateVisualState(animated)
        local duration = animated and 0.2 or 0
        if state then
            TweenService:Create(SwitchTrack, TweenInfo.new(duration), {BackgroundColor3 = ACCENT_GREEN}):Play()
            TweenService:Create(SwitchKnob, TweenInfo.new(duration), {Position = UDim2.new(1, -16, 0.5, -7)}):Play()
            TweenService:Create(ToggleLabel, TweenInfo.new(duration), {TextColor3 = TEXT_WHITE}):Play()
        else
            TweenService:Create(SwitchTrack, TweenInfo.new(duration), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            TweenService:Create(SwitchKnob, TweenInfo.new(duration), {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
            TweenService:Create(ToggleLabel, TweenInfo.new(duration), {TextColor3 = TEXT_MUTED}):Play()
        end
    end
    updateVisualState(false)
    task.spawn(function() callback(state) end)

    ToggleButton.MouseEnter:Connect(function() TweenService:Create(ToggleStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(50, 50, 50)}):Play() end)
    ToggleButton.MouseLeave:Connect(function() TweenService:Create(ToggleStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(36, 36, 36)}):Play() end)

    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        Config[configName] = state
        saveConfig()
        playUISound() 
        updateVisualState(true)
        callback(state)
    end)
end

function TabMethods:CreateSlider(configName, text, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = configName
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Active = true
    SliderFrame.Parent = self.Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 200, 0, 20)
    Label.Position = UDim2.new(0, 2, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = TEXT_WHITE
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local ValueLabel = Instance.new("TextBox")
    ValueLabel.Size = UDim2.new(0, 45, 0, 20)
    ValueLabel.Position = UDim2.new(1, -5, 0, 0)
    ValueLabel.AnchorPoint = Vector2.new(1, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = ACCENT_GREEN
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 12
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.ClearTextOnFocus = false
    ValueLabel.Parent = SliderFrame

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -10, 0, 8) 
    Track.Position = UDim2.new(0, 2, 0, 28)
    Track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Track.BorderSizePixel = 0
    Track.Parent = SliderFrame
    local TrackCorner = Instance.new("UICorner") TrackCorner.CornerRadius = UDim.new(0, 4) TrackCorner.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.BackgroundColor3 = ACCENT_GREEN
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    local FillCorner = Instance.new("UICorner") FillCorner.CornerRadius = UDim.new(0, 4) FillCorner.Parent = Fill

    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.BackgroundColor3 = TEXT_WHITE
    Knob.Text = ""
    Knob.AutoButtonColor = false
    Knob.Active = true
    Knob.Parent = Track
    local KnobCorner = Instance.new("UICorner") KnobCorner.CornerRadius = UDim.new(1, 0) KnobCorner.Parent = Knob
    local KnobStroke = Instance.new("UIStroke") KnobStroke.Thickness = 2 KnobStroke.Color = Color3.fromRGB(15, 15, 15) KnobStroke.Parent = Knob

    if Config[configName] == nil then Config[configName] = 0.5 end
    local percentage = Config[configName]
    
    local function setSliderValue(computedPercent)
        computedPercent = math.clamp(computedPercent, 0, 1)
        Config[configName] = computedPercent
        saveConfig()
        Fill.Size = UDim2.new(computedPercent, 0, 1, 0)
        Knob.Position = UDim2.new(computedPercent, -7, 0.5, -7)
        ValueLabel.Text = math.floor(computedPercent * 100) .. "%"
        callback(computedPercent)
    end

    setSliderValue(percentage)

    local function updateSlider(input)
        local computedPercent = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        setSliderValue(computedPercent)
    end

    local sliding = false
    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            TweenService:Create(Knob, TweenInfo.new(0.1), {BackgroundColor3 = ACCENT_GREEN}):Play()
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
            TweenService:Create(Knob, TweenInfo.new(0.1), {BackgroundColor3 = TEXT_WHITE}):Play()
        end
    end)

    ValueLabel.FocusLost:Connect(function(enterPressed)
        local cleanText = ValueLabel.Text:gsub("%%", "")
        local num = tonumber(cleanText)
        if num then setSliderValue(num / 100) else ValueLabel.Text = math.floor(Config[configName] * 100) .. "%" end
    end)
end

function TabMethods:CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    Button.Text = text
    Button.TextColor3 = TEXT_WHITE
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 13
    Button.Active = true
    Button.Parent = self.Frame

    local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = Button
    local Stroke = Instance.new("UIStroke") Stroke.Thickness = 1 Stroke.Color = Color3.fromRGB(42, 42, 42) Stroke.Parent = Button

    Button.MouseEnter:Connect(function() 
        TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(34, 34, 34)}):Play() 
    end)
    Button.MouseLeave:Connect(function() 
        TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play() 
    end)
    Button.MouseButton1Click:Connect(function()
        playUISound()
        -- Animación de click rápido
        Button.TextColor3 = ACCENT_GREEN
        task.delay(0.1, function() Button.TextColor3 = TEXT_WHITE end)
        callback()
    end)
end

function TabMethods:CreateSection(text)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Size = UDim2.new(1, 0, 0, 24)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Parent = self.Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text:upper()
    Label.TextColor3 = ACCENT_GREEN
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SectionFrame
end

-- INICIALIZADOR DE PESTAÑAS PRINCIPALES
function KillerHub:CreateTab(name, order, customParent)
    local isSettings = (name == "Settings")
    local frame
    
    if isSettings or name == "Visuals" or name == "Sheriff" or name == "Murder" or name == "Extras" then
        frame = Instance.new("ScrollingFrame")
        frame.ScrollBarThickness = 2
        frame.ScrollBarImageColor3 = ACCENT_GREEN
        frame.BackgroundTransparency = 1
        frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    else
        frame = Instance.new("Frame")
        frame.BackgroundTransparency = 1
    end
    
    frame.Name = name .. "Frame"
    frame.Size = UDim2.new(1, -24, 1, -24)
    frame.Position = UDim2.new(0, 12, 0, 12)
    frame.BackgroundColor3 = BG_SECONDARY
    frame.Visible = false
    frame.Active = true
    frame.Parent = ContentContainer
    
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 6) c.Parent = frame
    local s = Instance.new("UIStroke") s.Thickness = 1 s.Color = Color3.fromRGB(28, 28, 28) s.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = frame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = frame

    if frame:IsA("ScrollingFrame") then
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
        end)
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = TEXT_MUTED
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.LayoutOrder = order
    btn.Active = true
    btn.Parent = customParent or SidebarTabsContainer
    
    local line = Instance.new("Frame")
    line.Name = "IndicatorLine"
    line.Size = UDim2.new(0, 3, 0, 16)
    line.Position = UDim2.new(0, -2, 0.5, -8)
    line.BackgroundColor3 = ACCENT_GREEN
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 1
    line.Parent = btn
    
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 2) corner.Parent = line
    
    self.Frames[name] = frame
    self.Buttons[name] = btn
    
    local function selectTab()
        for tName, tFrame in pairs(self.Frames) do
            local tBtn = self.Buttons[tName]
            local tLine = tBtn:FindFirstChild("IndicatorLine")
            if tName == name then
                tFrame.Visible = true
                TweenService:Create(tBtn, TweenInfo.new(0.2), {TextColor3 = TEXT_WHITE}):Play()
                if tLine then TweenService:Create(tLine, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play() end
            else
                tFrame.Visible = false
                TweenService:Create(tBtn, TweenInfo.new(0.2), {TextColor3 = TEXT_MUTED}):Play()
                if tLine then TweenService:Create(tLine, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end
            end
        end
        self.CurrentTab = name
    end

    btn.MouseEnter:Connect(function()
        if self.CurrentTab ~= name then TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = TEXT_WHITE}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if self.CurrentTab ~= name then TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = TEXT_MUTED}):Play() end
    end)
    btn.MouseButton1Click:Connect(function()
        if self.CurrentTab ~= name then selectTab() playUISound() end
    end)

    if order == 1 then selectTab() end
    
    -- Empaquetar el contenedor en un objeto con métodos heredados (Estilo OOP/API Library)
    local tabObject = setmetatable({ Frame = frame }, TabMethods)
    self.Tabs[name] = tabObject
    return tabObject
end


-- ============================================================================
-- 📡 RENDERIZADO VISUAL 3D (ESP ENGINE INTEGRADO)
-- ============================================================================
local RunService = game:GetService("RunService")
local rolesPartida = {}

local ColoresESP = {
    Murder = Color3.fromRGB(215, 25, 25),
    Sheriff = Color3.fromRGB(25, 100, 225),
    Hero = Color3.fromRGB(215, 160, 0),
    Innocent = Color3.fromRGB(25, 175, 80)
}

local function obtenerColorYRolJugador(playerName)
    local rol = rolesPartida[playerName] or "Innocent"
    local p = Players:FindFirstChild(playerName)
    if p and rol ~= "Murderer" and rol ~= "Sheriff" then
        local char = p.Character
        local backpack = p:FindFirstChild("Backpack")
        if (char and char:FindFirstChild("Gun")) or (backpack and backpack:FindFirstChild("Gun")) then rol = "Hero" end
    end
    if rol == "Murderer" then return ColoresESP.Murder, "Murderer" end
    if rol == "Sheriff" then return ColoresESP.Sheriff, "Sheriff" end
    if rol == "Hero" then return ColoresESP.Hero, "Hero" end
    return ColoresESP.Innocent, "Innocent"
end

local playerDataRemote = ReplicatedStorage:FindFirstChild("PlayerDataChanged", true)
if playerDataRemote then
    playerDataRemote.OnClientEvent:Connect(function(roundData)
        if type(roundData) == "table" then
            rolesPartida = {} 
            for playerName, info in pairs(roundData) do
                if type(info) == "table" and info.Role then rolesPartida[playerName] = info.Role end
            end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if not Config.Highlights then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("KillerHub_Highlight") then p.Character.KillerHub_Highlight:Destroy() end
            end
            continue
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            local color = obtenerColorYRolJugador(p.Name)
            local hl = p.Character:FindFirstChild("KillerHub_Highlight")
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "KillerHub_Highlight"
                hl.Parent = p.Character
            end
            hl.FillColor = color
            hl.OutlineColor = color
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0.2
        end
    end
end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local char = p.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local hrp = char.HumanoidRootPart
            local color, rol = obtenerColorYRolJugador(p.Name)
            
            local box = char:FindFirstChild("KH_BoxGui")
            if Config.Boxes then
                if not box then
                    box = Instance.new("BillboardGui")
                    box.Name = "KH_BoxGui"
                    box.AlwaysOnTop = true
                    box.Size = UDim2.new(4.5, 0, 6, 0)
                    box.Parent = char
                    local f = Instance.new("Frame")
                    f.Name = "BoxFrame"
                    f.Size = UDim2.new(1, 0, 1, 0)
                    f.BackgroundTransparency = 1
                    f.Parent = box
                    local stroke = Instance.new("UIStroke")
                    stroke.Thickness = 1
                    stroke.Parent = f
                end
                box.Adornee = hrp
                if box:FindFirstChild("BoxFrame") and box.BoxFrame:FindFirstChildWhichIsA("UIStroke") then
                    box.BoxFrame.UIStroke.Color = color
                end
            else
                if box then box:Destroy() end
            end
        
            local nameEs = char:FindFirstChild("KH_NameGui")
            if Config.Names then
                if not nameEs then
                    nameEs = Instance.new("BillboardGui")
                    nameEs.Name = "KH_NameGui"
                    nameEs.AlwaysOnTop = true
                    nameEs.Size = UDim2.new(0, 120, 0, 25)
                    nameEs.StudsOffset = Vector3.new(0, 3, 0)
                    nameEs.Parent = char
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Font = Enum.Font.SourceSansBold
                    tl.TextStrokeTransparency = 0
                    tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    tl.Parent = nameEs
                end
                nameEs.Adornee = hrp
                nameEs.TextLabel.Text = p.Name .. " [" .. rol .. "]"
                nameEs.TextLabel.TextColor3 = color
                nameEs.TextLabel.TextSize = math.floor(10 + ((Config.NameSize or 0.3) * 14))
            else
                if nameEs then nameEs:Destroy() end
            end
        else
            if char then
                if char:FindFirstChild("KH_BoxGui") then char.KH_BoxGui:Destroy() end
                if char:FindFirstChild("KH_NameGui") then char.KH_NameGui:Destroy() end
            end
        end
    end

    local pistolaModel = Workspace:FindFirstChild("GunDrop", true)
    if pistolaModel then
        local gunPosition = nil
        if pistolaModel:IsA("BasePart") then
            gunPosition = pistolaModel.Position
        elseif pistolaModel:IsA("Model") then
            local realPart = pistolaModel:FindFirstChild("Handle") or pistolaModel:FindFirstChildWhichIsA("BasePart")
            if realPart then gunPosition = realPart.Position else gunPosition = pistolaModel:GetPivot().Position end
        end
        if gunPosition then
            local gunHl = pistolaModel:FindFirstChild("KH_GunHighlight")
            if Config.GunHighlight then
                if not gunHl then 
                    gunHl = Instance.new("Highlight")
                    gunHl.Name = "KH_GunHighlight"
                    gunHl.Parent = pistolaModel 
                end
                gunHl.FillColor = Color3.fromRGB(180, 0, 0)
                gunHl.OutlineColor = Color3.fromRGB(0, 0, 0)
                gunHl.FillTransparency = 0.25
                gunHl.OutlineTransparency = 0
            else
                if gunHl then gunHl:Destroy() end
            end

            local gunNameEs = pistolaModel:FindFirstChild("KH_GunNameGui")
            if Config.GunEspName then
                if not gunNameEs then
                    gunNameEs = Instance.new("BillboardGui")
                    gunNameEs.Name = "KH_GunNameGui"
                    gunNameEs.AlwaysOnTop = true
                    gunNameEs.Size = UDim2.new(0, 150, 0, 30)
                    gunNameEs.StudsOffset = Vector3.new(0, 2, 0)
                    gunNameEs.Parent = pistolaModel
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Font = Enum.Font.Code 
                    tl.TextSize = 16
                    tl.TextColor3 = Color3.fromRGB(200, 0, 0) 
                    tl.TextStrokeTransparency = 0
                    tl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                    tl.Text = "GUN DROP 🇦🇱" 
                    tl.Parent = gunNameEs
                end
            else
                if gunNameEs then gunNameEs:Destroy() end
            end
        end
    else
        local globalHl = Workspace:FindFirstChild("KH_GunHighlight", true)
        if globalHl then globalHl:Destroy() end
        local globalGui = Workspace:FindFirstChild("KH_GunNameGui", true)
        if globalGui then globalGui:Destroy() end
    end
end)


-- ============================================================================
-- 🧱 INSTANCIACIÓN DE LAS PESTAÑAS DEL HUB
-- ============================================================================
local VisualsTab = KillerHub:CreateTab("Visuals", 1)
local MurderTab  = KillerHub:CreateTab("Murder", 2)
local SheriffTab = KillerHub:CreateTab("Sheriff", 3)
local ExtrasTab  = KillerHub:CreateTab("Extras", 4)
local SettingsTab = KillerHub:CreateTab("Settings", 5, SettingsContainer)

-- OPCIONES INTEGRADAS: VISUALS
VisualsTab:CreateSection("Player Visual Tracking")
VisualsTab:CreateToggle("Highlights", "Instant Highlight Roles", function(state) end)
VisualsTab:CreateToggle("Boxes", "ESP Box (Thin Outline)", function(state) end)
VisualsTab:CreateToggle("Names", "ESP Name (Roles Colored)", function(state) end)
VisualsTab:CreateSlider("NameSize", "ESP Name Text Size", function(val) end)
VisualsTab:CreateSection("Objective Visual Tracking")
VisualsTab:CreateToggle("GunHighlight", "Gun Drop Highlight (Blood Red)", function(state) end)
VisualsTab:CreateToggle("GunEspName", "Gun Drop ESP Name 🇦🇱", function(state) end)

-- OPCIONES INTEGRADAS: SETTINGS
SettingsTab:CreateSlider("MenuOpacity", "Menu Transparency", function(val)
    local alpha = 1 - val
    MainFrame.BackgroundTransparency = alpha
    Topbar.BackgroundTransparency = alpha
    TopbarLine.BackgroundTransparency = alpha
    Sidebar.BackgroundTransparency = alpha
    for _, tabObj in pairs(KillerHub.Tabs) do tabObj.Frame.BackgroundTransparency = alpha end
end)
SettingsTab:CreateSlider("ButtonOpacity", "Button Transparency", function(val)
    local alpha = 1 - val
    OpenCloseBtn.BackgroundTransparency = alpha
    OpenCloseBtn.TextTransparency = alpha
    if OpenCloseBtn:FindFirstChildWhichIsA("UIStroke") then OpenCloseBtn.UIStroke.Transparency = alpha end
end)
SettingsTab:CreateSlider("GuiWidth", "Horizontal Size (Width)", function(val) updateGuiSize() end)
SettingsTab:CreateSlider("GuiHeight", "Vertical Size (Height)", function(val) updateGuiSize() end)
SettingsTab:CreateSlider("Volume", "UI Sound Volume", function(val) end)

-- ============================================================================
-- 🔓 EXPOSICIÓN GLOBAL Y DEVOLUCIÓN DE LA API (Para Inyección vía GitHub)
-- ============================================================================
getgenv().KillerHub = KillerHub
warn("✅ [KillerHub API Framework cargado de forma global]")
return KillerHub
