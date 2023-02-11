local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local LightingController = Knit.CreateController({ Name = "LightingController" })

function LightingController:KnitStart()
	local LightingService = Knit.GetService("LightingService")
	LightingService.Update:Connect(function(tbl)
		for i, v in pairs(tbl) do
			Lighting[i] = v
		end
	end)
	print("LightingController Started")
end

function LightingController:KnitInit()
	print("LightingController Initialized")
end

return LightingController
