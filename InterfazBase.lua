local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Evitar duplicados de la interfaz
if CoreGui:FindFirstChild("KillerHub_MM2") then
    CoreGui.KillerHub_MM2:Destroy()
end

-- Confirmación en consola al ejecutar
warn("✅ [KillerHub | Paolo] - Todo cargado: Roles Instantáneos por Variables, Highlights Opacos y Gun Drop 🇦🇱.")

-- ============================================================================
-- 💾 SISTEMA DE CONFIGURACIÓN Y AUTO-GUARDADO (Local File System)
-- ============================================================================
local FILE_NAME = "KillerHub_MM2_Config.json"
local Config = {
    Highlights = false,
    Boxes = false,
    Names = false,
    GunHighlight = false,
    GunEspName = false,
    NameSize = 0.3,
    MenuOpacity = 1,
    ButtonOpacity = 1
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

-- CONTENEDOR PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillerHub_MM2"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- PALETA DE COLORES DE LA INTERFAZ
local BG_MAIN = Color3.fromRGB(14, 14, 14)      
local BG_SIDEBAR = Color3.fromRGB(18, 18, 18)
local BG_SECONDARY = Color3.fromRGB(22, 22, 22) 
local ACCENT_GREEN = Color3.fromRGB(0, 230, 115) 
local TEXT_WHITE = Color3.fromRGB(240, 240, 240)
local TEXT_MUTED = Color3.fromRGB(130, 130, 130)

-- COLORES CHILLONES PARA JUGADORES (Máxima visibilidad)
local ColoresESP = {
    Murderer = Color3.fromRGB(255, 35, 35),   
    Sheriff = Color3.fromRGB(35, 115, 255),    
    Innocent = Color3.fromRGB(0, 230, 115)    
}

-- CACHÉ DE ROLES GLOBAL PERSISTENTE POR RONDA
local RolesCache = {}

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

-- Topbar
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

-- BARRA LATERAL
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 95, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = BG_SIDEBAR
Sidebar.BorderSizePixel = 0
Sidebar.Active = true
Sidebar.Parent = MainFrame

local SidebarTabsContainer = Instance.new("Frame")
SidebarTabsContainer.Size = UDim2.new(1, 0, 1, -95)
SidebarTabsContainer.BackgroundTransparency = 1
SidebarTabsContainer.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout") SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder SidebarLayout.Padding = UDim.new(0, 4) SidebarLayout.Parent = SidebarTabsContainer
local SidebarPadding = Instance.new("UIPadding") SidebarPadding.PaddingTop = UDim.new(0, 8) SidebarPadding.PaddingLeft = UDim.new(0, 6) SidebarPadding.PaddingRight = UDim.new(0, 6) SidebarPadding.Parent = SidebarTabsContainer

-- CONTENEDOR DE PÁGINAS
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -95, 1, -40)
ContentContainer.Position = UDim2.new(0, 95, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Active = true
ContentContainer.Parent = MainFrame

-- CREACIÓN DE PÁGINAS
local VisualsFrame = Instance.new("ScrollingFrame")
VisualsFrame.ScrollBarThickness = 3
VisualsFrame.ScrollBarImageColor3 = ACCENT_GREEN
VisualsFrame.CanvasSize = UDim2.new(0, 0, 0, 360)

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

local VisualsLayout = Instance.new("UIListLayout") VisualsLayout.SortOrder = Enum.SortOrder.LayoutOrder VisualsLayout.Padding = UDim.new(0, 6) VisualsLayout.Parent = VisualsFrame
local VisualsPadding = Instance.new("UIPadding") VisualsPadding.PaddingTop = UDim.new(0, 6) VisualsPadding.PaddingLeft = UDim.new(0, 8) VisualsPadding.PaddingRight = UDim.new(0, 8) VisualsPadding.Parent = VisualsFrame

-- NAVEGACIÓN
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
    tabButtons[text] = btn
    btn.MouseButton1Click:Connect(function() updateTabVisuals(text) end)
end

createTabBtn("Visuals", 1)
createTabBtn("Murder", 2)
createTabBtn("Sheriff", 3)

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Size = UDim2.new(1, -12, 0, 32)
SettingsBtn.Position = UDim2.new(0, 6, 1, -55)
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Text = "Settings"
SettingsBtn.TextColor3 = TEXT_MUTED
SettingsBtn.Font = Enum.Font.SourceSansBold
SettingsBtn.TextSize = 15
SettingsBtn.Active = true
SettingsBtn.Parent = Sidebar
tabButtons["Settings"] = SettingsBtn
SettingsBtn.MouseButton1Click:Connect(function() updateTabVisuals("Settings") end)

-- CONSTRUCTOR DE INTERFACES AUTOMÁTICO CON MEMORIA INTEGRADA
local function createToggle(configKey, text, order, parent, callback)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = configKey
    ToggleButton.Size = UDim2.new(1, 0, 0, 40)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    ToggleButton.Text = ""
    ToggleButton.LayoutOrder = order
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
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Font = Enum.Font.SourceSansBold
    ToggleLabel.TextSize = 14
    ToggleLabel.Parent = ToggleButton

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.Position = UDim2.new(1, -28, 0.5, -8)
    Indicator.Parent = ToggleButton
    local IndicatorCorner = Instance.new("UICorner") IndicatorCorner.CornerRadius = UDim.new(0, 3) IndicatorCorner.Parent = Indicator

    local state = Config[configKey] or false
    Indicator.BackgroundColor3 = state and ACCENT_GREEN or Color3.fromRGB(45, 45, 45)
    ToggleLabel.TextColor3 = state and TEXT_WHITE or TEXT_MUTED
    task.spawn(function() callback(state) end)

    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        Config[configKey] = state
        saveConfig()
        TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundColor3 = state and ACCENT_GREEN or Color3.fromRGB(45, 45, 45)}):Play()
        ToggleLabel.TextColor3 = state and TEXT_WHITE or TEXT_MUTED
        callback(state)
    end)
