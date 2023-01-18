local Players = game:GetService("Players")
local Tool = script.Parent
enabled = true
local event = script.Parent:WaitForChild("RemoteEvent")
local selectionBox
local moveHandles
local selectedPose
local previousDistance
local equipped = false

function onMoveHandlesDown(normal)
	if selectedPose then
		previousDistance = 0
	end
end

function onMoveHandlesDrag(normal, distance)
	if normal == Enum.NormalId.Front then
		normal = Enum.NormalId.Right
	elseif normal == Enum.NormalId.Back then
		normal = Enum.NormalId.Left
	end

	if selectedPose then
		--distance = math.floor(distance)
		local delta = distance - previousDistance
		local translation = CFrame.new(Vector3.FromNormalId(normal) * delta)
		selectedPose.CFrame = translation * selectedPose.CFrame
		previousDistance = distance
	end
end

function onButton1Down(mouse)
	selectionBox.Adornee = nil
	moveHandles.Adornee = nil
	if mouse.Target ~= nil then
		if mouse.Target.Locked == false then
			if mouse.Target.Name == "P" then
				selectedPose = mouse.Target
				if selectedPose.Anchored == false then
					selectedPose.Anchored = true
				end
				spawn(function()
					local thisPose = selectedPose
					local LosClone = nil
					local toClone = nil
					if selectedPose.Name == "P" then
						toClone = workspace.Fdown
					end
					if not toClone then
						return
					end
					LosClone = toClone:Clone()
					LosClone.BrickColor = BrickColor.new("Lime green")
					LosClone.Parent = workspace
					while equipped and thisPose == selectedPose and LosClone do
						task.wait()
						LosClone.CFrame = CFrame.new(selectedPose.CFrame.X, toClone.CFrame.Y, toClone.CFrame.Z)
					end
					toClone = nil
					LosClone:Destroy()
				end)
				selectionBox.Adornee = mouse.Target
				moveHandles.Adornee = mouse.Target
			end
		end
	end
end

local connection

Tool.Equipped:Connect(function()
	local mouse = Players.LocalPlayer:GetMouse()
	mouse.TargetFilter = workspace.Field

	equipped = true
	local character = script.Parent.Parent
	local player = Players:GetPlayerFromCharacter(character)
	mouse.Icon = "rbxasset://textures\\DragCursor.png"
	selectionBox = Instance.new("SelectionBox")
	selectionBox.Color = BrickColor.new("Cyan")
	selectionBox.Adornee = nil
	selectionBox.Parent = player.PlayerGui
	local moveHandlesPart = Instance.new("Part")
	moveHandlesPart.Name = "MoveHandlesProxyPart"
	moveHandlesPart.Size = Vector3.new(2, 2, 2)
	moveHandlesPart.Parent = player.PlayerGui
	moveHandles = Instance.new("Handles")
	moveHandles.Style = Enum.HandlesStyle.Movement
	moveHandles.Color = BrickColor.new("Neon orange")
	moveHandles.Faces = Faces.new(Enum.NormalId.Front, Enum.NormalId.Back)
	moveHandles.Adornee = nil
	moveHandles.MouseDrag:connect(onMoveHandlesDrag)
	moveHandles.MouseButton1Down:connect(onMoveHandlesDown)
	moveHandles.Parent = player.PlayerGui

	mouse.Button1Down:Connect(function()
		onButton1Down(mouse)
	end)
	connection = mouse.Button1Down:Connect(function() end)
end)

Tool.Unequipped:Connect(function()
	if connection then
		connection:Disconnect()
	end

	equipped = false

	if selectedPose then
		event:FireServer(selectedPose, selectedPose.CFrame)
	end

	selectionBox:Destroy()
	moveHandles:Destroy()
end)
