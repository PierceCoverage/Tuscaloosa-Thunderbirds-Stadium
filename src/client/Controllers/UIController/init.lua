local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local UIController = Knit.CreateController({ Name = "UIController" })

function UIController:SetPing(ping: number)
	local Settings = Players.LocalPlayer.PlayerGui:WaitForChild("Settings")
	local Options = Settings.Frame.Frame.Options
	local FPS = Players.LocalPlayer.PlayerGui:WaitForChild("FPS")
	local ping_string = ("%i ms"):format(ping)
	FPS.Container.Ping.Num.Text = ping_string
	Options.ping.Amount.Text = ping_string
end

function UIController:SetFPS(FPSCount: number)
	local Settings = Players.LocalPlayer.PlayerGui:WaitForChild("Settings")
	local Options = Settings.Frame.Frame.Options
	local Amount = Options.fps.Amount

	local FPS = Players.LocalPlayer.PlayerGui:WaitForChild("FPS")
	local fpsNum = FPS.Container.FPS.Num

	Amount.Text = tostring(FPSCount)
	fpsNum.Text = tostring(FPSCount)
end

function UIController:KnitStart()
	print("UIController Started")
end

function UIController:KnitInit()
	print("UIController Initialized")
end

return UIController
