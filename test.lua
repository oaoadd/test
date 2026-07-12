local p=game.Players.LocalPlayer
local c=p.Character or p.CharacterAdded:Wait()
local r=c:WaitForChild("HumanoidRootPart")
local i=game:GetService("UserInputService")
local f=25
local t=0.03
local l=0
i.InputBegan:Connect(function(k,n)
if n then return end
if k.KeyCode==Enum.KeyCode.Space then
local m=tick()
if m-l>=t then
l=m
r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,f,r.AssemblyLinearVelocity.Z)
end
end
end)
