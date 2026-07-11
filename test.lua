local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        TeleportService:Teleport(0, player)
    end
end
