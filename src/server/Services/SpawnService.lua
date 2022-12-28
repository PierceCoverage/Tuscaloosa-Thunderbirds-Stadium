local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Knit = require(ReplicatedStorage.Packages.Knit)

local SpawnService = Knit.CreateService({
	Name = "SpawnService",
	Client = {},
})

function SpawnService:KnitStart()
	local TeamService = Knit.GetService("TeamService")

	for i, v in pairs(workspace.Spawns:GetChildren()) do
        v.Duration = 0

		if v.Name == "Team Spawn" then
			v.TeamColor = Teams:FindFirstChild(TeamService._HomeTeam.TeamData.Name).TeamColor
		end
	end

	print("SpawnService Started")
end

function SpawnService:KnitInit()
	print("SpawnService Initialized")
end

return SpawnService
