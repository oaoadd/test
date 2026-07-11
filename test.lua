-- Xeno Executor Script
local a = game:GetService("Players")
local b = a.LocalPlayer
local c = b.Character or b.CharacterAdded:Wait()
local d = c:WaitForChild("Humanoid")

local function e()
    local f = c:Clone()
    local g = f:FindFirstChild("Humanoid")
    if g then
        g:Destroy()
    end
    for _, h in ipairs(f:GetDescendants()) do
        if h:IsA("BasePart") then
            h.Anchored = false
        end
    end
    return f
end

local function i(j)
    local k = e()
    k.Parent = workspace
    local l = k:FindFirstChild("HumanoidRootPart")
    if not l then
        for _, m in ipairs(k:GetChildren()) do
            if m:IsA("BasePart") then
                l = m
                break
            end
        end
    end
    if l then
        k:SetPrimaryPartCFrame(CFrame.new(j))
    end
    return k
end

local n = 50
local o = 0
local p = 1000

for q = 1, p do
    local r = (q / p) * math.pi * 10
    local s = (q / p) * n
    local t = math.cos(r) * s
    local u = math.sin(r) * s
    local v = 3
    local w = Vector3.new(t, v, u) + c.PrimaryPart.Position
    i(w)
    o = o + 1
    if o % 100 == 0 then
    end
    task.wait(0.01)
end

local x = Instance.new("ScreenGui")
x.Parent = b.PlayerGui
local y = Instance.new("TextLabel")
y.Size = UDim2.new(0, 400, 0, 100)
y.Position = UDim2.new(0.5, -200, 0.5, -50)
y.BackgroundColor3 = Color3.new(0, 0, 0)
y.BackgroundTransparency = 0.5
y.TextColor3 = Color3.new(1, 1, 1)
y.Text = ""
y.TextScaled = true
y.Parent = x
task.wait(5)
x:Destroy()