end

local function createSlider(configKey, text, position, parent, order, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -24, 0, 45)
    SliderFrame.Position = position
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.LayoutOrder = order or 0
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
    ValueLabel.TextColor3 = ACCENT_GREEN
    ValueLabel.Font = Enum.Font.Code
    ValueLabel.TextSize = 12
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame

    local Track = Instance.new("TextButton")
    Track.Size = UDim2.new(1, 0, 0, 4) Track.Position = UDim2.new(0, 0, 0, 26) Track.BackgroundColor3 = Color3.fromRGB(40, 40, 40) Track.Text = "" Track.AutoButtonColor = false Track.Active = true Track.Parent = SliderFrame
    local TrackCorner = Instance.new("UICorner") TrackCorner.CornerRadius = UDim.new(0, 2) TrackCorner.Parent = Track
    local Fill = Instance.new("Frame") Fill.BackgroundColor3 = ACCENT_GREEN Fill.BorderSizePixel = 0 Fill.Parent = Track
    local Knob = Instance.new("Frame") Knob.Size = UDim2.new(0, 10, 0, 10) Knob.BackgroundColor3 = TEXT_WHITE Knob.Active = true Knob.Parent = Track local KnobCorner = Instance.new("UICorner") KnobCorner.CornerRadius = UDim.new(1, 0) KnobCorner.Parent = Knob

    local percentage = Config[configKey] or 1
    Fill.Size = UDim2.new(percentage, 0, 1, 0) Knob.Position = UDim2.new(percentage, -5, 0.5, -5) ValueLabel.Text = math.floor(percentage * 100) .. "%"
    task.spawn(function() callback(percentage) end)

    local function updateSlider(input)
        percentage = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        Config[configKey] = percentage saveConfig()
        Fill.Size = UDim2.new(percentage, 0, 1, 0) Knob.Position = UDim2.new(percentage, -5, 0.5, -5) ValueLabel.Text = math.floor(percentage * 100) .. "%" callback(percentage)
    end

    local sliding = false
    Track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true updateSlider(input) end end)
    UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end end)
