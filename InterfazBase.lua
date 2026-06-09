local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Evitar duplicados de la interfaz
if CoreGui:FindFirstChild("KillerHub_MM2") then
    CoreGui.KillerHub_MM2:Destroy()
end

-- CONTENEDOR PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillerHub_MM2"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- PALETA DE COLORES (Estilo Dark Premium)
local BG_MAIN = Color3.fromRGB(14, 14, 14)      
local BG_SIDEBAR = Color3.fromRGB(18, 18, 18)
local BG_SECONDARY = Color3.fromRGB(22, 22, 22) 
local ACCENT_GREEN = Color3.fromRGB(0, 230, 115) 
local TEXT_WHITE = Color3.fromRGB(240, 240, 240)
local TEXT_MUTED = Color3.fromRGB(130, 130, 130)

-- VENTANA PRINCIPAL
local MainFrame = Instance.new("Frame") 
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = BG_MAIN
MainFrame.BorderSizePixel = 0
MainFrame.Active = true 
MainFrame.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 1 MainStroke.Color = Color3.fromRGB(40, 40, 40) MainStroke.Parent = MainFrame
local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 6) MainCorner.Parent = MainFrame

-- Topbar (Barra superior)
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 40)
Topbar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Topbar.BorderSizePixel = 0
Topbar.Active = true
Topbar.Parent = MainFrame
local TopbarCorner = Instance.new("UICorner") TopbarCorner.CornerRadius = UDim.new(0, 6) TopbarCorner.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -15, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Killer hub | Paolo"
Title.TextColor3 = ACCENT_GREEN
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.Code
Title.TextSize = 15
Title.Parent = Topbar

-- BARRA LATERAL IZQUIERDA (Sidebar Estrecho - 95px)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 95, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = BG_SIDEBAR
Sidebar.BorderSizePixel = 0
Sidebar.Active = true
Sidebar.Parent = MainFrame
local SidebarStroke = Instance.new("UIStroke") SidebarStroke.Thickness = 1 SidebarStroke.Color = Color3.fromRGB(30, 30, 30) SidebarStroke.Parent = Sidebar

-- Contenedor interno superior para los botones de juego (Visuals, Murder, Sheriff)
local SidebarTabsContainer = Instance.new("Frame")
SidebarTabsContainer.Size = UDim2.new(1, 0, 1, -95) -- Ajustado para dar espacio a la nueva posición de Settings
SidebarTabsContainer.BackgroundTransparency = 1
SidebarTabsContainer.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout") SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder SidebarLayout.Padding = UDim.new(0, 4) SidebarLayout.Parent = SidebarTabsContainer
local SidebarPadding = Instance.new("UIPadding") SidebarPadding.PaddingTop = UDim.new(0, 8) SidebarPadding.PaddingLeft = UDim.new(0, 6) SidebarPadding.PaddingRight = UDim.new(0, 6) SidebarPadding.Parent = SidebarTabsContainer

