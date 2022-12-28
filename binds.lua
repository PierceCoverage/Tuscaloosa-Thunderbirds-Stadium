local module = {}

module.keyboard_dive = Enum.KeyCode.E
module.keyboard_opdive = Enum.KeyCode.Backspace
module.keyboard_stamina = Enum.KeyCode.Q
module.controller_dive = Enum.KeyCode.ButtonX
module.controller_opdive = Enum.KeyCode.ButtonB
module.controller_stamina = Enum.KeyCode.ButtonR2
module.keyboard_handoff = Enum.KeyCode.X
module.controller_handoff = Enum.KeyCode.ButtonL3
module.keyboard_reach = Enum.KeyCode.C

local editingBinds = false

function module:receive_button_press(KeyCode, inputType)
	local Player = game.Players.LocalPlayer
	local Character = Player.Character

	local StamAndDive = require(Character:WaitForChild("StaminaAndDive"))
	if not editingBinds then
		if KeyCode == module[inputType .. "_dive"] then
			StamAndDive:Dive(false)
		elseif KeyCode == module[inputType .. "_opdive"] then
			StamAndDive:Dive(true)
		elseif KeyCode == module[inputType .. "_stamina"] then
			StamAndDive:StamChange()
		elseif KeyCode == module[inputType .. "_handoff"] then
			if Character and Character:FindFirstChild("Humanoid") and Character:FindFirstChild("Football") then
				Character.Football.Handle.RemoteEvent:FireServer({ "x down" })
			end
		end
	end
end

function module:receive_button_release(KeyCode, inputType)
	local Player = game.Players.LocalPlayer
	local Character = Player.Character
	if KeyCode == module[inputType .. "_reach"] then
		if Character and Character:FindFirstChild("Humanoid") and Character:FindFirstChild("Football") then
			Character.Football.Handle.RemoteEvent:FireServer({ "c up" })
		end
	elseif KeyCode == module[inputType .. "_handoff"] then
		if Character and Character:FindFirstChild("Humanoid") and Character:FindFirstChild("Football") then
			Character.Football.Handle.RemoteEvent:FireServer({ "x up" })
		end
	end
end

function module:change_bind(bindname, newbind)
	module[bindname] = newbind
end

function module:editing_bind(isEditing)
	editingBinds = isEditing
end

return module
