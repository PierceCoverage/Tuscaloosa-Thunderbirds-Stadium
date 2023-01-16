local FB = script.Parent

local Knit = require(game.ReplicatedStorage.Packages.Knit)
local GameService = Knit.GetService("GameService")
GameService:Update({ Ball = FB })

FB.Destroying:Connect(function()
	for i, v in pairs(workspace:GetDescendants()) do
		if v.Name == "Football" then
			if v:IsA("Part") then
				GameService:Update({ Ball = v })
			elseif v:IsA("Tool") then
				GameService:Update({ Ball = v.Handle })
			end
		end
	end
end)

local config = FB:WaitForChild("Configuration")
function configure()
	catchable = config:WaitForChild("Catchable")
	particles = config:WaitForChild("EmitParticles").Value --whether it emits particles during flight
	canUnequip = config:WaitForChild("CanUnequip").Value --whether it can be unequipped
	stayTool = config:WaitForChild("ExistAsTool").Value --whether it can spawn in the workspace as a tool
	gravity = config:WaitForChild("Gravity").Value --how fast it falls
	if gravity == 0 then
		gravity = 0.0001
	end
	friction = config:WaitForChild("AirResistance").Value
end
configure()

local heartbeat = game:GetService("RunService").Heartbeat
local remoteEvent = FB:WaitForChild("RemoteEvent")
local flyingSound = FB:WaitForChild("FlyingSound")
local emitter = FB:WaitForChild("ParticleEmitter")
local freeFalling = false
local handoff = false
local ready = true --failsafe, toggled during important functions
local Thrower = { false, nil }

function areTouching(vector1, vector2)
	--	if (vector1 - vector2).magnitude < 16 then
	--		return true
	--	end
	--	return false
	--return true

	return (vector1 - vector2).magnitude <= 33 -- 11 yards
end

function sendCatchYardsMessage(vector1, vector2, player)
	local check = (vector1 - vector2).magnitude <= 33 -- 11 yards

	local yards = math.floor(((vector1 - vector2).Magnitude / 3) * 100) / 100
	if check then
		local Players = game:GetService("Players")
		local sss = game.ServerScriptService
		local chatService = require(sss:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))

		local msg = player.DisplayName .. " (@" .. player.Name .. ") caught the football from " .. yards .. " yards."

		for _, player in pairs(Players:GetPlayers()) do
			local speaker = chatService:GetSpeaker(player.Name)
			if speaker ~= nil then
				speaker:SendSystemMessage(msg, "All", {
					ChatColor = Color3.fromRGB(255, 255, 0),
				})
			end
		end
	end
end

--the player can't put the ball away
function onUnequip()
	if canUnequip then
		return
	end
	local tool = FB.Parent
	pcall(function()
		if not tool.Parent:FindFirstChild("Humanoid") then
			local char = tool.Parent.Parent.Character
			repeat
				wait()
				tool.Parent = char
			until tool.Parent == char
		end
	end)
end

--initilize
local parent = FB.Parent

if parent:IsA("Tool") then
	if parent.Parent:IsA("Backpack") or game.Players:GetPlayerFromCharacter(parent.Parent) then
		FB.CanCollide = false
		parent.Unequipped:connect(onUnequip)
	else
		FB.CanCollide = true
		if stayTool then
			parent.Unequipped:connect(onUnequip)
		else
			FB.Parent = workspace
			FB.Name = "Football"
			parent:Destroy()
		end
	end
else
	FB.CanCollide = true
end
FB.Anchored = false
flyingSound:Stop()
emitter.Enabled = false

--stop ball moving
function stop()
	freeFalling = false
	if FB:FindFirstChild("BodyVelocity") then
		FB.BodyVelocity:Destroy()
	end
	flyingSound:Stop()
	emitter.Enabled = false
end

--rotate football when held
function normalGrip(tool)
	tool.GripForward = Vector3.new(0.769, 0.452, -0.453)
	tool.GripPos = Vector3.new(0.2, 0.2, 0.3)
	tool.GripRight = Vector3.new(0.293, 0.38, 0.877)
	tool.GripUp = Vector3.new(-0.569, 0.807, -0.16)
	handoff = false
end

function handoffGrip(tool, reach)
	tool.GripPos = Vector3.new(-0.65, 0, 0)
	tool.GripForward = Vector3.new(1, 0, 0)
	tool.GripUp = Vector3.new(0, 1, 0)
	tool.GripRight = Vector3.new(0, 0, 1)
	handoff = reach
end