-- CONTENEDOR DE PÁGINAS (Área derecha de contenido)
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -95, 1, -40)
ContentContainer.Position = UDim2.new(0, 95, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Active = true
ContentContainer.Parent = MainFrame

-- Inicialización de los Marcos de cada Pestaña
local VisualsFrame = Instance.new("Frame")
local MurderFrame = Instance.new("Frame")
local SheriffFrame = Instance.new("Frame")
local SettingsFrame = Instance.new("Frame")

local frames = {
    Visuals = VisualsFrame,
    Murder = MurderFrame,
    Sheriff = SheriffFrame,
    Settings = SettingsFrame
}

for name, frame in pairs(frames) do
    frame.Name = name .. "Frame"
    frame.Size = UDim2.new(1, -16, 1, -16)
    frame.Position = UDim2.new(0, 8, 0, 8)
    frame.BackgroundColor3 = BG_SECONDARY
    frame.Visible = (name == "Visuals")
    frame.Active = true
    frame.Parent = ContentContainer
    
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = frame
    local s = Instance.new("UIStroke") s.Thickness = 1 s.Color = Color3.fromRGB(32, 32, 32) s.Parent = frame
end

-- SISTEMA DINÁMICO DE NAVEGACIÓN
local currentTab = "Visuals"
local tabButtons = {}

local function updateTabVisuals(selectedName)
    for name, button in pairs(tabButtons) do
        button.TextColor3 = (name == selectedName) and ACCENT_GREEN or TEXT_MUTED
    end
    for name, frame in pairs(frames) do
        frame.Visible = (name == selectedName)
    end
    currentTab = selectedName
end

local function createTabBtn(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = (text == currentTab) and ACCENT_GREEN or TEXT_MUTED
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15 -- ¡Aumentado para mayor claridad!
    btn.LayoutOrder = order
    btn.Active = true
    btn.Parent = SidebarTabsContainer
    
    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 4) corner.Parent = btn
    tabButtons[text] = btn
    
    btn.MouseButton1Click:Connect(function()
        updateTabVisuals(text)
    end)
end

-- Crear pestañas de categorías en la parte superior
createTabBtn("Visuals", 1)
createTabBtn("Murder", 2)
createTabBtn("Sheriff", 3)

-- BOTÓN DE SETTINGS (Posicionado idealmente más arriba del fondo)
local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Name = "SettingsTabButton"
SettingsBtn.Size = UDim2.new(1, -12, 0, 32)
SettingsBtn.Position = UDim2.new(0, 6, 1, -55) -- Subido ligeramente para que no quede tan abajo
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Text = "Settings"
SettingsBtn.TextColor3 = TEXT_MUTED
SettingsBtn.Font = Enum.Font.SourceSansBold
SettingsBtn.TextSize = 15 -- ¡Aumentado al mismo tamaño de las otras letras!
SettingsBtn.Active = true
SettingsBtn.Parent = Sidebar

local SettingsBtnCorner = Instance.new("UICorner") SettingsBtnCorner.CornerRadius = UDim.new(0, 4) SettingsBtnCorner.Parent = SettingsBtn
tabButtons["Settings"] = SettingsBtn

SettingsBtn.MouseButton1Click:Connect(function()
    updateTabVisuals("Settings")
end)

-- FABRICA DE COMPONENTES INTERNOS (Constructores del Menu)

-- 1. CREADOR DE TOGGLES
local function createToggle(name, text, position, parent, callback)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = name
    ToggleButton.Size = UDim2.new(1, -24, 0, 40)
    ToggleButton.Position = position
    ToggleButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Active = true
    ToggleButton.Parent = parent

    local ToggleCorner = Instance.new("UICorner") ToggleCorner.CornerRadius = UDim.new(0, 4) ToggleCorner.Parent = ToggleButton
    local ToggleStroke = Instance.new("UIStroke") ToggleStroke.Thickness = 1 ToggleStroke.Color = Color3.fromRGB(40, 40, 40) ToggleStroke.Parent = ToggleButton

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = TEXT_MUTED
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Font = Enum.Font.SourceSansBold
    ToggleLabel.TextSize = 14
    ToggleLabel.Parent = ToggleButton

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.Position = UDim2.new(1, -28, 0.5, -8)
    Indicator.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Indicator.Parent = ToggleButton
    local IndicatorCorner = Instance.new("UICorner") IndicatorCorner.CornerRadius = UDim.new(0, 3) IndicatorCorner.Parent = Indicator

    local state = false
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundColor3 = state and ACCENT_GREEN or Color3.fromRGB(45, 45, 45)}):Play()
        ToggleLabel.TextColor3 = state and TEXT_WHITE or TEXT_MUTED
        callback(state)
    end)
end

