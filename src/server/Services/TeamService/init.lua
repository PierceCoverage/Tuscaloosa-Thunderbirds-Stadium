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

function TeamService:KnitStart()
	local function create_team(Name: string, Color: BrickColor, AutoAssignable: boolean): Team
		local Team = Instance.new("Team")
		Team.Name = Name
		Team.TeamColor = Color
		Team.AutoAssignable = AutoAssignable
		Team.Parent = Teams
		return Team
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

	local GameService = Knit.GetService("GameService")
	GameService.Values.Home.Team = Teams:FindFirstChild(self._HomeTeam.TeamData.Name)
	GameService.Values.Away.Team =
		Teams:FindFirstChild(self._AwayTeam.TeamData and self._AwayTeam.TeamData.Name or "Away")

	task.spawn(function()
		for i, v in pairs(workspace.Stadium.Seating:GetChildren()) do
			if v:IsA("BasePart") then
				if v.BrickColor == BrickColor.new("Bright red") then
					v.Color = self._HomeTeam.ColorData.Primary.Color
				elseif v.BrickColor == BrickColor.new("Navy blue") then
					v.Color = self._HomeTeam.ColorData.Secondary.Color
				elseif v.BrickColor == BrickColor.new("Smoky grey") then
					v.Color = Color3.fromRGB(30, 30, 30)
				end
			end
		end

		for i, v in pairs(workspace.Stadium.SeatTarp:GetDescendants()) do
			if v:IsA("BasePart") and v.BrickColor == BrickColor.new("Navy blue") then
				v.Color = self._HomeTeam.ColorData.Secondary.Color
			end
		end

		for i, v in pairs(workspace.Field["Field Grass"]:GetChildren()) do
			if v.Name == "Endzone" then
				v.Color = self._HomeTeam.ColorData.Primary.Color
			end
		end
	end)
	print("TeamService Started")
end

function TeamService:KnitInit()
	for _, module in pairs(script.Teams:GetChildren()) do
		local team = require(module)
		table.insert(self._TeamData, team)
		if team.TeamData.PlaceId == game.PlaceId then
			self._HomeTeam = team

			local Team = Instance.new("Team")
			Team.Name = team.TeamData.Name
			Team.TeamColor = team.ColorData.Primary.BrickColor
			Team.AutoAssignable = false
			Team.Parent = Teams
		end
	end

	print("TeamService Initialized")
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

return TeamService
