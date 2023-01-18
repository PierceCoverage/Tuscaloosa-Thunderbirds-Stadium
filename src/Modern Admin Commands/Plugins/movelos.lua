return {
	MoveLOS = {
		Commands = { "movelos" }, -- Commands
		Args = { "arg" }, -- Command arguments | Use 'player' if the argument is a player (# evasion)
		Description = "Automatically moves the LOS", -- Command Description
		Hidden = false, -- Is it hidden from the command list? --WIP
		Fun = false, -- Is it fun? -- WIP
		AdminLevel = "Moderators", -- Admin level, Moderators, Admins, Owners, Creators
		Function = function(plr, args)
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local Knit = require(ReplicatedStorage.Packages.Knit)
			local ChainsService = Knit.GetService("ChainsService")

			local modifier = 0

			if args[1] and tonumber(args[1]) then --if args[1] and its a number
				modifier = tonumber(args[1]) * 3 * ChainsService._Direction
			end

			ChainsService:MoveLOS(modifier)
		end,
	},
}
