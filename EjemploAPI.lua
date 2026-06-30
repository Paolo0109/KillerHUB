-- ============================================================================
-- 👻 KILLER HUB | DOCUMENTACIÓN Y API DE INTEGRACIÓN AVANZADA
-- ============================================================================
-- Diseñado para desarrolladores. Carga dinámica de dependencias y control de estados.

-- 1. CARGA DE LA LIBRERÍA CORE
local KillerHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Paolo0109/KillerHUB/refs/heads/main/InterfazBase.lua"))()

-- 2. INICIALIZACIÓN DE PESTAÑAS (Tabs)
-- Argumentos: Base:CreateTab("Texto Visual", "ID_Icono_Roblox")
local CombatTab  = KillerHub:CreateTab("Combate", "rbxassetid://10747373142")
local VisualsTab = KillerHub:CreateTab("Visuales", "rbxassetid://10747372517")
local MiscTab    = KillerHub:CreateTab("Misceláneos", "rbxassetid://10747373142")

-- ============================================================================
-- ⚔️ VARIACIONES DE COMPONENTES: PESTAÑA COMBATE
-- ============================================================================
CombatTab:CreateSection("Ajustes del Motor de Predicción")

-- [COMPONENTE: TOGGLE ESTÁNDAR]
-- Guarda de forma nativa un valor booleano (true/false) en la tabla interna de flags.
local AimbotToggle = CombatTab:CreateToggle("AimbotActive", "Activar Aim Prediction", function(estado)
    print("[API] Estado del Aimbot:", estado)
end)

-- 🛠️ MÉTODOS DE TOGGLE:
-- Forzar estado de forma externa: AimbotToggle:Set(true)


-- [COMPONENTE: SLIDERS - VARIACIONES DE INCREMENTO Y PRECISIÓN]
-- Estructura de argumentos: CreateSlider("Flag", "Texto", Min, Max, Default, Step, Callback)

-- Variación A: Precisión Decimal Exrema (0.0 a 1.0 aumentando de 0.1 en 0.1)
-- Ideal para offsets de frames, alphas o suavizados delicados.
local DecimalSlider = CombatTab:CreateSlider("SmoothOffset", "Suavizado de Cámara (Float)", 0.0, 1.0, 0.2, 0.1, function(valor)
    print("[API] Desplazamiento decimal ajustado a:", string.format("%.1f", valor))
end)

-- Variación B: Incrementos Medios (0 a 100 aumentando de 5 en 5)
-- Ideal para rangos de ataque cortos o velocidad de caminata simulada.
local WalkSpeedSlider = CombatTab:CreateSlider("CustomSpeed", "Velocidad de Simulación (Step 5)", 10, 150, 16, 5, function(valor)
    print("[API] Velocidad modificada a enteros de 5 en 5:", valor)
end)

-- Variación C: Incrementos a Gran Escala (0 a 1000 aumentando de 50 en 50)
-- Ideal para rangos máximos de renderizado (ESP Distance) o delays en milisegundos.
local MaxDistanceSlider = CombatTab:CreateSlider("RenderDistance", "Distancia Máxima ESP (Step 50)", 0, 1000, 500, 50, function(valor)
    print("[API] Rango macro ajustado a:", valor)
end)

-- 🛠️ MÉTODOS DE SLIDER:
-- Forzar un valor intermedio: WalkSpeedSlider:Set(55)


CombatTab:CreateSection("Sistemas de Filtrado")

-- [COMPONENTE: DROPDOWN DE SELECCIÓN ÚNICA]
local TargetDropdown = CombatTab:CreateDropdown("TargetMode", "Fijar Objetivo en:", {"Asesino", "Sheriff", "Inocentes", "Todos"}, function(seleccionado)
    print("[API] Nuevo objetivo prioritario:", seleccionado)
end)

-- 🛠️ MÉTODOS DE DROPDOWN:
-- Re-inyectar opciones dinámicamente (Útil si un jugador entra o sale del servidor):
-- TargetDropdown:Refresh({"Jugador_1", "Jugador_2", "Servidor_Completo"})


-- [COMPONENTE: MULTI-DROPDOWN (SELECCIÓN MÚLTIPLE)]
-- Retorna una estructura de tabla indexada por las opciones con estados booleanos.
CombatTab:CreateMultiDropdown("TargetFilters", "Filtros de Omisión Múltiple", {"Amigos", "Admins", "Cercanos"}, function(tablaFlags)
    print("[API] Modificación de Filtros Múltiples:")
    for opcion, activo in pairs(tablaFlags) do
        print(string.format("   - Opción [%s] -> Estado: %s", opcion, tostring(activo)))
    end
end)


