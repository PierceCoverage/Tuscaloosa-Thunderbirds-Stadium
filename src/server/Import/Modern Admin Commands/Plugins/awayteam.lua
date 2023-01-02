local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")

local TeamInformation = require(ReplicatedStorage:WaitForChild("Assets").Modules.TeamInformation)

local Plugin = {

	AwayTeam = {
		Commands = { "awayteam" }, -- Commands
		Args = { "team" }, -- Command arguments | Use 'player' if the argument is a player (# evasion)
		Description = "Sets the away team", -- Command Description
		Hidden = false, -- Is it hidden from the command list? --WIP
		Fun = false, -- Is it fun? -- WIP
		AdminLevel = "Moderators", -- Admin level; Moderators, Admins, Owners, Creators
		Function = function(plr, args)
			local Knit = require(ReplicatedStorage.Packages.Knit)
            local GameService = Knit.GetService("GameService")
			local TeamService = Knit.GetService("TeamService")
			local TeamInfo = TeamService:GetAllTeams()
			local team = args[1]
			local Home = TeamService._HomeTeam
			for _, teamTable in pairs(TeamInfo) do
				if team:lower() == teamTable.TeamData.Name:lower():sub(1, string.len(team)) then
					if teamTable.TeamData.Name == Home.TeamData.Name then
						return
					end

					GameService.Values.Away:Destroy()

					local newTeam = Instance.new("Team")
					newTeam.TeamColor = teamTable.ColorData.Primary.BrickColor
					newTeam.teamTable.TeamData.Name = teamTable.TeamData.Name
					newTeam.AutoAssignable = false
					newTeam.Parent = Teams

					if newTeam.TeamColor == GameService.Values.Home.Team.TeamColor then
						newTeam.TeamColor = teamTable.ColorData.Secondary.BrickColor
					end

					for _, teamTable in pairs(workspace.Spawns:GetChildren()) do
						if teamTable.TeamData.Name == "Away" then
							teamTable.TeamColor = newTeam.TeamColor
						end
					end

					TeamService._AwayTeam = newTeam
				end
			end
		end,
	},
}
return Plugin
