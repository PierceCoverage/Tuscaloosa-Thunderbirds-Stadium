return {
	name = "timeset",
	aliases = { "timeset", "time", "ts" },
	arguments = { "brightness" },
	callback = function(player, args)
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Knit = require(ReplicatedStorage.Packages.Knit)
		local LightingService = Knit.GetService("LightingService")

		if args and args[1] and tonumber(args[1]) then
			LightingService:Update(player, {
				ClockTime = tonumber(args[1]),
			})
		end
	end,
}
