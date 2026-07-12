local a=game.Players.LocalPlayer
local b=a.Character or a.CharacterAdded:Wait()
local c=b:WaitForChild("Humanoid")
local d=b:WaitForChild("HumanoidRootPart")
local e=game:GetService("UserInputService")
local f=8
local g=0.1
local h=0
e.InputBegan:Connect(function(i,j)
if j then return end
if i.KeyCode==Enum.KeyCode.Space then
local k=tick()
if k-h>=g then
h=k
local l=RaycastParams.new()
l.FilterDescendantsInstances={b}
l.FilterType=Enum.RaycastFilterType.Blacklist
local m={d.CFrame.LookVector,-d.CFrame.LookVector,d.CFrame.RightVector,-d.CFrame.RightVector}
local n=2.5
local o=false
for _,p in ipairs(m) do
local q=d.Position+Vector3.new(0,1,0)
local r=workspace:Raycast(q,p*n,l)
if r then o=true break end
end
if o and c and c.Health>0 then
local s=d.AssemblyLinearVelocity
d.AssemblyLinearVelocity=Vector3.new(s.X,f,s.Z)
end
end
end
end)
