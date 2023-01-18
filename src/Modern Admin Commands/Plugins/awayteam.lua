return {
	AwayTeam = {
		Commands = { "awayteam" }, -- Commands
		Args = { "team" }, -- Command arguments | Use 'player' if the argument is a player (# evasion)
		Description = "Sets the away team", -- Command Description
		Hidden = false, -- Is it hidden from the command list? --WIP
		Fun = false, -- Is it fun? -- WIP
		AdminLevel = "Moderators", -- Admin level; Moderators, Admins, Owners, Creators
		Function = function(plr, args)
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local Knit = require(ReplicatedStorage.Packages.Knit)

			local TeamService = Knit.GetService("TeamService")
			local TeamInfo = TeamService:GetAllTeams()

			local team = args[1]

			for _, teamTable in pairs(TeamInfo) do
				local name = teamTable.TeamData.Name
				if team:lower() == name:lower():sub(1, string.len(team)) then
					TeamService:SetAwayTeam(name)
				end
			end
		end,
	},
}
