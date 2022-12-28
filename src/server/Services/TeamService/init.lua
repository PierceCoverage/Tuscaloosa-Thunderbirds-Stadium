local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local TeamService = Knit.CreateService({
	Name = "TeamService",
	Client = {},
	_TeamData = {},
	_HomeTeam = nil,
})

function TeamService:KnitStart()
	print("TeamService Started")
end

function TeamService:KnitInit()
	print("TeamService Initialized")

	for _, module in pairs(script.Teams:GetChildren()) do
		local team = require(module)
		table.insert(self._TeamData, team)
		if team.TeamData.PlaceId == game.PlaceId then
			print("Home team found!", team.TeamData.Name)
			self._HomeTeam = team
		end
	end
end

function TeamService:GetTeamData(team_name: string)
	return self._TeamData[team_name]
end

function TeamService:GetAllTeams()
	return self._TeamData
end

function TeamService:GetTeamFromRole(role_id: string)
    role_id = tonumber(role_id)
	for _, team in pairs(self._TeamData) do
		if team.TeamData.RoleId == role_id then
			return team.TeamData.Initials
		end
	end
end

return TeamService
