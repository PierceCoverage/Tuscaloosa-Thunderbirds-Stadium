local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local BindsController = Knit.GetController("BindsController")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Settings = PlayerGui:WaitForChild("Settings")
local Options = Settings.Frame.Frame.Options
local Button = Settings.Frame.TextButton

local optionsHandler = {}

optionsHandler.binds = {
	Options.dive,
	Options.op_dive,
	Options.reach,
	Options.handoff,
	Options.stamina,
}

optionsHandler.toggles = {
	Options.stadium,
	Options:WaitForChild("info_on_top"),
}

Options.stadium.TextButton.MouseButton1Click:Connect(function()
	if workspace:FindFirstChild("Stadium") then
		workspace.Stadium.Parent = ReplicatedStorage
		Options.stadium.TextButton.Text = ""
	else
		if ReplicatedStorage:FindFirstChild("Stadium") then
			ReplicatedStorage.Stadium.Parent = workspace
			Options.stadium.TextButton.Text = "✓"
		end
	end
end)

Options.posttransparency.TextButton.MouseButton1Click:Connect(function()
	Options.Parent.Parent.Visible = false
	PlayerGui.FGTransparency.Background.Visible = true
end)

local parts = {}
local textureParent = nil
Options.fieldtextures.TextButton.MouseButton1Click:Connect(function()
	if Options.fieldtextures.TextButton.Text == "✓" then
		local newfolder = Instance.new("Folder")
		newfolder.Parent = ReplicatedStorage
		newfolder.Name = "FieldTextures"

		for _, descendant in ipairs(workspace:WaitForChild("Field"):GetDescendants()) do
			if
				descendant:IsA("BasePart")
				or descendant:IsA("MeshPart")
				or descendant:IsA("UnionOperation")
				or descendant:IsA("WedgePart")
			then
				if descendant.Material == Enum.Material.Grass then
					if not table.find(parts, descendant) then
						table.insert(parts, descendant)
						descendant.Material = Enum.Material.Plastic
					end
				end
			elseif descendant:IsA("ParticleEmitter") then
				descendant.Enabled = false
			elseif descendant:IsA("Texture") then
				textureParent = descendant.Parent
				descendant.Parent = newfolder
			end
		end
		Options.fieldtextures.TextButton.Text = ""
	else
		for _, descendant in pairs(workspace:WaitForChild("Field"):GetDescendants()) do
			if
				descendant:IsA("BasePart")
				or descendant:IsA("MeshPart")
				or descendant:IsA("UnionOperation")
				or descendant:IsA("WedgePart")
			then
				if descendant.Material == Enum.Material.Plastic then
					descendant.Material = Enum.Material.Grass
					if table.find(parts, descendant) then
						for i = 1, #parts do
							if parts[i] == descendant then
								table.remove(parts, i)
							end
						end
					end
				end
			elseif descendant:IsA("ParticleEmitter") then
				descendant.Enabled = true
			end
		end

		local FieldTextures = ReplicatedStorage:WaitForChild("FieldTextures", 1)

		if FieldTextures then
			if textureParent ~= nil then
				for _, child in pairs(FieldTextures:GetChildren()) do
					child.Parent = textureParent
				end
				FieldTextures:Destroy()
			end
		end
		Options.fieldtextures.TextButton.Text = "✓"
	end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
	if workspace:FindFirstChild("Stadium") then
		return
	end

	character:WaitForChild("HumanoidRootPart").CFrame = workspace.Spawns["OFN Media"].CFrame + Vector3.new(-13, 0, 0)
end)

for i, v in pairs(optionsHandler.binds) do
	v.TextButton.MouseButton1Click:Connect(function()
		local bind_set = false
		local timeout = 6
		local oldtext = v.TextButton.Text

		v.TextButton.Text = "Press a key"

		coroutine.wrap(function()
			for i = 6, 0, -1 do
				task.wait(1)
				timeout = i
			end
		end)()

		local inputObject, gameProcessedEvent = game:GetService("UserInputService").InputBegan:Wait()

		while timeout > 0 and not inputObject do
			task.wait()
		end
		if inputObject then
			if
				inputObject.UserInputType == Enum.UserInputType.Keyboard
				or inputObject.UserInputType == Enum.UserInputType.Gamepad1
			then
				local bindname
				if inputObject.UserInputType == Enum.UserInputType.Keyboard then
					bindname = "Keyboard_"
				elseif inputObject.UserInputType == Enum.UserInputType.Gamepad1 then
					bindname = "Controller_"
				end

				if v.Name == "stam" then
					bindname = bindname .. "Stamina"
				elseif v.Name == "op_dive" then
					bindname = bindname .. "OPDive"
				elseif v.Name == "dive" then
					bindname = bindname .. "Dive"
				elseif v.Name == "reach" then
					bindname = bindname .. "Reach"
				elseif v.Name == "handoff" then
					bindname = bindname .. "Handoff"
				end

				local curbinds = BindsController.Binds
				local isalreadybinded = false
				for i, v in pairs(curbinds) do
					if inputObject.KeyCode == v or inputObject.KeyCode == Enum.KeyCode.Space then
						isalreadybinded = true
					end
				end
				bind_set = true
				if not isalreadybinded then
					v.TextButton.Text = inputObject.KeyCode.Name
					BindsController:ChangeBind(bindname, inputObject.KeyCode)
				else
					v.TextButton.Text = "Not allowed"
					task.wait(3)
					v.TextButton.Text = oldtext
				end
				--update the bind in the code
			end
		else
			v.TextButton.Text = oldtext
		end
		task.wait()
	end)
end

Options:WaitForChild("info_on_top").TextButton.MouseButton1Click:Connect(function()
	PlayerGui.FPS.Container.Visible = not PlayerGui.FPS.Container.Visible
	if PlayerGui.FPS.Container.Visible then
		Options:WaitForChild("info_on_top").TextButton.Text = "✓"
	else
		Options:WaitForChild("info_on_top").TextButton.Text = ""
	end
end)

local open = false
Button.MouseButton1Click:Connect(function()
	open = not open
	if open then
		LocalPlayer.PlayerGui:WaitForChild('Settings').Frame.Frame.Visible = true
	else
		LocalPlayer.PlayerGui:WaitForChild('Settings').Frame.Frame.Visible = false
	end
end)

return optionsHandler
