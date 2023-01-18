local player = game.Players.LocalPlayer
local PlayerGui = player.PlayerGui
local ButtonFrame = script.Parent:WaitForChild("Frame")

local E = ButtonFrame:WaitForChild("E")
local Backspace = ButtonFrame:WaitForChild("Backspace")
local Movement = require(player.Character:WaitForChild("StaminaAndDive"))
local Griddy = PlayerGui:WaitForChild("Griddy")

function thinkUserIsMobile()
	script.Parent.Enabled = true
	PlayerGui:WaitForChild("Scoreboard").Enabled = false
	PlayerGui:WaitForChild("Weather").Enabled = false
	Griddy.Enabled = false
end

function thinkUserIsPC()
	script.Parent.Enabled = false
	PlayerGui:WaitForChild("Scoreboard").Enabled = true
	PlayerGui:WaitForChild("Weather").Enabled = true
	Griddy.Enabled = true
end
--
--binds the UI to the E key
E.MouseButton1Click:Connect(function()
	Movement:Dive(false)
	print("here")
end)

Backspace.MouseButton1Click:Connect(function()
	Movement:Dive(true)
	print("here")
end)

ButtonFrame.Stamina.MouseButton1Click:Connect(function()
	Movement:StamChange()
end)

--Stamina.InputBegan:connect(function (inp)
--if inp.UserInputType == Enum.UserInputType.Touch then --This is the key code for mouse 1
--print("they're clicking stam bar")
--Movement:StamChange()
--end
--end)

local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled then
	script.Parent.Enabled = true
	PlayerGui:WaitForChild("Scoreboard").Enabled = false
	PlayerGui:WaitForChild("Weather").Enabled = false
	Griddy.Enabled = false
end
local mouseInput = {
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.MouseButton2,
	Enum.UserInputType.MouseButton3,
	Enum.UserInputType.MouseMovement,
	Enum.UserInputType.MouseWheel,
}

local keyboard = Enum.UserInputType.Keyboard

local function ToggleMouse(lastInputType)
	if lastInputType == keyboard then
		thinkUserIsPC()
		return
	elseif lastInputType == Enum.UserInputType.Touch then
		thinkUserIsMobile()
	end

	for i, mouse in pairs(mouseInput) do
		if lastInputType == mouse then
			--	UserInputService.MouseIconEnabled = true
			return
		end
	end
end

UserInputService.LastInputTypeChanged:Connect(ToggleMouse)
