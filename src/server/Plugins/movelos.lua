local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Plugin = {
	MoveLOS = {
		Commands = { "movelos" }, -- Commands
		Args = { "arg" }, -- Command arguments | Use 'player' if the argument is a player (# evasion)
		Description = "Automatically moves the LOS", -- Command Description
		Hidden = false, -- Is it hidden from the command list? --WIP
		Fun = false, -- Is it fun? -- WIP
		AdminLevel = "Moderators", -- Admin level, Moderators, Admins, Owners, Creators
		Function = function(plr, args)
			print("Running!")
			local Knit = require(ReplicatedStorage.Packages.Knit)
			local IndicatorService = Knit.GetService("IndicatorService")
			local ChainsService = Knit.GetService("ChainsService")
			local GameService = Knit.GetService("GameService")
			local modifier = 0
			local down = ChainsService.down

			if args[1] and tonumber(args[1]) then --if args[1] and its a number
				modifier = tonumber(args[1]) * 3 * IndicatorService._Direction
			end

			if modifier ~= 0 then
				print("Modifier")
				local target = CFrame.new(down.P.CFrame.X + modifier, down.P.CFrame.Y, down.P.CFrame.Z)
					* CFrame.Angles(0, math.rad(-90), 0)
				local distance = math.abs(target.X - down.P.CFrame.X)
				local tweenInfo = TweenInfo.new(distance / 30, Enum.EasingStyle.Linear)
				local tween = TweenService:Create(down.P, tweenInfo, { CFrame = target })
				tween:Play()
			else
				print("No modifier")
				local target = CFrame.new(GameService.Values.Position, down.P.CFrame.Y, down.P.CFrame.Z)
					* CFrame.Angles(0, math.rad(-90), 0)

				local distance = math.abs(target.X - down.P.CFrame.X)
				local tweenInfo = TweenInfo.new(distance / 30, Enum.EasingStyle.Linear)
				local tween = TweenService:Create(down.P, tweenInfo, { CFrame = target })
				tween:Play()
			end
			local Down = GameService.Values.Down

			if Down == 1 then
				GameService:UpdateValue({ Down = 2 })
			elseif Down == 2 then
				GameService:UpdateValue({ Down = 3 })
			elseif Down == 3 then
				GameService:UpdateValue({ Down = 4 })
			end
			local FD = ChainsService.first
			if GameService.Values.Position > FD.P.CFrame.X and IndicatorService._Direction == 1 then
				GameService:UpdateValue({ Down = 1 })
				local target = CFrame.new(
					GameService.Values.Position + (30 * IndicatorService._Direction),
					FD.P.CFrame.Y,
					FD.P.CFrame.Z
				) * CFrame.Angles(0, math.rad(-90), 0)

				local distance = math.abs(target.X - FD.P.CFrame.X)
				local tweenInfo = TweenInfo.new(distance / 30, Enum.EasingStyle.Linear)
				local tween = TweenService:Create(FD.P, tweenInfo, { CFrame = target })
				tween:Play()
			elseif GameService.Values.Position < FD.P.CFrame.X and IndicatorService._Direction == -1 then
				GameService:UpdateValue({ Down = 1 })
				local target = CFrame.new(
					GameService.Values.Position + (30 * IndicatorService._Direction),
					FD.P.CFrame.Y,
					FD.P.CFrame.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				local distance = math.abs(target.X - FD.P.CFrame.X)
				local tweenInfo = TweenInfo.new(distance / 30, Enum.EasingStyle.Linear)
				local tween = TweenService:Create(FD.P, tweenInfo, { CFrame = target })
				tween:Play()
			end
		end,
	},
}
return Plugin