end

-- CONFIGURACIONES DE MENÚ EXTERNAS
createSlider("MenuOpacity", "Menu Transparency", UDim2.new(0, 12, 0, 15), SettingsFrame, 1, function(val)
    local alpha = 1 - val
    MainFrame.BackgroundTransparency = alpha Topbar.BackgroundTransparency = alpha Sidebar.BackgroundTransparency = alpha VisualsFrame.BackgroundTransparency = alpha MurderFrame.BackgroundTransparency = alpha SheriffFrame.BackgroundTransparency = alpha SettingsFrame.BackgroundTransparency = alpha
end)

local OpenCloseBtn = Instance.new("TextButton")
OpenCloseBtn.Name = "KillerHubToggle" OpenCloseBtn.Size = UDim2.new(0, 45, 0, 45) OpenCloseBtn.Position = UDim2.new(0, 20, 0, 20) OpenCloseBtn.BackgroundColor3 = BG_MAIN OpenCloseBtn.Text = "H" OpenCloseBtn.TextColor3 = ACCENT_GREEN OpenCloseBtn.Font = Enum.Font.SourceSansBold OpenCloseBtn.TextSize = 20 OpenCloseBtn.Active = true OpenCloseBtn.Parent = ScreenGui
local BtnCorner = Instance.new("UICorner") BtnCorner.CornerRadius = UDim.new(0, 8) BtnCorner.Parent = OpenCloseBtn
local BtnStroke = Instance.new("UIStroke") BtnStroke.Thickness = 1 BtnStroke.Color = Color3.fromRGB(40, 40, 40) BtnStroke.Parent = OpenCloseBtn

createSlider("ButtonOpacity", "Button Transparency", UDim2.new(0, 12, 0, 75), SettingsFrame, 2, function(val)
    local alpha = 1 - val OpenCloseBtn.BackgroundTransparency = alpha OpenCloseBtn.TextTransparency = alpha BtnStroke.Transparency = alpha
end)

local menuVisible = true
OpenCloseBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible MainFrame.Visible = menuVisible OpenCloseBtn.Text = menuVisible and "H" or "K" OpenCloseBtn.TextColor3 = menuVisible and ACCENT_GREEN or TEXT_WHITE
end)

