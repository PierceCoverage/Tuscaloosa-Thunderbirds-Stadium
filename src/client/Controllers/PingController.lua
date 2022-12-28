local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PingController = Knit.CreateController({ Name = "PingController" })

function PingController:KnitStart()
	task.spawn(function()
		local PingService = Knit.GetService("PingService")
		local UIController = Knit.GetController("UIController")

		while task.wait(1) do
			local Start = tick()
			PingService:Ping()
			local End = tick()
			local new_ping_seconds = End - Start
			local new_ping_ms = math.floor((new_ping_seconds * 1000) + 0.5)
			UIController:SetPing(new_ping_ms)
		end
	end)

	print("PingController Started")
end

function PingController:KnitInit()
	print("PingController Initialized")
end

return PingController
