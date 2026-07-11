local a = game:GetService("Players")
local b = a.LocalPlayer

for c, d in pairs(a:GetPlayers()) do
    if d ~= b then
        d.Network:Close()
    end
end
