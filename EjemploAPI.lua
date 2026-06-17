-- ============================================================================
-- 🚀 SCRIPT PRINCIPAL (EJEMPLO DE INTEGRACIÓN COMPLETA DESDE GITHUB)
-- ============================================================================
-- Este script simula cómo un usuario llamaría a tu API guardada en GitHub
-- y activaría absolutamente todas las funciones de KillerHub.

-- 1. Cargar la librería de forma externa (Haciendo uso del 'return KillerHub')
local KillerHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/TuUsuario/TuRepositorio/main/KillerHubLibrary.lua"))()

-- 2. Crear las pestañas principales (Tabs)
-- Argumentos: ("Nombre de Pestaña", "ID del Icono de Roblox")
local CombatTab = KillerHub:CreateTab("Combate", "rbxassetid://10747373142")
local VisualsTab = KillerHub:CreateTab("Visuales", "rbxassetid://10747372517")
local MiscTab = KillerHub:CreateTab("Misceláneos", "rbxassetid://10747373142")

-- ============================================================================
-- ⚔️ PESTAÑA: COMBATE (Ejemplos de Toggles, Sliders, Dropdowns y Multi-Dropdowns)
-- ============================================================================

CombatTab:CreateSection("Automatizaciones Principales")

-- [COMPONENTE 1: TOGGLE] -> Interruptor On/Off con autoguardado por bandera (flag)
-- Argumentos: ("NombreFlag", "Texto Visual", callback)
local KAAuraToggle = CombatTab:CreateToggle("KillAuraActive", "Activar Kill Aura Universal", function(estado)
    print("⚔️ Kill Aura cambiado a:", estado)
end)

-- Nota: Puedes forzar o cambiar el estado de un Toggle desde el código usando:
-- KAAuraToggle:Set(true) 

-- [COMPONENTE 2: SLIDER] -> Barra deslizadora numérica
-- Argumentos: ("NombreFlag", "Texto Visual", ValorMínimo, ValorMáximo, callback)
local RangeSlider = CombatTab:CreateSlider("AuraRange", "Rango de Ataque (Distancia)", 5, 100, function(valor)
    print("📏 Rango de golpe ajustado a:", math.floor(valor))
end)

-- Nota: Puedes forzar un valor en el Slider desde código usando:
-- RangeSlider:Set(50)

CombatTab:CreateSection("Selectores de Objetivo")

-- [COMPONENTE 3: DROPDOWN] -> Menú desplegable de selección única (Corregido sin bugs de UIListLayout)
-- Argumentos: ("NombreFlag", "Texto Visual", {"Opciones"}, callback)
local TargetDropdown = CombatTab:CreateDropdown("AuraTarget", "Prioridad de Objetivo:", {"Más Cercano", "Menos Vida", "Solo Enemigos", "Todos"}, function(seleccionado)
    print("🎯 Prioridad fijada en:", seleccionado)
end)

-- Nota: Si necesitas actualizar las opciones de un Dropdown en tiempo real (por ejemplo, una lista de jugadores):
-- TargetDropdown:Refresh({"NuevoJugador1", "NuevoJugador2", "Todos"})

-- [COMPONENTE 4: MULTI-DROPDOWN] -> Selección múltiple simultánea sin cerrarse
-- Argumentos: ("NombreFlag", "Texto Visual", {"Opciones"}, callback)
CombatTab:CreateMultiDropdown("IgnoredTeams", "Ignorar Equipos (Múltiple):", {"Amigos", "Staff/Admins", "Neutrales", "Criminales"}, function(tablaFlags)
    print("--- 📑 Estado Actual de Filtros Múltiples ---")
    if tablaFlags["Amigos"] then print("-> Omitiendo Amigos: [SÍ]") else print("-> Omitiendo Amigos: [NO]") end
    if tablaFlags["Staff/Admins"] then print("-> Omitiendo Staff: [SÍ]") end
end)


-- ============================================================================
-- 👁️ PESTAÑA: VISUALES (Ejemplo de Párrafos y Selector de Color Avanzado con Toggle)
-- ============================================================================

