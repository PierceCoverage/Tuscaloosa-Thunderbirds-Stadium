local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerInputController = Knit.CreateController({
	Name = "PlayerInputController",
	InputType = "Keyboard/Mouse",
})

function PlayerInputController:GetInputType()
	local LastInputEnum = UserInputService:GetLastInputType()

	if
		LastInputEnum == Enum.UserInputType.Keyboard
		or string.find(tostring(LastInputEnum.Name), "MouseButton")
		or LastInputEnum == Enum.UserInputType.MouseWheel
	then
		self.InputType = "Keyboard/Mouse"
	elseif LastInputEnum == Enum.UserInputType.Touch then
		self.InputType = "Touch"
	elseif string.find(tostring(LastInputEnum.Name), "Gamepad") then
		self.InputType = "Gamepad"
	end
	return self.InputType, LastInputEnum
end

function PlayerInputController:KnitStart()
	print("PlayerInputController Started")
end

function PlayerInputController:KnitInit()
	if UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
		self.InputType = "Keyboard/Mouse"
	-- Else if device has touch capability but no keyboard and mouse, assume touch input
	elseif UserInputService.TouchEnabled then
		self.InputType = "Touch"
	-- Else if device has an active gamepad, assume gamepad input
	elseif UserInputService.GamepadEnabled then
		self.InputType = "Gamepad"
	end

	print("PlayerInputController Initialized")
end

return PlayerInputController
