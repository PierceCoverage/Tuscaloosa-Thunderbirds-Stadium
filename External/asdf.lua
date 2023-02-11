-- Services --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
-- Variables --
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
-- Values --
local IsWatch = false
--
Camera.CameraType = "Custom"
---

local function find_ball()
	local ball = workspace:FindFirstChild("Football")

	if ball then
		return ball
	end

	for _, player in pairs(Players:GetPlayers()) do
		if
			player.Character
			and player.Character:FindFirstChild("Football")
			and player.Character:FindFirstChild("Football"):IsA("MeshPart")
		then
			return player.Character:FindFirstChild("Football")
		end
	end
end

-- Main --
UserInputService.InputBegan:Connect(function(Input, Busy)
	if not Busy then
		--
		if Input.UserInputType == Enum.UserInputType.Keyboard then
			local Key = Input.KeyCode
			if Key == Enum.KeyCode.One then
				if IsWatch then
					IsWatch = false
					Camera.CameraSubject = Character.Humanoid
					--
					for _, player in pairs(Players:GetPlayers()) do
						if player.Character and player.Character:FindFirstChild("Humanoid") then
							player.Character.Humanoid.NameDisplayDistance = 100
							player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
						end
					end
				else
					IsWatch = true
					Camera.CameraSubject = find_ball()

					for _, player in pairs(Players:GetPlayers()) do
						if player.Character and player.Character:FindFirstChild("Humanoid") then
							player.Character.Humanoid.NameDisplayDistance = math.huge
							player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
						end
					end
                    
					if Camera.CameraSubject == nil then
						IsWatch = false
						Camera.CameraSubject = Character.Humanoid
					end
				end
			end
		end
	end
end)
--
Mouse.Button1Down:Connect(function()
	if IsWatch then
		for _, Ball in pairs(workspace:GetDescendants()) do
			if Ball.Name == "Football" and Ball:IsA("MeshPart") then
				Camera.CameraSubject = Ball
			end
		end
	end
end)
---