VisualsTab:CreateSection("Mensajes del Servidor")

-- [COMPONENTE 5: PARAGRAPH] -> Bloque de texto informativo dinámico
-- Argumentos: ("Título", "Contenido del texto")
local InfoParagraph = VisualsTab:CreateParagraph("Estado del Renderizado", "Los efectos visuales y de ESP consumen recursos. Si experimentas bajones de FPS, reduce el rango de renderizado en la pestaña de configuraciones.")

-- Nota: Puedes modificar dinámicamente un párrafo usando sus métodos dedicados:
-- InfoParagraph:SetTitle("Nuevo Título de Alerta")
-- InfoParagraph:SetText("El texto ha cambiado dinámicamente.")

VisualsTab:CreateSection("Renderizado de Entidades")

-- [COMPONENTE 6: TOGGLE COLOR PICKER] -> Toggle + Selector RGB Integrado en un solo bloque
-- Argumentos: ("FlagToggle", "FlagColor", "Texto Visual", Color3Predeterminado, CallbackToggle, CallbackColor)
VisualsTab:CreateToggleColorPicker(
    "EspJugadores", 
    "ColorDeLosVisuales", 
    "Visualizar Cuadros (ESP Boxes)", 
    Color3.fromRGB(255, 35, 35), -- Color por defecto (Rojo Crimson)
    function(estadoToggle)
        print("👁️ ESP Boxes activadas/desactivadas:", estadoToggle)
    end,
    function(colorSeleccionado)
        -- Retorna un objeto Color3 nativo de Roblox directamente utilizable
        print("🎨 Nuevo color RGB seleccionado: ", colorSeleccionado)
    end
)


-- ============================================================================
-- ⚙️ PESTAÑA: MISCELÁNEOS (Ejemplos de Text Inputs, Buttons y Keybinds rápidos)
-- ============================================================================

MiscTab:CreateSection("Configuración Externa")

-- [COMPONENTE 7: INPUT / TEXTBOX] -> Caja para escribir cadenas de texto o números manuales
-- Argumentos: ("NombreFlag", "Texto Visual", "Texto de Marcador de Posición (Placeholder)", callback)
MiscTab:CreateInput("WebhookDiscord", "Discord Webhook Logger", "Pega la URL de tu canal aquí...", function(textoIngresado)
    print("📩 URL de Webhook guardada:", textoIngresado)
end)

MiscTab:CreateSection("Acciones Directas")

-- [COMPONENTE 8: BUTTON] -> Botón de ejecución instantánea
-- Argumentos: ("Texto del Botón", callback)
MiscTab:CreateButton("Forzar Re-Sincronización de Datos", function()
    print("⚡ Botón presionado: Re-sincronizando inventario con el servidor...")
end)

-- [COMPONENTE 9: KEYBIND] -> Asignador de teclas rápidas para ejecutar funciones internas
-- Argumentos: ("NombreFlag", "Texto Visual", Enum.KeyCode.TeclaPredeterminada, callback)
MiscTab:CreateKeybind("TeleportKey", "Tecla de Teletransporte Rápido", Enum.KeyCode.E, function(teclaAsignada)
    -- Retorna el objeto KeyCode presionado
    print("⚡ ¡Función ejecutada al presionar la tecla asignada!: " .. teclaAsignada.Name)
end)


-- ============================================================================
-- 💡 TIPS ÚTILES DE ACCESO GLOBAL DESDE TU SCRIPT:
-- ============================================================================
-- Como tu framework expone la tabla KillerHub a nivel global ('getgenv().KillerHub'),
-- si en algún bucle (por ejemplo, un 'task.spawn' o un 'Stepped') necesitas leer
-- los valores de las banderas en tiempo real sin esperar los callbacks, haz esto:
--
-- local isActive = getgenv().KillerHub.Flags["KillAuraActive"].CurrentValue
-- local currentRange = getgenv().KillerHub.Flags["AuraRange"].CurrentValue
-- local colorRGB = getgenv().KillerHub.Flags["ColorDeLosVisuales"].CurrentValue
