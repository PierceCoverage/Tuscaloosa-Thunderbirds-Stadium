local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local GameController = Knit.GetController("GameController")
local CurrentCamera = workspace.CurrentCamera

local Watching = false

local Tool = script.Parent

Tool.Equipped:Connect(function(mouse)
	mouse.Button1Down:Connect(function(mouse)
		Watching = not Watching

		if Watching then --Start watching
			while Watching do
				CurrentCamera.CameraSubject = GameController.Values.Ball
				task.wait(1 / 10)
			end
		else --Stop watching
			CurrentCamera.CameraSubject = Players.LocalPlayer.Character.Humanoid
			CurrentCamera.FieldOfView = 70
		end

		Watching = not Watching
	end)
end)

Tool.Unequipped:Connect(function()
	CurrentCamera.CameraSubject = Players.LocalPlayer.Character.Humanoid
	CurrentCamera.FieldOfView = 70
end)
