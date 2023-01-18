return {
	MoveFD = {
		Commands = { "movefd" }, -- Commands
		Args = { "flip" }, -- Command arguments | Use 'player' if the argument is a player (# evasion)
		Description = "Automatically moves the LOS", -- Command Description
		Hidden = false, -- Is it hidden from the command list? --WIP
		Fun = false, -- Is it fun? -- WIP
		AdminLevel = "Moderators", -- Admin level; Moderators, Admins, Owners, Creators
		Function = function(plr, args)
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local Knit = require(ReplicatedStorage.Packages.Knit)
			local ChainsService = Knit.GetService("ChainsService")

			if string.lower(args[1]) == "flip" then
				ChainsService:MoveFD(true)
			else
				ChainsService:MoveFD()
			end
		end,
	},
}