-- SISTEMA MULTITOUCH ARRASTRE
local dragStart = nil local startPos = nil local draggingInput = nil
OpenCloseBtn.InputBegan:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then draggingInput = input dragStart = input.Position startPos = OpenCloseBtn.Position end end)
UserInputService.InputChanged:Connect(function(input) if input == draggingInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart OpenCloseBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
OpenCloseBtn.InputEnded:Connect(function(input) if input == draggingInput then draggingInput = nil end end)

-- ============================================================================
-- 📡 ENGINE ESP COMPLETO E INSTANTÁNEO (Basado Estrictamente en los Logs)
-- ============================================================================
local function conseguirRolPersistente(p)
    if not p then return "Innocent" end
    
    -- Si ya fue detectado en esta ronda, dejamos el rol congelado para evitar parpadeos
    if RolesCache[p.Name] then
        return RolesCache[p.Name]
    end

    -- MÉTODO DIRECTO DESDE LOS LOGS: Escanear el estado de juego real en ReplicatedStorage
    local gameGet = ReplicatedStorage:FindFirstChild("GetPlayerData", true) or ReplicatedStorage:FindFirstChild("RoleData", true)
    if gameGet then
        local success, res = pcall(function()
            if gameGet:IsA("RemoteFunction") then
                return gameGet:InvokeServer()
            end
        end)
        
        if success and type(res) == "table" and res[p.Name] then
            local roleStr = tostring(res[p.Name].Role or res[p.Name])
            if roleStr:find("Murder") or roleStr == "Murderer" then
                RolesCache[p.Name] = "Murderer"
                return "Murderer"
            elseif roleStr:find("Sheriff") or roleStr == "Sheriff" or roleStr == "Hero" then
                RolesCache[p.Name] = "Sheriff"
                return "Sheriff"
            end
        end
    end

    -- RESPALDO SECUNDARIO AGRESIVO: Si los módulos de red no responden rápido, escaneo inmediato de inventarios lógicos
    local playerData = p:FindFirstChild("PlayerData") or p:FindFirstChild("TempState")
    if playerData then
        local roleValue = playerData:FindFirstChild("Role") or playerData:FindFirstChild("IsMurderer")
        if roleValue then
            if roleValue.Value == true or tostring(roleValue.Value):find("Murder") then
                RolesCache[p.Name] = "Murderer"
                return "Murderer"
            elseif tostring(roleValue.Value):find("Sheriff") then
                RolesCache[p.Name] = "Sheriff"
                return "Sheriff"
            end
        end
    end

    -- RESPALDO FÍSICO TRADICIONAL
    local bpack = p:FindFirstChild("Backpack")
    local char = p.Character
    if (bpack and bpack:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife")) then
        RolesCache[p.Name] = "Murderer"
        return "Murderer"
    elseif (bpack and bpack:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun")) then
        RolesCache[p.Name] = "Sheriff"
        return "Sheriff"
    end
    
    return "Innocent"
end

-- Limpieza inteligente automática al regresar al Lobby (Intermisión)
local function verificarReinicioDeRonda()
    local alguienTieneArmas = false
    for _, plr in pairs(Players:GetPlayers()) do
        local bpack = plr:FindFirstChild("Backpack")
        local char = plr.Character
        if char then
            if (bpack and (bpack:FindFirstChild("Knife") or bpack:FindFirstChild("Gun"))) or 
               (char and (char:FindFirstChild("Knife") or char:FindFirstChild("Gun"))) then
                alguienTieneArmas = true
                break
            end
        end
    end
    if not alguienTieneArmas then
        table.clear(RolesCache)
    end
end

RunService.RenderStepped:Connect(function()
    verificarReinicioDeRonda()
    
    -- 1. PROCESAMIENTO ESP JUGADORES (Con los centros súper opacos solicitados)
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local char = p.Character
        
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local hrp = char.HumanoidRootPart
            local role = conseguirRolPersistente(p)
            local color = ColoresESP[role]
            
            -- Highlights Perfeccionados: Centros muy opacos y casi del mismo tono que los bordes
            local hl = char:FindFirstChild("KH_Highlight")
            if Config.Highlights then
                if not hl then hl = Instance.new("Highlight") hl.Name = "KH_Highlight" hl.Parent = char end
                hl.FillColor = color 
                hl.OutlineColor = Color3.fromRGB(255, 255, 255) 
                hl.FillTransparency = 0.25 -- Muy opaco, se fusiona perfectamente con el color de los bordes
                hl.OutlineTransparency = 0
            else
                if hl then hl:Destroy() end
            end
            
            -- Boxes (Thickness = 1)
            local box = char:FindFirstChild("KH_BoxGui")
            if Config.Boxes then
                if not box then
                    box = Instance.new("BillboardGui") box.Name = "KH_BoxGui" box.AlwaysOnTop = true box.Size = UDim2.new(4.5, 0, 6, 0) box.Parent = char
                    local f = Instance.new("Frame") f.Size = UDim2.new(1, 0, 1, 0) f.BackgroundTransparency = 1 f.Parent = box
                    local stroke = Instance.new("UIStroke") stroke.Thickness = 1 stroke.Parent = f
                end
                box.Adornee = hrp box.Frame.UIStroke.Color = color
            else
                if box then box:Destroy() end
            end
            
            -- Names
            local nameEs = char:FindFirstChild("KH_NameGui")
            if Config.Names then
                if not nameEs then
                    nameEs = Instance.new("BillboardGui") nameEs.Name = "KH_NameGui" nameEs.AlwaysOnTop = true nameEs.Size = UDim2.new(0, 120, 0, 25) nameEs.StudsOffset = Vector3.new(0, 3.5, 0) nameEs.Parent = char
                    local tl = Instance.new("TextLabel") tl.Size = UDim2.new(1, 0, 1, 0) tl.BackgroundTransparency = 1 tl.Font = Enum.Font.SourceSansBold tl.TextStrokeTransparency = 0 tl.TextStrokeColor3 = Color3.fromRGB(0,0,0) tl.Parent = nameEs
                end
                local calculatedSize = math.floor(10 + ((Config.NameSize or 0.3) * 14))
                nameEs.Adornee = hrp 
                nameEs.TextLabel.Text = p.Name .. " [" .. role .. "]" 
                nameEs.TextLabel.TextColor3 = color
                nameEs.TextLabel.TextSize = calculatedSize
            else
                if nameEs then nameEs:Destroy() end
            end
        else
            if char then
                if char:FindFirstChild("KH_Highlight") then char.KH_Highlight:Destroy() end
                if char:FindFirstChild("KH_BoxGui") then char.KH_BoxGui:Destroy() end
                if char:FindFirstChild("KH_NameGui") then char.KH_NameGui:Destroy() end
            end
        end
    end

    -- 2. ESP PARA LA PISTOLA EN EL SUELO (GUN DROP)
    local pistolaModel = Workspace:FindFirstChild("GunDrop", true)
    if pistolaModel and Config.GunHighlight then
        local gunPosition = nil
        if pistolaModel:IsA("BasePart") then
            gunPosition = pistolaModel.Position
        elseif pistolaModel:IsA("Model") then
            local realPart = pistolaModel:FindFirstChild("Handle") or pistolaModel:FindFirstChildWhichIsA("BasePart")
            if realPart then gunPosition = realPart.Position else gunPosition = pistolaModel:GetPivot().Position end
        end

        if gunPosition then
            -- Highlight de la pistola tirada
            local gunHl = pistolaModel:FindFirstChild("KH_GunHighlight")
            if Config.GunHighlight then
                if not gunHl then gunHl = Instance.new("Highlight") gunHl.Name = "KH_GunHighlight" gunHl.Parent = pistolaModel end
                gunHl.FillColor = Color3.fromRGB(200, 0, 0) 
                gunHl.OutlineColor = Color3.fromRGB(255, 255, 255) gunHl.FillTransparency = 0.2 gunHl.OutlineTransparency = 0
            else
                if gunHl then gunHl:Destroy() end
            end

            -- Nombre exacto solicitado: GUN DROP 🇦🇱
            if Config.GunEspName then
                local gunNameEs = pistolaModel:FindFirstChild("KH_GunNameGui")
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
                if pistolaModel:FindFirstChild("KH_GunNameGui") then pistolaModel.KH_GunNameGui:Destroy() end
            end
        end
    end
end)

-- ============================================================================
-- 💉 INYECCIÓN DE LOS ENLACES DE LA INTERFAZ (UI)
-- ============================================================================
createToggle("Highlights", "Instant Highlight Roles (Dark)", 1, VisualsFrame, function(s) end)
createToggle("Boxes", "ESP Box (Thin Outline)", 2, VisualsFrame, function(s) end)
createToggle("Names", "ESP Name (Custom Size)", 3, VisualsFrame, function(s) end)
createToggle("GunHighlight", "Gun Drop Highlight (Blood Red)", 4, VisualsFrame, function(s) end)
createToggle("GunEspName", "Gun Drop ESP Name 🇦🇱", 5, VisualsFrame, function(s) end)
createSlider("NameSize", "ESP Name Text Size", UDim2.new(0, 0, 0, 0), VisualsFrame, 6, function(val) end)