--tool equipping is glitchy, so we equip it manually
touchDebounce = false
function onTouch(hit: BasePart)
	if not touchDebounce then
		touchDebounce = true

		local char = hit.Parent
		if not game.Players:GetPlayerFromCharacter(char) then
			char = nil
		end
		local tool = FB.Parent
		if not tool:IsA("Tool") then
			tool = nil
		end

		if tool then
			if handoff and char and ready and areTouching(FB.Position, hit.Position) then
				--handoff
				ready = false
				tool.Parent = char
				normalGrip(tool)
				task.wait(1 / 4)
				ready = true
			end
		else
			if
				char
				and ready
				and catchable.Value
				and areTouching(FB.Position, hit.Position)
				and not (Thrower[1] and Thrower[2] == game.Players:GetPlayerFromCharacter(char))
			then
				--touched by character
				ready = false
				sendCatchYardsMessage(FB.Position, hit.Position, game.Players:GetPlayerFromCharacter(char))
				stop()
				FB.CanCollide = false
				tool = Instance.new("Tool")
				tool.Name = "Football"
				tool.CanBeDropped = false
				tool.ToolTip = "Throw: Click, Power: R/F, Handoff: X"
				normalGrip(tool)
				FB.Name = "Handle"
				FB.Parent = tool
				--script.Parent.Trail.Enabled = false
				tool.Parent = char
				tool.Unequipped:connect(onUnequip)
				task.wait(1 / 4)
				ready = true
			elseif hit.CanCollide and hit.Name ~= "Wall" then
				--script.Parent.Trail.Enabled = false
				stop()
			end
		end
		touchDebounce = false
	end
end

FB.Touched:connect(onTouch)

--throw ball
function throw(origin, target, power)
	local tool = FB.Parent
	if tool:IsA("Tool") then
		ready = false
		configure()
		FB.Name = "Football"
		FB.CanCollide = true
		catchable.Value = false

		task.spawn(function()
			task.wait(0.1)
			catchable.Value = true
		end)
		--script.Parent.Trail.Enabled = true
		FB.Parent = game.Workspace
		tool:Destroy()
		handoff = false

		local aim = (target - origin).unit
		local spawnPos = origin + (aim * 5)
		local targetPos = spawnPos + (aim * math.max(1, power))

		FB.Position = spawnPos
		FB.Velocity = aim * power * 1.22
		FB.CFrame = CFrame.new(spawnPos, targetPos) * CFrame.Angles(math.pi / 2, 2, 0)

		local bodyv = Instance.new("BodyVelocity", FB)
		bodyv.maxForce = Vector3.new(1e3, 1e3, 1e3)
		bodyv.P = power * 100
		bodyv.Velocity = (targetPos - FB.CFrame.p).unit * power * 1.22

		--gravity
		flyingSound:Stop()
		flyingSound:Play()
		emitter.Enabled = particles
		freeFalling = true
		ready = true
		local i = 0
		local grav0 = gravity
		local grav1
		--FB.WeldConstraint.Enabled = false

		local rate = 60
		local spiralSpeed = 0.2
		local calc = math.pi / 2

		while freeFalling do
			i += spiralSpeed --spiral speed
			grav1 = grav0 + (friction * (1 - math.abs(FB.CFrame.upVector.Y))) --decrease gravity if air friction hits the broad side
			bodyv.Velocity += Vector3.new(0, grav1 / rate, 0)
			local p = FB.CFrame.p
			FB.CFrame = CFrame.new(p, p + bodyv.velocity) * CFrame.Angles(calc, math.pi * i, calc)
			heartbeat:Wait()
		end

		--FB.WeldConstraint.Enabled = true
	end
end

remoteEvent.OnServerEvent:connect(function(player, tuple)
	if not ready then
		return
	end
	if not FB:IsDescendantOf(player.Character) and tuple[1] == "Clicked" then
		return
	end
	if tuple[1] == "Clicked" then
		local origin = tuple[2]
		local target = tuple[3]
		local power = tuple[4]
		spawn(function()
			Thrower = { true, player }
			wait(1)
			Thrower = { false, nil }
		end)
		throw(origin, target, power)
	elseif tuple[1] == "PlayerSpeed" then
		config:WaitForChild("PlayerSpeed").Value = tuple[2]
	elseif tuple[1] == "c down" then
		local tool = FB.Parent
		if tool:IsA("Tool") then
			handoffGrip(tool, false)
		end
	elseif tuple[1] == "x down" and FB:IsDescendantOf(player.Character) then
		local tool = FB.Parent
		if tool:IsA("Tool") then
			handoffGrip(tool, true)
		end
	elseif tuple[1] == "x up" or tuple[1] == "c up" then
		local tool = FB.Parent
		if tool:IsA("Tool") then
			normalGrip(tool)
		end
	end
end)
