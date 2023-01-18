local Lighting = game:GetService("Lighting")
return {
	name = "brightset",
	aliases = { "brightset", "bs" },
	arguments = { "brightness" },
	callback = function(player, args)
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Knit = require(ReplicatedStorage.Packages.Knit)
		local LightingService = Knit.GetService("LightingService")
		
		if args and args[1] and tonumber(args[1]) then
			LightingService:Update(player, {
				Brightness = tonumber(args[1]),
			})
		end
	end,
}
