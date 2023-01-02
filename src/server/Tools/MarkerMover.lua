local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local GameService = Knit.GetService("GameService")
local TweenService = game:GetService("TweenService")

script.Parent:WaitForChild("RemoteEvent").OnServerEvent:Connect(function(plr, arg1, arg2)
	if arg1.Parent.Name == "down" then
		GameService:UpdateValue({ Position = 2 })
	end
	local distance = math.abs(arg1.CFrame.X - arg2.X)
	local tweenInfo = TweenInfo.new(distance / 30, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(arg1, tweenInfo, { CFrame = arg2 })
	tween:Play()
	tween.Completed:Wait()
	arg1.CFrame = arg2
end)
