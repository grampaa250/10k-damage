-- [[ Blox Fruits M1 Burst - COMPATIBLE NPC AUTO-SEARCH ]] --
local Players = game:service("Players")
local Workspace = game:service("Workspace")
local ReplicatedStorage = game:service("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Stats fijas (NPC Daño: 3666 -> 3 golpes = ~11,000 de daño masivo)
local GOLPES_NECESARIOS = 3
local DISTANCIA_ACTIVACION = 55 -- Rango de activacion automatica (55 studs)

-- Buscador Universal de NPCs por Proximidad Fisica en el Entorno
local function obtenerNPCCercano()
    local miChar = LocalPlayer.Character
    if not miChar or not miChar:FindFirstChild("HumanoidRootPart") then return nil end
    
    local meta = nil
    local rango = DISTANCIA_ACTIVACION
    
    -- Escaneo recursivo profundo en todo el entorno del Workspace
    for _, objeto in pairs(Workspace:GetDescendants()) do
        -- Verifica que sea un enemigo o criatura (tiene Hum, HRP y NO es un jugador real)
        if objeto:IsA("Model") and objeto:FindFirstChild("HumanoidRootPart") and objeto:FindFirstChild("Humanoid") then
            if not Players:GetPlayerFromCharacter(objeto) then -- Asegura ignorar jugadores en PvP
                local hum = objeto.Humanoid
                if hum.Health > 0 then
                    local dist = (miChar.HumanoidRootPart.Position - objeto.HumanoidRootPart.Position).Magnitude
                    if dist < rango then
                        rango = dist
                        meta = objeto
                    end
                end
            end
        end
    end
    return meta
end

-- CREACION DEL INDICADOR REFORZADO EN PANTALLA
local pGui = LocalPlayer:WaitForChild("PlayerGui", 10)
local btn = nil
if pGui then
    if pGui:FindFirstChild("M1BurstButtonGui") then
        pGui.M1BurstButtonGui:Destroy()
    end

    local sg = Instance.new("ScreenGui", pGui)
    sg.Name = "M1BurstButtonGui"
    sg.ResetOnSpawn = false

    btn = Instance.new("TextButton", sg)
    btn.Size = UDim2.new(0, 160, 0, 45)
    btn.Position = UDim2.new(0.1, 0, 0.2, 0)
    btn.BackgroundColor3 = Color3.fromRGB(155, 89, 182) -- Color Morado para esta version avanzada
    btn.Text = "AUTO-BURST NPC: ACTIVO"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
end

-- BUCLE PASIVO DE FISICAS (Deteccion Continua)
task.spawn(function()
    while true do
        task.wait(0.1) -- Ritmo constante para no saturar tu ping de red
        
        local ch = LocalPlayer.Character
        if ch then
            local tl = ch:FindFirstChildOfClass("Tool")
            
            -- Se activa unicamente si tienes la espada o el estilo de pelea en la mano
            if tl and (tl:Tooltip() == "Sword" or tl:Tooltip() == "Melee" or tl:FindFirstChild("Attack")) then
                local objetivoNPC = obtenerNPCCercano()
                
                if objetivoNPC and objetivoNPC:FindFirstChild("HumanoidRootPart") and ch:FindFirstChild("HumanoidRootPart") then
                    if btn then
                        btn.Text = "💥 DESTRUYENDO OBJETIVO..."
                        btn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
                    end
                    
                    -- Teleport instantaneo directo a la Hitbox del NPC
                    ch.HumanoidRootPart.CFrame = objetivoNPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.5)
                    task.wait(0.02)
                    
                    -- Inyeccion directa del daño acumulado a la red del juego
                    pcall(function()
                        for i = 1, GOLPES_NECESARIOS do
                            tl:Activate()
                            -- Bypass de remotos actualizados del servidor
                            if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Validator") then
                                ReplicatedStorage.Remotes.Validator:FireServer()
                            end
                        end
                    end)
                    
                    task.wait(0.4) -- Pausa de registro de misiones
                    if btn then
                        btn.Text = "AUTO-BURST NPC: ACTIVO"
                        btn.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
                    end
                end
            end
        end
    end
end)
