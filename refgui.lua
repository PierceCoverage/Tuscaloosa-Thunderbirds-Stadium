local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local ScoreboardService = Knit.GetService("ScoreboardService")

Players.LocalPlayer:GetPropertyChangedSignal("TeamColor"):Connect(function()
	if Players.LocalPlayer.Team == game.Teams:WaitForChild("Referee") then
		script.Parent.Visible = true
		script.Parent.Parent.Toggle.Visible = true
	else
		script.Parent.Visible = false
		script.Parent.Parent.Toggle.Visible = false
	end
end)
while not script.Parent.Parent:WaitForChild("Toggle") do
	task.wait()
end
if Players.LocalPlayer.TeamColor == game.Teams:WaitForChild("Referee").TeamColor then
	script.Parent.Visible = true
	script.Parent.Parent.Toggle.Visible = true
else
	script.Parent.Visible = false
	script.Parent.Parent.Toggle.Visible = false
end
script.Parent.Parent:WaitForChild("Toggle").MouseButton1Click:Connect(function()
	script.Parent.Visible = not script.Parent.Visible
end)
for i, v in pairs(script.Parent:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseButton1Click:Connect(function()
			ScoreboardService:SendData(v.Name)
		end)
	end
end
