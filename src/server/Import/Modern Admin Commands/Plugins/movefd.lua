local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Plugin = {

	MoveFD = {
		Commands = { "movefd" }, -- Commands
		Args = { "flip" }, -- Command arguments | Use 'player' if the argument is a player (# evasion)
		Description = "Automatically moves the LOS", -- Command Description
		Hidden = false, -- Is it hidden from the command list? --WIP
		Fun = false, -- Is it fun? -- WIP
		AdminLevel = "Moderators", -- Admin level; Moderators, Admins, Owners, Creators
		Function = function(plr, args)
			local Knit = require(ReplicatedStorage.Packages.Knit)
			local IndicatorService = Knit.GetService("IndicatorService")
			local ChainsService = Knit.GetService("ChainsService")
			local GameService = Knit.GetService("GameService")

			if string.lower(args[1]) == "flip" then
				IndicatorService._Direction *= -1
			end

			local first = ChainsService.first

			local target = CFrame.new(
				GameService.Values.Position + (30 * IndicatorService._Direction),
				first.P.CFrame.Y,
				first.P.CFrame.Z
			) * CFrame.Angles(0, math.rad(-90), 0)

			local distance = math.abs(target.X - first.P.CFrame.X)
			local tweenInfo = TweenInfo.new(distance / 30, Enum.EasingStyle.Linear)
			local tween = TweenService:Create(first.P, tweenInfo, { CFrame = target })
			tween:Play()

			GameService:Update({ Down = 1 })
		end,
	},
}
return Plugin
