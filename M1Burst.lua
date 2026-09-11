local Players = game:service("Players")
local Workspace = game:service("Workspace")
local ReplicatedStorage = game:service("ReplicatedStorage")
local UserInputService = game:service("UserInputService")
local LocalPlayer = Players.LocalPlayer

local DANO_POR_GOLPE = 2859
local DANO_OBJETIVO = 10000
local danoAcumulado = 0
local contadorClics = 0
local scriptActivo = true

local function encontrarRival()
    local miChar = LocalPlayer.Character
    if not miChar or not miChar:FindFirstChild("HumanoidRootPart") then return nil end
    local mejorObjetivo = nil
    local distanciaMinima = 160
    for _, jugador in pairs(Players:GetPlayers()) do
        if jugador ~= LocalPlayer and jugador.Character and jugador.Team ~= LocalPlayer.Team then
            local char = jugador.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if root and hum and hum.Health > 0 then
                local dist = (miChar.HumanoidRootPart.Position - root.Position).Magnitude
                if dist < distanciaMinima then
                    distanciaMinima = dist
                    mejorObjetivo = char
                end
            end
        end
    end
    return mejorObjetivo
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

local playerGui = LocalPlayer:WaitForChild("PlayerGui", 15)
if playerGui then
    ScreenGui.Parent = playerGui
    ScreenGui.ResetOnSpawn = false
    MainFrame.Name = "M1BurstMenu"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 220, 0, 130)
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "  M1 BURST PVP (LV 2870)"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    ToggleButton.Parent = MainFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(0.05, 0, 0.32, 0)
    ToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.Text = "ESTADO: ACTIVADO"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 13
    StatusLabel.Parent = MainFrame
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 25)
    StatusLabel.Font = Enum.Font.SourceSansBold
    StatusLabel.Text = "Carga: 0 / 10000"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 14
    ToggleButton.MouseButton1Click:Connect(function()
        scriptActivo = not scriptActivo
        if scriptActivo then
            ToggleButton.Text = "ESTADO: ACTIVADO"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        else
            ToggleButton.Text = "ESTADO: DESACTIVADO"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
            contadorClics = 0
            danoAcumulado = 0
            StatusLabel.Text = "Carga: 0 / 10000"
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not scriptActivo then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local Character = LocalPlayer.Character
        local Tool = Character and Character:FindFirstChildOfClass("Tool")
        if Tool and (Tool:Tooltip() == "Sword" or Tool:Tooltip() == "Melee" or Tool:FindFirstChild("Attack")) then
            contadorClics = contadorClics + 1
            danoAcumulado = contadorClics * DANO_POR_GOLPE
            if StatusLabel then sStatusLabel.Text = "Carga: " .. tostring(danoAcumulado) .. " / " .. tostring(DANO_OBJETIVO) end
            if danoAcumulado >= DANO_OBJETIVO then
                local enemigo = encontrarRival()
                if enemigo and enemigo:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("HumanoidRootPart") then
                    Character.HumanoidRootPart.CFrame = enemigo.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2.2)
                    task.wait(0.02)
                    pcall(function()
                        for i = 1, contadorClics do
                            Tool:Activate()
                            if Tool:FindFirstChild("RemoteClick") then
                                Tool.RemoteClick:FireServer()
                            elseif ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Validator") then
                                ReplicatedStorage.Remotes.Validator:FireServer()
                            end
                        end
                    end)
                end
                task.wait(0.1)
                contadorClics = 0
                danoAcumulado = 0
                if StatusLabel then StatusLabel.Text = "Carga: 0 / 10000" end
            end
        end
    end
end)
