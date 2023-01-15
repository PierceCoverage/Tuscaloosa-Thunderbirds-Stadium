local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ChainsService = Knit.CreateService({
	Name = "ChainsService",
	fdown = workspace.Fdown,
	scrimmage = workspace.scrimmage,
	down = workspace.down,
	start = workspace.S,
	first = workspace.F,
	field = workspace.Field,
	field_size = workspace.Field["Field Grass"].FieldSize,
	_Direction = 1,
})

function ChainsService:MoveLOS(distance)
	local GameService = Knit.GetService("GameService")

	if distance and tonumber(distance) then --Move from current position + yards
		distance *= 3 * self._Direction
	else --Move to last tackle position
		distance = 0
	end

	if distance ~= 0 then
		local target = CFrame.new(self.down.P.CFrame.X + distance, self.down.P.CFrame.Y, self.down.P.CFrame.Z)
			* CFrame.Angles(0, math.rad(-90), 0)
		local move_distance = math.abs(target.X - self.down.P.CFrame.X)
		local tweenInfo = TweenInfo.new(move_distance / 30, Enum.EasingStyle.Linear)
		local tween = TweenService:Create(self.down.P, tweenInfo, { CFrame = target })
		tween:Play()
		GameService:Update({ Position = target.CFrame.X })
	else
		local target = CFrame.new(GameService.Values.LastTackle, self.down.P.CFrame.Y, self.down.P.CFrame.Z)
			* CFrame.Angles(0, math.rad(-90), 0)

		local move_distance = math.abs(target.X - self.down.P.CFrame.X)
		local tweenInfo = TweenInfo.new(move_distance / 30, Enum.EasingStyle.Linear)
		local tween = TweenService:Create(self.down.P, tweenInfo, { CFrame = target })
		tween:Play()
		GameService:Update({ Position = target.X })
	end

	GameService:Update({ Down = GameService.Values.Down + 1 })

	if
		(GameService.Values.LastTackle > self.first.P.CFrame.X and self._Direction == 1)
		or (GameService.Values.LastTackle < self.first.P.CFrame.X and self._Direction == -1)
	then
		self:MoveFD()
	end
end

function ChainsService:MoveFD(flip)
	local GameService = Knit.GetService("GameService")

	if flip then
		self._Direction *= -1
	end

	local target = CFrame.new(
		GameService.Values.Position + (30 * self._Direction),
		self.first.P.CFrame.Y,
		self.first.P.CFrame.Z
	) * CFrame.Angles(0, math.rad(-90), 0)

	local distance = math.abs(target.X - self.first.P.CFrame.X)
	local tweenInfo = TweenInfo.new(distance / 30, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(self.first.P, tweenInfo, { CFrame = target })
	tween:Play()

	GameService:Update({ Down = 1 })
end

function ChainsService:KnitStart()
	local GameService = Knit.GetService("GameService")
	self.down.P.CFrame = CFrame.new(GameService.Values.Position, self.down.P.CFrame.Y, self.down.P.CFrame.Z)
	self:MoveLOS()
	self:MoveFD()
	print("ChainsService Started")
end

function ChainsService:KnitInit()
	task.spawn(function()
		self.scrimmage.Size = Vector3.new(self.scrimmage.Size.X, self.scrimmage.Size.Y, self.field_size.Size.Z)
		self.fdown.Size = Vector3.new(self.scrimmage.Size.X, self.scrimmage.Size.Y, self.field_size.Size.Z)

		RunService.Heartbeat:Connect(function(deltaTime)
			self.scrimmage.CFrame =
				CFrame.new(self.down.P.Position.X, self.field_size.Position.Y + 0.46, self.field_size.Position.Z)
			self.fdown.CFrame =
				CFrame.new(self.first.P.Position.X, self.field_size.Position.Y + 0.46, self.field_size.Position.Z)
		end)
	end)

	print("ChainsService Initialized")
end

return ChainsService
