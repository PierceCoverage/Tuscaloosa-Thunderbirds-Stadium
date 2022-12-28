local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local CollisionService = Knit.CreateService({
	Name = "CollisionService",
	Client = {},
})

function CollisionService:KnitStart()
	local wall_parts = "WallParts"
	local football_parts = "Football"
	PhysicsService:CreateCollisionGroup(wall_parts)
	PhysicsService:CreateCollisionGroup(football_parts)
	PhysicsService:CollisionGroupSetCollidable(wall_parts, football_parts, false)

	for _, v in pairs(workspace.Field.Walls:GetChildren()) do
		v.CanCollide = true
		PhysicsService:SetPartCollisionGroup(v, wall_parts)
	end

	workspace.ChildAdded:Connect(function(child)
		if child.Name == "Football" and child.MeshId == "rbxassetid://7737955177" then
			PhysicsService:SetPartCollisionGroup(child, football_parts)
		end
	end)

	print("CollisionService Started")
end

function CollisionService:KnitInit()
	print("CollisionService Initialized")
end

return CollisionService
