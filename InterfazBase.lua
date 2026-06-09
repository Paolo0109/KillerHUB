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
SidebarTabsContainer.Size = UDim2.new(1, 0, 1, -95)
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
    btn.TextSize = 15
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

-- BOTÓN DE SETTINGS
local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Name = "SettingsTabButton"
SettingsBtn.Size = UDim2.new(1, -12, 0, 32)
SettingsBtn.Position = UDim2.new(0, 6, 1, -55)
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Text = "Settings"
SettingsBtn.TextColor3 = TEXT_MUTED
SettingsBtn.Font = Enum.Font.SourceSansBold
SettingsBtn.TextSize = 15
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
-- 🧠 INYECCIÓN AUTOMÁTICA DE VISUALES & ESCANEO DE ROLES (PAOLO OPTIMIZED)
-- ============================================================================
-- Módulo integrado de forma nativa al final del script para evitar archivos secundarios.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

local rolesPartida = {}
local visualState = {
    Highlights = false,
    Boxes = false,
    Names = false,
    Tracers = false
}

-- Paleta de colores según los roles interceptados
local ColoresESP = {
    Murder = Color3.fromRGB(255, 35, 35),
    Sheriff = Color3.fromRGB(35, 120, 255),
    Innocent = Color3.fromRGB(35, 200, 95)
}

local function obtenerColorJugador(playerName)
    local rol = rolesPartida[playerName] or "Innocent"
    if rol == "Murderer" then return ColoresESP.Murder end
    if rol == "Sheriff" then return ColoresESP.Sheriff end
    return ColoresESP.Innocent
end

-- Interceptor del leak instantáneo
local playerDataRemote = ReplicatedStorage:FindFirstChild("PlayerDataChanged", true)
if playerDataRemote then
    playerDataRemote.OnClientEvent:Connect(function(roundData)
        if type(roundData) == "table" then
            rolesPartida = {} 
            for playerName, info in pairs(roundData) do
                if type(info) == "table" and info.Role then
                    rolesPartida[playerName] = info.Role
                end
            end
        end
    end)
end

-- Motor del Highlight (Siluetas) en segundo plano ligero
task.spawn(function()
    while true do
        task.wait(0.3)
        if not visualState.Highlights then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("KillerHub_Highlight") then
                    p.Character.KillerHub_Highlight:Destroy()
                end
            end
            continue
        end

        for _, p in pairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            local color = obtenerColorJugador(p.Name)
            local hl = p.Character:FindFirstChild("KillerHub_Highlight")
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "KillerHub_Highlight"
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0.2
                hl.Parent = p.Character
            end
            hl.FillColor = color
            hl.OutlineColor = color
        end
    end
end)

-- Motor 2D Ultra Optimizado (Cajas finas, nombres compactos y tracers delgados)
local function iniciarMotorESP2D()
    local folder = CoreGui:FindFirstChild("KillerHub_ESP_Folder")
    if folder then folder:Destroy() end
    
    folder = Instance.new("Folder", CoreGui)
    folder.Name = "KillerHub_ESP_Folder"

    local function crearObjetosESP(p)
        if p == LocalPlayer then return end
        
        local espGui = Instance.new("ScreenGui", folder)
        espGui.Name = "ESP_" .. p.Name
        
        -- Configuración de Tracers (Línea ultra delgada de 1 pixel)
        local line = Instance.new("Frame", espGui)
        line.Size = UDim2.new(0, 1, 0, 0)
        line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5, 0)
        line.Visible = false
        
        -- Configuración de Cajas (Borde limpio de 1 pixel)
        local box = Instance.new("Frame", espGui)
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 1
        box.AnchorPoint = Vector2.new(0.5, 0.5)
        box.Visible = false
        
        -- Configuración de Nombres (Compacto y legible)
        local nameLabel = Instance.new("TextLabel", espGui)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextStrokeTransparency = 0
        nameLabel.AnchorPoint = Vector2.new(0.5, 1)
        nameLabel.Visible = false

        local renderConnection
        renderConnection = RunService.RenderStepped:Connect(function()
            if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then
                line.Visible = false; box.Visible = false; nameLabel.Visible = false
                return
            end
            
            local color = obtenerColorJugador(p.Name)
            local hrp = p.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            -- Control de visibilidad según los estados booleanos de los botones
            line.Visible = onScreen and visualState.Tracers
            box.Visible = onScreen and visualState.Boxes
            nameLabel.Visible = onScreen and visualState.Names
            
            if not onScreen then return end
            
            -- Dibujar líneas delgadas desde el centro inferior
            if visualState.Tracers then
                line.BackgroundColor3 = color
                local startPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                local dist = (Vector2.new(pos.X, pos.Y) - startPos).Magnitude
                line.Size = UDim2.new(0, 1, 0, dist)
                line.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
                line.Rotation = math.atan2(pos.Y - startPos.Y, pos.X - startPos.X) * (180 / math.pi) - 90
            end
            
            -- Dibujar cajas y nombres proporcionales a la distancia
            if visualState.Boxes or visualState.Names then
                local sizeVec = Vector3.new(2, 3, 0)
                local sizePos = Camera:WorldToViewportPoint(hrp.Position + sizeVec)
                local w = math.abs(sizePos.X - pos.X) * 2
                local h = math.abs(sizePos.Y - pos.Y) * 2
                
                if visualState.Boxes then
                    box.Size = UDim2.new(0, w, 0, h)
                    box.Position = UDim2.new(0, pos.X, 0, pos.Y)
                    box.BorderColor3 = color
                end
                
                if visualState.Names then
                    nameLabel.Text = p.Name
                    nameLabel.TextColor3 = color
                    nameLabel.Position = UDim2.new(0, pos.X, 0, pos.Y - (h / 2) - 5)
                end
            end
        end)
        
        -- Limpieza automática si el jugador abandona
        p.AncestryChanged:Connect(function(_, parent)
            if not parent then
                renderConnection:Disconnect()
                espGui:Destroy()
            end
        end)
    end

    for _, p in pairs(Players:GetPlayers()) do crearObjetosESP(p) end
    Players.PlayerAdded:Connect(crearObjetosESP)
end

-- Inicializar el motor visual básico
iniciarMotorESP2D()

-- Creación de los Toggles dentro de tu VisualsFrame de manera ordenada e impecable
createToggle("EspHighlights", "Instant Highlight Roles", UDim2.new(0, 12, 0, 15), VisualsFrame, function(state)
    visualState.Highlights = state
end)

createToggle("EspBoxes", "ESP Box (Roles Colored)", UDim2.new(0, 12, 0, 65), VisualsFrame, function(state)
    visualState.Boxes = state
end)

createToggle("EspNames", "ESP Name (Roles Colored)", UDim2.new(0, 12, 0, 115), VisualsFrame, function(state)
    visualState.Names = state
end)

createToggle("EspTracers", "ESP Tracers (Thin Lines)", UDim2.new(0, 12, 0, 165), VisualsFrame, function(state)
    visualState.Tracers = state
end)
