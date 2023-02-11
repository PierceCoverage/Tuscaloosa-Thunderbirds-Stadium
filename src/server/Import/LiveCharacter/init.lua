local LC = {}

local Players = game:GetService("Players")

local RatelimitService = require(script.RatelimitService)
local IgnoreListEnum = require(script.IgnoreListEnum)

local updateAppearance = function(playerObject, ignoreList)
	if not playerObject:IsA("Player") then
		return false
	end

	local Humanoid = playerObject.Character:FindFirstChild("Humanoid")
	if not Humanoid then
		return false
	end

	if ignoreList ~= nil then
		for ignoreProperty, ignoreValue in pairs(IgnoreListEnum) do
			if ignoreList[ignoreProperty] == nil then
				ignoreList[ignoreProperty] = ignoreValue
			end
		end
	else
		ignoreList = IgnoreListEnum
	end

	local playerHumanoidDescription: HumanoidDescription = RatelimitService:callOnFunction(function()
		return Players:GetHumanoidDescriptionFromUserId(playerObject.UserId)
	end)

	playerHumanoidDescription.FallAnimation = ""
	playerHumanoidDescription.WalkAnimation = ""
	playerHumanoidDescription.ClimbAnimation = ""
	playerHumanoidDescription.IdleAnimation = ""
	playerHumanoidDescription.JumpAnimation = ""
	playerHumanoidDescription.RunAnimation = ""
	playerHumanoidDescription.SwimAnimation = ""

	playerHumanoidDescription.BodyTypeScale = ""
	playerHumanoidDescription.DepthScale = ""
	playerHumanoidDescription.HeadScale = ""
	playerHumanoidDescription.HeightScale = ""
	playerHumanoidDescription.ProportionScale = ""
	playerHumanoidDescription.WidthScale = ""

	pcall(function()
		Humanoid:ApplyDescription(playerHumanoidDescription)
	end)

	return true
end

function LC:updatePlayerAppearance(playerObject, ignoreList)
	if not playerObject:IsA("Player") then
		return false
	end

	return updateAppearance(playerObject, ignoreList)
end

function LC:autoUpdatePlayerAppearance(playerObject, ignoreList)
	if not playerObject:IsA("Player") then
		return false
	end

	local API = {}
	local isNotPaused = true
	local terminateProcess = false

	function API:toggleAutoUpdating(boolean)
		if type(boolean) ~= "boolean" then
			return false
		end
		isNotPaused = boolean
	end

	function API:Disconnect()
		terminateProcess = true
		return true
	end

	task.delay(0, function()
		while task.wait(1) do
			if terminateProcess then
				break
			end
			if isNotPaused then
				task.delay(0, function()
					updateAppearance(playerObject, ignoreList)
				end)
			end
		end
	end)

	return API
end

return LC
