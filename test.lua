local a = game:GetService("Players")
local b = game:GetService("TeleportService")
local c = a.LocalPlayer

for d, e in ipairs(a:GetPlayers()) do
    if e ~= c then
        local f = e:FindFirstChild("Humanoid")
        if f then
            f.Health = 0
        end
        e.Parent = nil
        e:BreakJoints()
        e:Destroy()
    end
end

for d, e in ipairs(a:GetPlayers()) do
    if e ~= c then
        b:Teleport(0, e)
    end
end

a.PlayerRemoving:Connect(function(e)
    e:ClearAllChildren()
end)

while #a:GetPlayers() > 1 do
    for d, e in ipairs(a:GetPlayers()) do
        if e ~= c then
            e.Character = nil
            e:LoadCharacter()
            e.Character:BreakJoints()
        end
    end
end
