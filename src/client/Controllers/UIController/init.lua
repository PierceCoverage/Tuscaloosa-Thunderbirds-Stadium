local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Roact = require(ReplicatedStorage.Packages.roact)

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
	task.spawn(function()
		local Button = require(script.Components["Ball Cam"])
		local ElementTable = {}

		for i, v in pairs(script.Components:GetChildren()) do
			local tempElement = Roact.createElement(require(v), {})
			ElementTable[v.Name] = tempElement
		end

		local Interface = Roact.createElement("ScreenGui", { Name = "Interface", ResetOnSpawn = false }, ElementTable)
		Roact.mount(Interface, Players.LocalPlayer.PlayerGui)
	end)

	print("UIController Initialized")
end

return UIController
