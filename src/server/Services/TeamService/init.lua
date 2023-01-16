local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")

local Knit = require(ReplicatedStorage.Packages.Knit)

local TeamService = Knit.CreateService({
	Name = "TeamService",
	Client = {},
	_TeamData = {},
	_HomeTeam = nil,
	_AwayTeam = nil,
})

function TeamService.Client:GetTeams()
	return self.Server._TeamData
end

function TeamService.Client:GetHomeTeam()
	return self.Server._HomeTeam
end

function TeamService.Client:GetAwayTeam()
	return self.Server._AwayTeam
end

function TeamService:GetTeamData(team_name: string)
	for i, v in pairs(self._TeamData) do
		if v.TeamData.Name == team_name then
			return v
		end
	end
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

local function create_team(Name: string, Color: BrickColor, AutoAssignable: boolean): Team
	local Team = Instance.new("Team")
	Team.Name = Name
	Team.TeamColor = Color
	Team.AutoAssignable = AutoAssignable
	Team.Parent = Teams
	return Team
end

function TeamService:SetAwayTeam(name: string)
	local GameService = Knit.GetService("GameService")
	local Away = GameService.Values.Away.Team
	local Home = GameService.Values.Home.Team

	local team = self:GetTeamData(name)

	if not team then
		return
	end

	if Home and name == Home.Name then
		return
	end

	local color = team.ColorData.Primary.BrickColor

	if Home and color == Home.TeamColor then
		color = team.ColorData.Secondary.BrickColor
	end

	local TeamObject = create_team(team.TeamData.Name, team.ColorData.Primary.BrickColor, false)

	for _, spawn in pairs(workspace.Spawns:GetChildren()) do
		if spawn.Name == "Away" then
			spawn.TeamColor = color
		end
	end

	local team_players = {}

	if Away then
		team_players = Away:GetPlayers()
		Away:Destroy()
	end

	self.AwayTeam = team
	GameService:Update({ AwayTeam = TeamObject })

	for _, v in pairs(team_players) do
		v.Team = TeamObject
	end
end

function TeamService:SetHomeTeam(name: string)
	local GameService = Knit.GetService("GameService")
	local Away = GameService.Values.Away.Team
	local Home = GameService.Values.Home.Team

	local team = self:GetTeamData(name)

	if not team then
		return
	end

	if Away and name == Away.Name then
		return
	end

	local color = team.ColorData.Primary.BrickColor

	if Away and color == Away.TeamColor then
		Away.TeamColor = self._AwayTeam.ColorData.Secondary.BrickColor
	end

	local TeamObject = create_team(team.TeamData.Name, team.ColorData.Primary.BrickColor, false)

	for _, spawn in pairs(workspace.Spawns:GetChildren()) do
		if spawn.Name == "Team Spawn" then
			spawn.TeamColor = color
		end
	end

	for _, v in pairs(workspace.Stadium.Seating:GetChildren()) do
		if v:IsA("BasePart") then
			if v.Name == "PRIMARY" then
				v.Color = team.ColorData.Primary.Color
			elseif v.Name == "SECONDARY" then
				v.Color = team.ColorData.Secondary.Color
			elseif v.Name == "TERTIARY" then
				v.Color = Color3.fromRGB(30, 30, 30)
			end
		end
	end

	for _, v in pairs(workspace.Stadium.SeatTarp:GetDescendants()) do
		if v.Name == "SECONDARY" then
			v.Color = team.ColorData.Secondary.Color
		end
	end

	for _, v in pairs(workspace.Field["Field Grass"]:GetChildren()) do
		if v.Name == "Endzone" then
			v.Color = team.ColorData.Primary.Color
		end
	end

	local team_players = {}

	if Home then
		team_players = Home:GetPlayers()
		Home:Destroy()
	end

	self._HomeTeam = team
	GameService:Update({ HomeTeam = TeamObject })

	for _, v in pairs(team_players) do
		v.Team = TeamObject
	end
end

function TeamService:KnitStart()
	local GameService = Knit.GetService("GameService")

	for _, module in pairs(script.Teams:GetChildren()) do
		local team = require(module)
		table.insert(self._TeamData, team)
		if team.TeamData.PlaceId == game.PlaceId then
			self:SetHomeTeam(team.TeamData.Name)
		end
	end

	for _, default_team in pairs(script.Default:GetChildren()) do
		task.spawn(function()
			local team = require(default_team)

			local team_object = create_team(team.Name, team.Color, team.AutoAssignable)

			if team.Callback then
				team.Callback(team_object)
			end

			if team_object.Name == "Away" then
				self._AwayTeam = team
			end
		end)
	end

	GameService:Update({
		HomeTeam = Teams:FindFirstChild(self._HomeTeam.TeamData.Name),
		AwayTeam = Teams:FindFirstChild(self._AwayTeam.TeamData and self._AwayTeam.TeamData.Name or "Away"),
	})

	print("TeamService Started")
end

function TeamService:KnitInit()
	print("TeamService Initialized")
end

return TeamService
