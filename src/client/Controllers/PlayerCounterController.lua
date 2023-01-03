local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerCounterController = Knit.CreateController({ Name = "PlayerCounterController" })

function PlayerCounterController:KnitStart()
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer.PlayerGui
	local FPS = PlayerGui:WaitForChild("FPS")
	local PlayerCountService = Knit.GetService("PlayerCountService")

	PlayerCountService.Count:Connect(function(H, A)
		FPS.Container.HNum.Text = tostring(H)
		FPS.Container.ANum.Text = tostring(A)
	end)
	print("PlayerCounterController Started")
end

function PlayerCounterController:KnitInit()

	print("PlayerCounterController Initialized")
end

return PlayerCounterController
