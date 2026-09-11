-- [[ Hoho Hub Edit - Only PvP Burst M1 ]] --
local Players = game:service("Players")
local Workspace = game:service("Workspace")
local ReplicatedStorage = game:service("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Stats fijas para tu nivel (Espada Lv. 2870)
local GOLPES_NECESARIOS = 4

-- Buscador exclusivo de jugadores enemigos
local function obtenerRival()
    local miChar = LocalPlayer.Character
    if not miChar or not miChar:FindFirstChild("HumanoidRootPart") then return nil end
    local meta = nil
    local rango = 150
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character and pl.Team ~= LocalPlayer.Team then
            local root = pl.Character:FindFirstChild("HumanoidRootPart")
            local hum = pl.Character:FindFirstChild("Humanoid")
            if root and hum and hum.Health > 0 then
                local dist = (miChar.HumanoidRootPart.Position - root.Position).Magnitude
                if dist < rango then
                    rango = dist
                    meta = pl.Character
                end
            end
        end
    end
    return meta
end

-- INTERFAZ ESTILO HOHO HUB (Modo Compacto PvP)
local pGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if pGui then
    if pGui:FindFirstChild("HohoPvP") then pGui.HohoPvP:Destroy() end

    local sg = Instance.new("ScreenGui", pGui)
    sg.Name = "HohoPvP"
    sg.ResetOnSpawn = false

    local f = Instance.new("Frame", sg)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    f.Position = UDim2.new(0.05, 0, 0.25, 0)
    f.Size = UDim2.new(0, 200, 0, 100)
    f.BorderSizePixel = 0

    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0, 30)
    t.BackgroundColor3 = Color3.fromRGB(255, 85, 85) -- Rojo Hoho Hub
    t.Text = "  HOHO HUB - PVP ONLY"
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.Font = Enum.Font.SourceSansBold
    t.TextSize = 12
    t.TextXAlignment = Enum.TextXAlignment.Left

    local status = Instance.new("TextLabel", f)
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0, 0, 0.45, 0)
    status.Size = UDim2.new(1, 0, 0, 40)
    status.Text = "Saca tu espada para activar\nKill Aura PvP (10k Burst)"
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.Font = Enum.Font.SourceSans
    status.TextSize = 12
end

-- BUCLE ULTRA FAST ATTACK INTERCEPTANDO LA MEMORIA (Método Kill Aura)
task.spawn(function()
    while true do
        task.wait(0.01)
        pcall(function()
            local ch = LocalPlayer.Character
            if ch and ch:FindFirstChildOfClass("Tool") then
                local tl = ch:FindFirstChildOfClass("Tool")
                if tl and (tl:Tooltip() == "Sword" or tl:Tooltip() == "Melee" or tl:FindFirstChild("Attack")) then
                    local rival = obtenerRival()
                    if rival and rival:FindFirstChild("HumanoidRootPart") and ch:FindFirstChild("HumanoidRootPart") then
                        -- Teleport directo detrás del jugador real
                        ch.HumanoidRootPart.CFrame = rival.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2.2)
                        
                        -- Invoca el daño forzado simulando los scripts avanzados que usas
                        local CombatFramework = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
                        local ActiveController = CombatFramework.activeController
                        if ActiveController then
                            for i = 1, GOLPES_NECESARIOS do
                                ActiveController.attack()
                            end
                        end
                    end
                end
            end
        end)
    end
end)
