local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local CollisionService = Knit.CreateService({
	Name = "CollisionService",
})

function CollisionService:KnitStart()
	PhysicsService:RegisterCollisionGroup("wall")
	PhysicsService:RegisterCollisionGroup("football")
	PhysicsService:RegisterCollisionGroup("player")
	PhysicsService:RegisterCollisionGroup("fan")

	PhysicsService:CollisionGroupSetCollidable("player", "fan", false)
	PhysicsService:CollisionGroupSetCollidable("football", "fan", false)
	PhysicsService:CollisionGroupSetCollidable("wall", "football", false)
	local previousCollisionGroups = {}

	local function setCollisionGroup(object, name)
		if object:IsA("BasePart") then
			previousCollisionGroups[object] = object.CollisionGroup
			object.CollisionGroup = name
		end
	end

	local function setCollisionGroupRecursive(object, name)
		setCollisionGroup(object, name)

		for _, child in ipairs(object:GetChildren()) do
			setCollisionGroupRecursive(child, name)
		end
	end

	local function resetCollisionGroup(object)
		local previousCollisionGroup = previousCollisionGroups[object]
		if not previousCollisionGroup then
			return
		end

		object.CollisionGroup = previousCollisionGroup
		previousCollisionGroups[object] = nil
	end

	local function onCharacterAdded(character)
		local player = Players:GetPlayerFromCharacter(character)
		local GameService = Knit.GetService("GameService")

		if player.Team == GameService.Values.Away.Team or player.Team == GameService.Values.Home.Team then
			setCollisionGroupRecursive(character, "player")
		else
			setCollisionGroupRecursive(character, "fan")
		end

		character.DescendantAdded:Connect(function(descendant)
			if player.Team == GameService.Values.Away.Team or player.Team == GameService.Values.Home.Team then
				setCollisionGroupRecursive(descendant, "player")
			else
				setCollisionGroupRecursive(descendant, "fan")
			end
		end)

		character.DescendantRemoving:Connect(resetCollisionGroup)
	end

	local function onPlayerAdded(player)
		player:GetPropertyChangedSignal("Team"):Connect(function()
			local TeamService = Knit.GetService("TeamService")
			if player.Team == TeamService:GetAwayTeam() or player.Team == TeamService:GetHomeTeam() then
				setCollisionGroupRecursive(player.Character, "player")
			else
				setCollisionGroupRecursive(player.Character, "fan")
			end
		end)
		player.CharacterAdded:Connect(onCharacterAdded)
	end

	local function onChildAdded(child)
		if child.Name == "Football" and child.MeshId == "rbxassetid://7737955177" then
			setCollisionGroupRecursive(child, "football")
		end
	end

	--setCollisionGroupRecursive(workspace.Field.Walls, "wall")

	workspace.ChildAdded:Connect(onChildAdded)
	workspace.ChildRemoved:Connect(resetCollisionGroup)

	Players.PlayerAdded:Connect(onPlayerAdded)

	print("CollisionService Started")
end

function CollisionService:KnitInit()
	print("CollisionService Initialized")
end

return CollisionService
