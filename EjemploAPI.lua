-- ============================================================================
-- 👻 KILLER HUB | EJEMPLO DE INTEGRACIÓN COMPLETA DESDE GITHUB
-- ============================================================================
-- Este script jala tu librería directamente desde tu repositorio de GitHub 
-- y muestra cómo crear y usar cada componente disponible.

-- 1. CARGAR TU LIBRERÍA EXTERNA (Gracias al 'return KillerHub' al final de tu API)
local KillerHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Paolo0109/KillerHUB/refs/heads/main/InterfazBase.lua"))()

-- 2. CREAR PESTAÑAS (Tabs)
-- Argumentos: ("Nombre de Pestaña", "ID del Icono de Roblox [Opcional]")
local CombatTab = KillerHub:CreateTab("Combate", "rbxassetid://10747373142")
local VisualsTab = KillerHub:CreateTab("Visuales", "rbxassetid://10747372517")
local MiscTab = KillerHub:CreateTab("Misceláneos", "rbxassetid://10747373142")


-- ============================================================================
-- ⚔️ PESTAÑA 1: COMBATE (Secciones, Toggles, Sliders, Dropdowns y Multi-Dropdowns)
-- ============================================================================
CombatTab:CreateSection("Automatizaciones de Combate")

-- [COMPONENTE: TOGGLE] -> Interruptor On/Off con autoguardado por bandera (flag)
-- Argumentos: ("NombreFlag", "Texto Visual", callback)
local KAAuraToggle = CombatTab:CreateToggle("KillAuraActive", "Activar Kill Aura Universal", function(estado)
    print("⚔️ Kill Aura cambiado a:", estado)
end)

-- Pista: Puedes cambiar el estado de un Toggle desde tu código con: 
-- KAAuraToggle:Set(true)

-- [COMPONENTE: SLIDER] -> Barra deslizadora numérica
-- Argumentos: ("NombreFlag", "Texto Visual", ValorMínimo, ValorMáximo, callback)
local RangeSlider = CombatTab:CreateSlider("AuraRange", "Rango de Ataque (Distancia)", 5, 100, function(valor)
    print("📏 Rango de golpe ajustado a:", math.floor(valor))
end)

-- Pista: Puedes forzar un valor en el Slider desde tu código con: 
-- RangeSlider:Set(50)

CombatTab:CreateSection("Filtros y Objetivos")

-- [COMPONENTE: DROPDOWN] -> Selección única corregido (No se esconde con el UIListLayout)
-- Argumentos: ("NombreFlag", "Texto Visual", {"Opciones"}, callback)
local TargetDropdown = CombatTab:CreateDropdown("AuraTarget", "Prioridad de Objetivo:", {"Más Cercano", "Menos Vida", "Solo Enemigos", "Todos"}, function(seleccionado)
    print("🎯 Prioridad fijada en:", seleccionado)
end)

-- Pista: Si quieres refrescar las opciones (ej. lista de jugadores del server):
-- TargetDropdown:Refresh({"Jugador1", "Jugador2", "Todos"})

-- [COMPONENTE: MULTI-DROPDOWN] -> Selección múltiple que permite activar varias opciones a la vez
-- Argumentos: ("NombreFlag", "Texto Visual", {"Opciones"}, callback)
CombatTab:CreateMultiDropdown("IgnoredTeams", "Ignorar Equipos (Múltiple):", {"Amigos", "Staff/Admins", "Neutrales"}, function(tablaFlags)
    print("--- 📑 Filtros Múltiples Actualizados ---")
    if tablaFlags["Amigos"] then print("-> Ignorando Amigos: SÍ") else print("-> Ignorando Amigos: NO") end
end)


-- ============================================================================
-- 👁️ PESTAÑA 2: VISUALES (Párrafos Informativos y Toggle Color Picker Avanzado)
-- ============================================================================
VisualsTab:CreateSection("Mensajes de Sistema")

-- [COMPONENTE: PARAGRAPH] -> Bloque de texto descriptivo o avisos dinámicos
-- Argumentos: ("Título", "Contenido del texto")
local InfoParagraph = VisualsTab:CreateParagraph("Rendimiento", "El renderizado de cuadros consume recursos del procesador. Desactívalo si notas tirones.")

-- Pista: Puedes modificar un párrafo en tiempo real con sus métodos:
-- InfoParagraph:SetTitle("Nuevo Título")
-- InfoParagraph:SetText("Nuevo contenido de texto.")

VisualsTab:CreateSection("Colores de Interfaz")

-- [COMPONENTE: TOGGLE COLOR PICKER] -> Toggle + Selector RGB Avanzado en una sola línea
-- Argumentos: ("FlagToggle", "FlagColor", "Texto Visual", Color3Predeterminado, CallbackToggle, CallbackColor)
VisualsTab:CreateToggleColorPicker(
    "EspJugadores", 
    "ColorDeLosVisuales", 
    "Visualizar Cuadros (ESP Boxes)", 
    Color3.fromRGB(255, 35, 35), -- Rojo por defecto
    function(estadoToggle)
        print("👁️ Estado del ESP:", estadoToggle)
    end,
    function(colorSeleccionado)
        -- Devuelve un objeto Color3 nativo de Roblox listo para usar en ESPs o UI
        print("🎨 Nuevo color RGB:", colorSeleccionado)
    end
)


-- ============================================================================
-- ⚙️ PESTAÑA 3: MISCELÁNEOS (Inputs, Botones y Keybinds Rápidos)
-- ============================================================================
MiscTab:CreateSection("Enlaces Externos")

-- [COMPONENTE: INPUT / TEXTBOX] -> Caja de texto libre para guardar configuraciones
-- Argumentos: ("NombreFlag", "Texto Visual", "Marcador de Posición", callback)
MiscTab:CreateInput("WebhookDiscord", "Discord Webhook Logger", "Pega el link aquí...", function(textoIngresado)
    print("📩 URL de Webhook guardada:", textoIngresado)
end)

MiscTab:CreateSection("Acciones Directas")

-- [COMPONENTE: BUTTON] -> Botón clásico ejecutor de funciones
-- Argumentos: ("Texto del Botón", callback)
MiscTab:CreateButton("Re-Sincronizar Servidor", function()
    print("⚡ Sincronizando datos con el servidor de juego...")
end)

-- [COMPONENTE: KEYBIND] -> Asignador de teclado interactivo para ejecutar atajos
-- Argumentos: ("NombreFlag", "Texto Visual", Enum.KeyCode.TeclaPredeterminada, callback)
MiscTab:CreateKeybind("TeleportKey", "Atajo de Teletransporte", Enum.KeyCode.E, function(teclaAsignada)
    print("⚡ ¡Presionaste la tecla de acción rápida!: " .. teclaAsignada.Name)
end)


-- ============================================================================
-- 💡 TIP PRO DE ACCESO GLOBAL:
-- ============================================================================
-- Si necesitas leer el valor actual de un flag dentro de un bucle infinito
-- o un evento del juego sin usar los callbacks, puedes consultar la tabla global:
--
-- local kaActivado = getgenv().KillerHub.Flags["KillAuraActive"].CurrentValue
-- local colorActual = getgenv().KillerHub.Flags["ColorDeLosVisuales"].CurrentValue

Para hacer una cadena de links infinita de Github recuerda poner hasta abajo del código siempre; return KillerHub