-- ============================================================================
-- 👁️ COMPONENTES COMPUESTOS Y TEXTO: PESTAÑA VISUALES
-- ============================================================================
VisualsTab:CreateSection("Monitor de Rendimiento")

-- [COMPONENTE: PARAGRAPH (BLOQUE INFORMATIVO COGNITIVO)]
local StatusParagraph = VisualsTab:CreateParagraph("Estado del Servidor", "Cargando telemetría de la partida actual...")

-- 🛠️ MÉTODOS DE PARAGRAPH (Actualización en tiempo real desde bucles):
-- StatusParagraph:SetTitle("⚠️ ALERTA DE RIESGO")
-- StatusParagraph:SetText("El Asesino ha desenvainado el arma principal.")


VisualsTab:CreateSection("Renderizado Avanzado (ESP)")

-- [COMPONENTE: TOGGLE COLOR PICKER INTEGRADO]
-- Fusiona el interruptor de encendido con una paleta RGB en una sola línea de interfaz.
VisualsTab:CreateToggleColorPicker(
    "ESPBoxes",               -- Flag del interruptor (booleano)
    "ESPBoxesColor",          -- Flag del color (Color3)
    "Espesores de Cuadros (ESP)", 
    Color3.fromRGB(0, 255, 123), -- Color verde neón inicial
    function(estadoToggle)
        print("[API] Renderizado de cajas activado:", estadoToggle)
    end,
    function(colorSeleccionado)
        -- Retorna un objeto Color3 puro de Roblox API
        print("[API] Actualización cromática RGB:", colorSeleccionado.R, colorSeleccionado.G, colorSeleccionado.B)
    end
)


-- ============================================================================
-- ⚙️ CONFIGURACIÓN Y ENTRADAS DIRECTAS: PESTAÑA MISCELÁNEOS
-- ============================================================================
MiscTab:CreateSection("Automatización de Salida")

-- [COMPONENTE: INPUT / TEXTBOX (ENTRADA DE CADENAS DE TEXTO)]
MiscTab:CreateInput("CustomWebhook", "Discord Webhook URL", "https://discord.com/api/webhooks/...", function(textoIngresado)
    print("[API] Nueva dirección de Webhook registrada de manera segura:", textoIngresado)
end)


MiscTab:CreateSection("Atajos de Ejecución Directa")

-- [COMPONENTE: KEYBIND INTERACTIVO]
-- Detecta interacciones físicas del teclado y permite la re-asignación en vivo.
MiscTab:CreateKeybind("PanicKey", "Tecla de Apagado Rápido (Panic Mode)", Enum.KeyCode.RightControl, function(teclaAsignada)
    print("[API] Se ha pulsado el atajo de teclado configurado en: " .. teclaAsignada.Name)
end)


-- [COMPONENTE: BUTTON (GATILLO DE ACCIONES)]
MiscTab:CreateButton("Destruir Interfaz (Unload)", function()
    print("[API] Removiendo elementos del CoreGui de forma limpia...")
    -- Aquí colocarías tu lógica de KillerHub:Unload() si existiera.
end)


-- ============================================================================
-- 📑 ACCESO A MATRICES GLOBALES DE DATOS (MÉTODOS GETTER)
-- ============================================================================
-- Si necesitas consultar el estado exacto de una configuración desde hilos ajenos 
-- a la UI (como un bucle `task.spawn` corriendo el Aimbot), accede a la tabla global de Flags:
--
-- local estadoAimbot = getgenv().KillerHub.Flags["AimbotActive"].CurrentValue
-- local colorActual  = getgenv().KillerHub.Flags["ESPBoxesColor"].CurrentValue
-- local delaySlider  = getgenv().KillerHub.Flags["RenderDistance"].CurrentValue


-- ============================================================================
-- 🔗 RETORNO CRUCIAL PARA ENCADENAMIENTO DE REPOSITORIOS (GITHUB COMPATIBILITY)
-- ============================================================================
-- Este retorno permite que al realizar un loadstring() externo del archivo, la variable
-- contenedora absorba todas las propiedades del objeto creado, facilitando la creación de links.
return KillerHub