-- 2. CREADOR DE SLIDERS
local function createSlider(name, text, position, parent, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.Size = UDim2.new(1, -24, 0, 45)
    SliderFrame.Position = position
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Active = true
    SliderFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 180, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = TEXT_WHITE
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 40, 0, 20)
    ValueLabel.Position = UDim2.new(1, -40, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = "100%"
    ValueLabel.TextColor3 = ACCENT_GREEN
    ValueLabel.Font = Enum.Font.Code
    ValueLabel.TextSize = 12
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame

    local Track = Instance.new("TextButton")
    Track.Size = UDim2.new(1, 0, 0, 4) 
    Track.Position = UDim2.new(0, 0, 0, 26)
    Track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Track.Text = ""
    Track.AutoButtonColor = false
    Track.Active = true 
    Track.Parent = SliderFrame
    local TrackCorner = Instance.new("UICorner") TrackCorner.CornerRadius = UDim.new(0, 2) TrackCorner.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(1, 0, 1, 0) 
    Fill.BackgroundColor3 = ACCENT_GREEN
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    local FillCorner = Instance.new("UICorner") FillCorner.CornerRadius = UDim.new(0, 2) FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 10, 0, 10)
    Knob.Position = UDim2.new(1, -5, 0.5, -5)
    Knob.BackgroundColor3 = TEXT_WHITE
    Knob.Active = true
    Knob.Parent = Track
    local KnobCorner = Instance.new("UICorner") KnobCorner.CornerRadius = UDim.new(1, 0) KnobCorner.Parent = Knob
    local KnobStroke = Instance.new("UIStroke") KnobStroke.Thickness = 1 KnobStroke.Color = Color3.fromRGB(0, 0, 0) KnobStroke.Parent = Knob

    local function updateSlider(input)
        local percentage = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        Knob.Position = UDim2.new(percentage, -5, 0.5, -5)
        ValueLabel.Text = math.floor(percentage * 100) .. "%"
        callback(percentage)
    end

    local sliding = false
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true 
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
        end
    end)
end

-- COMPONENTES BASE DE CONFIGURACIÓN
createSlider("MenuOpacity", "Menu Transparency", UDim2.new(0, 12, 0, 15), SettingsFrame, function(val)
    local alpha = 1 - val
    MainFrame.BackgroundTransparency = alpha
    Topbar.BackgroundTransparency = alpha
    Sidebar.BackgroundTransparency = alpha
    VisualsFrame.BackgroundTransparency = alpha
    MurderFrame.BackgroundTransparency = alpha
    SheriffFrame.BackgroundTransparency = alpha
    SettingsFrame.BackgroundTransparency = alpha
end)

-- BOTÓN FLOTANTE DINÁMICO (Cambia entre "K" y "H")
local OpenCloseBtn = Instance.new("TextButton")
OpenCloseBtn.Name = "KillerHubToggle"
OpenCloseBtn.Size = UDim2.new(0, 45, 0, 45)
OpenCloseBtn.Position = UDim2.new(0, 20, 0, 20) 
OpenCloseBtn.BackgroundColor3 = BG_MAIN
OpenCloseBtn.Text = "H" 
OpenCloseBtn.TextColor3 = ACCENT_GREEN
OpenCloseBtn.Font = Enum.Font.SourceSansBold
OpenCloseBtn.TextSize = 20 
OpenCloseBtn.Active = true 
OpenCloseBtn.Parent = ScreenGui

local BtnCorner = Instance.new("UICorner") BtnCorner.CornerRadius = UDim.new(0, 8) BtnCorner.Parent = OpenCloseBtn
local BtnStroke = Instance.new("UIStroke") BtnStroke.Thickness = 1 BtnStroke.Color = Color3.fromRGB(40, 40, 40) BtnStroke.Parent = OpenCloseBtn

createSlider("ButtonOpacity", "Button Transparency", UDim2.new(0, 12, 0, 75), SettingsFrame, function(val)
    local alpha = 1 - val
    OpenCloseBtn.BackgroundTransparency = alpha
    OpenCloseBtn.TextTransparency = alpha
    BtnStroke.Transparency = alpha
end)

local menuVisible = true
OpenCloseBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    
    if menuVisible then
        OpenCloseBtn.Text = "H"
        OpenCloseBtn.TextColor3 = ACCENT_GREEN
    else
        OpenCloseBtn.Text = "K"
        OpenCloseBtn.TextColor3 = TEXT_WHITE
    end
end)

-- ARRASTRE MULTITOUCH DEL BOTÓN FLOTANTE
local dragStart = nil local startPos = nil local draggingInput = nil

OpenCloseBtn.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        draggingInput = input
        dragStart = input.Position
        startPos = OpenCloseBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == draggingInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        OpenCloseBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

OpenCloseBtn.InputEnded:Connect(function(input)
    if input == draggingInput then draggingInput = nil end
end)

-- ============================================================================
-- 📝 GUÍA DE EJEMPLO: ¿CÓMO AÑADIR NUEVAS FUNCIONES DESDE TU GITHUB?
-- ============================================================================
-- EJEMPLO:
-- createToggle("AutoKillToggle", "Kill Everyone", UDim2.new(0, 12, 0, 15), MurderFrame, function(estado)
--     print("Estado cambiado")
-- end)
-- ===========================================================================
