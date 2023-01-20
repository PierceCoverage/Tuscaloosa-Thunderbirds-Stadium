local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Maid = require(ReplicatedStorage.Packages.maid)
local Option = require(ReplicatedStorage.Packages.option)

local FootballConfig = require(script.Parent.FootballConfig)

local Football = {}
Football.__index = Football

function Football.new() --Create a new Football object
	local self = setmetatable({}, Football)
	self._maid = Maid.new()

	local Tool = ServerScriptService.server.Assets.Football:Clone()

	self._Tool = Tool
	self._Handle = Tool.Handle
	self._Player = nil
	self._FootballService = Knit.GetService("FootballService")

	for property, value in pairs(FootballConfig) do
		self[property] = value
	end

	return self
end

function Football:_stop() --Stop ball from freefalling
	local BodyVelocity = self._Handle:FindFirstChildOfClass("BodyVelocity")
	self.Freefalling = false

	if BodyVelocity then
		BodyVelocity:Destroy()
	end
end

function Football:_normalGrip() --Set grip to normal grip
	local Tool = self._Tool
	Tool.GripForward = Vector3.new(0.769, 0.452, -0.453)
	Tool.GripPos = Vector3.new(0.2, 0.2, 0.3)
	Tool.GripRight = Vector3.new(0.293, 0.38, 0.877)
	Tool.GripUp = Vector3.new(-0.569, 0.807, -0.16)

	self.Handoff = false
end

function Football:_handoffGrip() --Set grip to handoff grip
	local Tool = self._Tool
	Tool.GripPos = Vector3.new(-0.65, 0, 0)
	Tool.GripForward = Vector3.new(1, 0, 0)
	Tool.GripUp = Vector3.new(0, 1, 0)
	Tool.GripRight = Vector3.new(0, 0, 1)

	self.Handoff = true
end

function Football:_giveToPlayer(player: Player)
	assert(player, "player argument must be given!")
	self._FootballService.Client.SetBall:Fire(player, true)
	self._Player = player
	self._Tool.Parent = player.Character or player.CharacterAdded:Wait()
	self._Handle.Name = "Handle"
	self._Handle.Parent = self._Tool
	self.Catchable = false
end

function Football:_listenForEquipped()
	self._maid:GiveTask(self._Tool.Unequipped:Connect(function()
		task.wait()
		Option.Wrap(self._Tool.Parent):Match({
			Some = function()
				self._FootballService.Client.Unequipped:Fire(self._Player)
				self._Tool.Parent = self._Player.Character or self._Player.CharacterAdded:Wait()
			end,
			None = function() end,
		})
	end))

	self._maid:GiveTask(self._Tool.Equipped:Connect(function()
		Option.Wrap(self._Tool.Parent):Match({
			Some = function() end,
			None = function() end,
		})
	end))
end

function Football:_listenForTouches()
	local function GetPlayerFromPart(part)
		return Option.Wrap(Players:GetPlayerFromCharacter(part.Parent))
	end

	self._maid:GiveTask(self._Handle.Touched:Connect(function(part)
		GetPlayerFromPart(part):Match({
			Some = function(player) -- Handoff or Catch initiated
				if not self.Ready then
					return
				end

				if not self.Catchable then
					return
				end

				local Character = part.Parent

				Option.Wrap(self._Player):Match({
					Some = function(me) -- Handoff initiated
						if player == me then
							return
						end

						if self._Handle.Parent == self._Tool then
							self._FootballService.Client.SetBall:Fire(player, true)
							self._FootballService.Client.SetBall:Fire(me)
							self:_giveToPlayer(player)
							self:_normalGrip()
						end

						self.TouchDebounce = not self.TouchDebounce
					end,
					None = function() -- Catch initiated
						if not self.Catchable then
							return
						end

						self:_stop()
						self._Handle.CanCollide = false

						self._FootballService.Client.SetBall:Fire(player, true)
						self:_giveToPlayer(player)

						self.TouchDebounce = not self.TouchDebounce
					end,
				})
			end,
			None = function() -- Hit wall initiated
				if part.CanCollide then
					self.TouchDebounce = not self.TouchDebounce
					self:_stop()
				end
			end,
		})
	end))
end

function Football:_throw(origin: Vector3, target: Vector3, power: number)
	if self._Handle.Parent ~= self._Tool then
		error("Handle.Parent must be Tool!")
	end

	if not self.Ready then
		error("Football:_throw() can not be called while important functions are running!")
	end

	self.Ready = not self.Ready

	local Tool = self._Tool
	local Handle = self._Handle

	Handle.Name = "Football"
	Handle.CanCollide = true

	self.Handoff = false

	Handle.Parent = workspace
	Tool.Parent = nil

	task.spawn(function()
		task.wait(0.1)
		self.Catchable = true
	end)

	local aim = (target - origin).Unit
	local spawnPos = origin + (aim * 5)
	local targetPos = spawnPos + (aim * math.max(1, power))

	Handle.Position = spawnPos
	Handle.Velocity = aim * power * 1.22
	Handle.CFrame = CFrame.new(spawnPos, targetPos) * CFrame.Angles(math.pi / 2, 2, 0)

	local BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.maxForce = Vector3.new(1e3, 1e3, 1e3)
	BodyVelocity.P = power * 100
	BodyVelocity.Velocity = (targetPos - Handle.CFrame.Position).Unit * power * 1.22
	BodyVelocity.Parent = Handle

	self.Freefalling = true
	local i = 0
	local grav0 = self.Gravity
	local grav1

	self.Ready = not self.Ready
	self._Player = nil

	while self.Freefalling do
		i += 0.2 --spiral speed
		grav1 = grav0 + (self.AirResistance * (1 - math.abs(Handle.CFrame.UpVector.Y))) --decrease gravity if air friction hits the broad side
		BodyVelocity.Velocity = BodyVelocity.Velocity + Vector3.new(0, grav1 * 1 / 60, 0)
		local Position = Handle.CFrame.Position
		Handle.CFrame = CFrame.new(Position, Position + BodyVelocity.Velocity)
			* CFrame.Angles(math.pi / 2, math.pi * i, math.pi / 2)
		task.wait()
	end
end

function Football:Init()
	self:_listenForTouches()
	self:_listenForEquipped()
end

function Football:Destroy()
	self._maid:Destroy()
	self._Handle:Destroy()
	self._Tool:Destroy()
	self = nil
end

return Football
