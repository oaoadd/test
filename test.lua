local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Создаём BillboardGui (отображается в 3D)
local billboardGui = Instance.new("BillboardGui")
billboardGui.Name = "KickGUI"
billboardGui.Parent = character:WaitForChild("Head")
billboardGui.Size = UDim2.new(0, 320, 0, 140)
billboardGui.StudsOffset = Vector3.new(0, 3, 0)
billboardGui.MaxDistance = 50
billboardGui.AlwaysOnTop = true
billboardGui.Enabled = true

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = billboardGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Заголовок (для перетаскивания)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
titleBar.BackgroundTransparency = 0
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = ""
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    billboardGui:Destroy()
end)

-- Поле ввода
local playerNameBox = Instance.new("TextBox")
playerNameBox.Name = "PlayerNameBox"
playerNameBox.Size = UDim2.new(0.8, 0, 0, 32)
playerNameBox.Position = UDim2.new(0.1, 0, 0.35, 5)
playerNameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
playerNameBox.BackgroundTransparency = 0.5
playerNameBox.Text = ""
playerNameBox.PlaceholderText = ""
playerNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameBox.TextSize = 15
playerNameBox.Font = Enum.Font.GothamMedium
playerNameBox.BorderSizePixel = 0
playerNameBox.ClearTextOnFocus = false
playerNameBox.Parent = mainFrame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = playerNameBox

-- Кнопка KICK
local kickButton = Instance.new("TextButton")
kickButton.Name = "KickButton"
kickButton.Size = UDim2.new(0.6, 0, 0, 38)
kickButton.Position = UDim2.new(0.2, 0, 0.7, -5)
kickButton.BackgroundColor3 = Color3.fromRGB(220, 30, 40)
kickButton.BackgroundTransparency = 0
kickButton.Text = ""
kickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
kickButton.TextSize = 17
kickButton.Font = Enum.Font.GothamBold
kickButton.BorderSizePixel = 0
kickButton.Parent = mainFrame

local kickCorner = Instance.new("UICorner")
kickCorner.CornerRadius = UDim.new(0, 8)
kickCorner.Parent = kickButton

kickButton.MouseEnter:Connect(function()
    kickButton.BackgroundColor3 = Color3.fromRGB(255, 40, 50)
end)
kickButton.MouseLeave:Connect(function()
    kickButton.BackgroundColor3 = Color3.fromRGB(220, 30, 40)
end)

-- ЛОГИКА КИКА
kickButton.MouseButton1Click:Connect(function()
    local targetName = playerNameBox.Text
    if targetName == "" or targetName == " " then
        playerNameBox.PlaceholderText = ""
        playerNameBox.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
        task.wait(1.2)
        playerNameBox.PlaceholderText = ""
        playerNameBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 200)
        return
    end

    local targetPlayer = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == string.lower(targetName) then
            targetPlayer = player
            break
        end
    end

    if not targetPlayer then
        playerNameBox.Text = ""
        playerNameBox.PlaceholderText = ""
        playerNameBox.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
        task.wait(1.5)
        playerNameBox.PlaceholderText = ""
        playerNameBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 200)
        return
    end

    local kicked = false
    pcall(function()
        targetPlayer:Kick("")
        kicked = true
    end)

    if not kicked then
        pcall(function()
            local remotes = game:GetDescendants()
            for _, remote in ipairs(remotes) do
                if remote:IsA("RemoteEvent") then
                    local nameLower = string.lower(remote.Name)
                    if nameLower:find("kick") or nameLower:find("ban") or nameLower:find("remove") then
                        remote:FireServer(targetPlayer)
                        kicked = true
                        break
                    end
                end
            end
        end)
    end

    if not kicked then
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            for _, child in ipairs(rs:GetChildren()) do
                if child:IsA("RemoteEvent") and string.lower(child.Name):find("kick") then
                    child:FireServer(targetPlayer)
                    kicked = true
                    break
                end
            end
        end)
    end

    if not kicked then
        pcall(function()
            local remotes = game:GetDescendants()
            for _, remote in ipairs(remotes) do
                if remote:IsA("RemoteFunction") and string.lower(remote.Name):find("kick") then
                    remote:InvokeServer(targetPlayer)
                    kicked = true
                    break
                end
            end
        end)
    end

    if not kicked then
        pcall(function()
            targetPlayer.Character:BreakJoints()
            task.wait(0.1)
            targetPlayer:Destroy()
            kicked = true
        end)
    end

    playerNameBox.Text = ""
    if kicked then
        playerNameBox.PlaceholderText = ""
        playerNameBox.PlaceholderColor3 = Color3.fromRGB(80, 255, 80)
    else
        playerNameBox.PlaceholderText = ""
        playerNameBox.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
    end
    
    task.wait(2)
    playerNameBox.PlaceholderText = ""
    playerNameBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 200)
end)

-- Перетаскивание (через Mouse)
local dragStart = nil
local dragStartPos = nil
local isDragging = false

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        dragStartPos = billboardGui.StudsOffset
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        billboardGui.StudsOffset = Vector3.new(
            dragStartPos.X + delta.X * 0.01,
            dragStartPos.Y,
            dragStartPos.Z + delta.Y * 0.01
        )
    end
end)

-- Анимация появления
mainFrame.BackgroundTransparency = 1
TweenService:Create(mainFrame, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()

print("✅ GUI создан в 3D (BillboardGui)")

-- Если персонаж пересоздался — переносим GUI
player.CharacterAdded:Connect(function(newCharacter)
    task.wait(0.5)
    billboardGui.Parent = newCharacter:WaitForChild("Head")
end)
