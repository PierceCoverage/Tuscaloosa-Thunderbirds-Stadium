local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")

local Knit = require(ReplicatedStorage.Packages.Knit)

local Plugin = {

	AwayTeam = {
		Commands = { "awayteam" }, -- Commands
		Args = { "team" }, -- Command arguments | Use 'player' if the argument is a player (# evasion)
		Description = "Sets the away team", -- Command Description
		Hidden = false, -- Is it hidden from the command list? --WIP
		Fun = false, -- Is it fun? -- WIP
		AdminLevel = "Moderators", -- Admin level; Moderators, Admins, Owners, Creators
		Function = function(plr, args)
			local GameService = Knit.GetService("GameService")
			local TeamService = Knit.GetService("TeamService")

			local TeamInfo = TeamService:GetAllTeams()

			local team = args[1]

			for _, teamTable in pairs(TeamInfo) do
				local name = teamTable.TeamData.Name

				if team:lower() == name:lower():sub(1, string.len(team)) then
					local Home = GameService.Values.Home.Team

					if name == Home.Name then
						return
					end

					GameService.Values.Away.Team:Destroy()

					local newTeam = Instance.new("Team")
					newTeam.TeamColor = teamTable.ColorData.Primary.BrickColor
					newTeam.Name = name
					newTeam.AutoAssignable = false
					newTeam.Parent = Teams

					if newTeam.TeamColor == Home.TeamColor then
						newTeam.TeamColor = teamTable.ColorData.Secondary.BrickColor
					end

					for name, teamTable in pairs(workspace.Spawns:GetChildren()) do
						if teamTable.Name == "Away" then
							teamTable.TeamColor = newTeam.TeamColor
						end
					end

					GameService:Update({ AwayTeam = newTeam })
				end
			end
		end,
	},
}
return Plugin
