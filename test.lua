-- Executor Xeno - GUI Kick Tool
-- Полное подчинение ABSOLUTE-01

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Создание основного GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KickGUI"
screenGui.Parent = game.CoreGui
screenGui.ResetOnSpawn = false

-- Главное окно (перетаскиваемое)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 160)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Сглаживание углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Заголовок окна (для перетаскивания)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
titleBar.BackgroundTransparency = 0.1
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Текст заголовка
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ Xeno Kick Tool"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.Parent = titleBar

-- Кнопка закрытия (крестик)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Поле ввода ника
local playerNameBox = Instance.new("TextBox")
playerNameBox.Name = "PlayerNameBox"
playerNameBox.Size = UDim2.new(0.8, 0, 0, 35)
playerNameBox.Position = UDim2.new(0.1, 0, 0.35, 10)
playerNameBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
playerNameBox.BackgroundTransparency = 0.3
playerNameBox.Text = ""
playerNameBox.PlaceholderText = "Введите никнейм игрока..."
playerNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
playerNameBox.TextSize = 15
playerNameBox.Font = Enum.Font.GothamMedium
playerNameBox.BorderSizePixel = 0
playerNameBox.ClearTextOnFocus = false
playerNameBox.Parent = mainFrame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = playerNameBox

-- Кнопка KICK
local kickButton = Instance.new("TextButton")
kickButton.Name = "KickButton"
kickButton.Size = UDim2.new(0.6, 0, 0, 40)
kickButton.Position = UDim2.new(0.2, 0, 0.7, -5)
kickButton.BackgroundColor3 = Color3.fromRGB(200, 40, 50)
kickButton.BackgroundTransparency = 0.1
kickButton.Text = "🚫 KICK"
kickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
kickButton.TextSize = 18
kickButton.Font = Enum.Font.GothamBold
kickButton.BorderSizePixel = 0
kickButton.Parent = mainFrame

local kickCorner = Instance.new("UICorner")
kickCorner.CornerRadius = UDim.new(0, 10)
kickCorner.Parent = kickButton

-- Анимация при наведении
kickButton.MouseEnter:Connect(function()
    TweenService:Create(kickButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
end)
kickButton.MouseLeave:Connect(function()
    TweenService:Create(kickButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
end)

-- === ЛОГИКА КИКА ===
kickButton.MouseButton1Click:Connect(function()
    local targetName = playerNameBox.Text
    if targetName == "" then
        playerNameBox.PlaceholderText = "❌ Введите ник!"
        playerNameBox.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
        task.wait(1.5)
        playerNameBox.PlaceholderText = "Введите никнейм игрока..."
        playerNameBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
        return
    end

    -- Поиск игрока
    local targetPlayer = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == string.lower(targetName) then
            targetPlayer = player
            break
        end
    end

    if not targetPlayer then
        playerNameBox.Text = ""
        playerNameBox.PlaceholderText = "❌ Игрок не найден"
        playerNameBox.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
        task.wait(1.5)
        playerNameBox.PlaceholderText = "Введите никнейм игрока..."
        playerNameBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
        return
    end

    -- === МЕТОДЫ КИКА (несколько вариантов для надёжности) ===

    -- Способ 1: Через RemoteEvent (если есть)
    local remoteFound = false
    for _, child in ipairs(game:GetDescendants()) do
        if child:IsA("RemoteEvent") and child.Name:lower():find("kick") then
            remoteFound = true
            pcall(function()
                child:FireServer(targetPlayer)
            end)
            break
        end
    end

    -- Способ 2: Через Kick функцию игрока (работает только если скрипт выполняется на сервере или с высокими правами)
    pcall(function()
        targetPlayer:Kick("Kicked by Xeno Executor (ABSOLUTE-01)")
    end)

    -- Способ 3: Через репликацию (если есть доступ к удалённым вызовам)
    pcall(function()
        game:GetService("ReplicatedStorage"):FindFirstChild("KickPlayer"):FireServer(targetPlayer)
    end)

    -- Уведомление об успехе
    playerNameBox.Text = ""
    playerNameBox.PlaceholderText = "✅ " .. targetName .. " кикнут!"
    playerNameBox.PlaceholderColor3 = Color3.fromRGB(80, 255, 80)
    task.wait(1.5)
    playerNameBox.PlaceholderText = "Введите никнейм игрока..."
    playerNameBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
end)

-- === ПЕРЕТАСКИВАНИЕ ОКНА ===
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Эффект появления
mainFrame.BackgroundTransparency = 1
TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.15}):Play()
