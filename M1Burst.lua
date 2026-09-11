-- [[ HOHO HUB EDIT - CUSTOM PVP / NPC KILL AURA ]] --
local Players = game:service("Players")
local Workspace = game:service("Workspace")
local ReplicatedStorage = game:service("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Configuracion balanceada para evitar "Matanza Sospechosa" (Suspicious Kill)
local GOLPES_POR_RAFAGA = 2 -- ~7,000 de daño rápido
local DISTANCIA_SCAN = 60
local atacando = false

-- Buscador optimizado para la Update 30
local function obtenerObjetivo()
    local miChar = LocalPlayer.Character
    if not miChar or not miChar:FindFirstChild("HumanoidRootPart") then return nil end
    local meta = nil
    local rango = DISTANCIA_SCAN
    
    for _, objeto in pairs(Workspace:GetChildren()) do
        if objeto:IsA("Model") and objeto:FindFirstChild("HumanoidRootPart") and objeto:FindFirstChild("Humanoid") then
            if objeto ~= miChar then
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

-- CREACION DEL MENU VISUAL OFICIAL (Color Rojo HoHo Hub Original)
local pGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if pGui then
    if pGui:FindFirstChild("HohoPvP") then pGui.HohoPvP:Destroy() end
    local sg = Instance.new("ScreenGui", pGui)
    sg.Name = "HohoPvP"
    sg.ResetOnSpawn = false
    
    local f = Instance.new("Frame", sg)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    f.Position = UDim2.new(0.05, 0, 0.25, 0)
    f.Size = UDim2.new(0, 220, 0, 100)
    f.BorderSizePixel = 0
    
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0, 30)
    t.BackgroundColor3 = Color3.fromRGB(255, 85, 85) -- Rojo HoHo
    t.Text = "  HOHO HUB - PVP/NPC BYPASS"
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.Font = Enum.Font.SourceSansBold
    t.TextSize = 12
    t.TextXAlignment = Enum.TextXAlignment.Left
    
    local status = Instance.new("TextLabel", f)
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0, 0, 0.45, 0)
    status.Size = UDim2.new(1, 0, 0, 40)
    status.Text = "Kill Aura por Animacion: ACTIVO\n[Equipa tu Espada/Melee]"
    status.TextColor3 = Color3.fromRGB(255, 255, 255)
    status.Font = Enum.Font.SourceSans
    status.TextSize = 11
end

-- BUCLE INTERNO POR RENDER (Forza el ataque emulando el script original)
task.spawn(function()
    while true do
        task.wait(0.05)
        
        if not atacando then
            pcall(function()
                local ch = LocalPlayer.Character
                if ch and ch:FindFirstChild("Humanoid") then
                    local tl = ch:FindFirstChildOfClass("Tool")
                    
                    if tl and (tl:Tooltip() == "Sword" or tl:Tooltip() == "Melee" or tl:FindFirstChild("Attack")) then
                        local objetivo = obtenerObjetivo()
                        
                        if objetivo and objetivo:FindFirstChild("HumanoidRootPart") and objetivo.Humanoid.Health > 0 then
                            atacando = true
                            
                            -- Inyeccion por Animacion Local (Activa la Hitbox sin usar clics del mouse)
                            local animador = ch.Humanoid:FindFirstChildOfClass("Animator")
                            if animador then
                                for _, track in pairs(animador:GetPlayingAnimationTracks()) do
                                    if string.find(string.lower(track.Name), "slash") or string.find(string.lower(track.Name), "attack") then
                                        track:Play() -- Fuerza la animacion del golpe
                                    end
                                end
                            end
                            
                            -- Dispara los remotos de red universales de HoHo
                            for i = 1, GOLPES_POR_RAFAGA do
                                tl:Activate()
                                if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Validator") then
                                    ReplicatedStorage.Remotes.Validator:FireServer()
                                end
                            end
                            
                            -- PAUSA Y SEPARACION ANTI-SUSPICIOUS (Te mueve levemente atras para limpiar el daño)
                            ch.HumanoidRootPart.CFrame = ch.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                            task.wait(1.3) -- Pausa de 1.3 segundos regulada
                            
                            atacando = false
                        end
                    end
                end
            end)
        end
    end
end)
