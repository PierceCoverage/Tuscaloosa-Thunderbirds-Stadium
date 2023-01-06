local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ChainsService = Knit.CreateService({
	Name = "ChainsService",
	fdown = workspace.Fdown,
	scrimmage = workspace.scrimmage,
	down = workspace.down,
	start = workspace.S,
	first = workspace.F,
	field = workspace.Field,
	field_size = workspace.Field["Field Grass"].FieldSize
})

function ChainsService:KnitStart()
	print("ChainsService Started")
end

function ChainsService:KnitInit()
	task.spawn(function()
		self.scrimmage.Size = Vector3.new(self.scrimmage.Size.X, self.scrimmage.Size.Y, self.field_size.Size.Z)
		self.fdown.Size = Vector3.new(self.scrimmage.Size.X, self.scrimmage.Size.Y, self.field_size.Size.Z)

		RunService.Heartbeat:Connect(function(deltaTime)
			self.scrimmage.CFrame = CFrame.new(self.down.P.Position.X, self.field_size.Position.Y + 0.46, self.field_size.Position.Z)
			self.fdown.CFrame = CFrame.new(self.first.P.Position.X, self.field_size.Position.Y + 0.46, self.field_size.Position.Z)
		end)
	end)

	print("ChainsService Initialized")
end

return ChainsService
