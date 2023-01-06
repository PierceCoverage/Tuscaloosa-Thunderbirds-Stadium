local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local CollisionService = Knit.CreateService({
	Name = "CollisionService",
})

function CollisionService:KnitStart()
	print("CollisionService Started")
end

function CollisionService:KnitInit()
	local wall_parts = "wall_parts"
	local football_parts = "football_parts"
	PhysicsService:RegisterCollisionGroup(wall_parts)
	PhysicsService:RegisterCollisionGroup(football_parts)
	PhysicsService:CollisionGroupSetCollidable(wall_parts, football_parts, false)

	local ScoreboardService = Knit.GetService("ScoreboardService")

	for _, v in pairs(workspace.Field.Walls:GetChildren()) do
		v.CanCollide = true
		v.CollisionGroup = wall_parts
		v.Touched:Connect(function(part)
			if part.Name == "Football" then
				ScoreboardService:RunClock(false)
			end
		end)
	end

	workspace.ChildAdded:Connect(function(child)
		if child.Name == "Football" and child.MeshId == "rbxassetid://7737955177" then
			child.CollisionGroup = football_parts
		end
	end)

	print("CollisionService Initialized")
end

return CollisionService
