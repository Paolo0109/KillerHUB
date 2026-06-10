-- ============================================================================
-- 👻 GUÍA DE LA API DE KILLER HUB (FORMATO CÓDIGO .LUA)
-- ============================================================================
-- Este archivo sirve para que sepas cómo agregar funciones, casillas y textos.
-- Las explicaciones están en comentarios cortos para que no se desordene.

-- 🚀 SECCIÓN 1: CARGAR LA LIBRERÍA BASE
-- Abre la interfaz y activa el sistema. Devuelve el objeto ejecutor.
local KillerHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Paolo0109/KillerHUB/refs/heads/main/InterfazBase.lua"))()


-- 🗂️ SECCIÓN 2: TRAER LAS PESTANAS NATIVAS
-- El Hub ya tiene 4 pestañas limpias creadas. Solo guárdalas en variables:
local Visuals = KillerHub.Tabs.Visuals   -- Pestaña para ESP y rastreos 3D
local Murder  = KillerHub.Tabs.Murder    -- Pestaña para trucos de Asesino
local Sheriff = KillerHub.Tabs.Sheriff   -- Pestaña para trucos de Sheriff
local Extras  = KillerHub.Tabs.Extras    -- Pestaña para utilidades extras


-- 📌 SECCIÓN 3: CREAR SECCIONES (TÍTULOS DIVISORIOS)
-- Pone un texto verde brillante para separar y organizar tus trucos.
-- Parámetro único: "Texto del título"
Murder:CreateSection("Combate Principal")
Extras:CreateSection("Físicas del Servidor")


-- 🔘 SECCIÓN 4: CREAR TOGGLES (CASILLAS CON AUTO-GUARDADO)
-- Interruptor ON/OFF. Guarda el estado solo en un archivo .json automáticamente.
-- Parámetros: 1. ID único de guardado, 2. Texto visual, 3. Función (devuelve true/false)
Murder:CreateToggle("M_KillAura", "Activar Kill Aura", function(estado)
    if estado then
        print("Kill Aura Encendido")
    else
        print("Kill Aura Apagado")
    end
end)


-- 🎚️ SECCIÓN 5: CREAR SLIDERS (BARRAS DESLIZABLES CON AUTO-GUARDADO)
-- Barra ajustable (0% a 100%). Guarda su valor solo en el archivo .json.
-- Parámetros: 1. ID único de guardado, 2. Texto visual, 3. Función (devuelve valor de 0 a 1)
Extras:CreateSlider("E_WalkSpeed", "Ajustar Velocidad", function(valor)
    -- Multiplica el valor (0 a 1) para dar un rango de velocidad (de 16 a 66)
    local velocidadFinal = 16 + (valor * 50)
    
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = velocidadFinal
    end
end)


-- 🔲 SECCIÓN 6: CREAR BOTONES (ACCIONES DE UN SOLO CLICK)
-- Botón ejecutor instantáneo. No altera el guardado. Hace sonido y destello verde.
-- Parámetros: 1. Texto del botón, 2. Función con el código a ejecutar
Sheriff:CreateButton("Teleport a Pistola Tirada", function()
    local pistola = workspace:FindFirstChild("GunDrop", true)
    if pistola then
        game.Players.LocalPlayer.Character:PivotTo(pistola:GetPivot())
    else
        warn("No hay ninguna pistola tirada en el mapa")
    end
end)


-- ============================================================================
-- 📝 SCRIPT DE EJEMPLO INTEGRADO (CÓMO SE VE UN TRUCO FINALIZADO)
-- ============================================================================
-- Si vas a crear un script completo para actualizar tu Hub, se estructuraría así:
--[[

local KillerHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Paolo0109/KillerHUB/refs/heads/main/InterfazBase.lua"))()

local Murder = KillerHub.Tabs.Murder
local Extras = KillerHub.Tabs.Extras

Murder:CreateSection("Farm Automático")
Murder:CreateToggle("M_AutoCoins", "Recoger Monedas Automático", function(state)
    print("Auto Monedas cambiado a:", state)
end)

Extras:CreateSection("Movimiento Extra")
Extras:CreateButton("Habilitar Salto Infinito", function()
    print("Salto infinito activado con éxito!")
end)

--]]
