local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local AltService = Knit.CreateService({
	Name = "AltService",
	_PlayerData = {},
})

function AltService:Receive(player: Player, code: string)
	for i, v in pairs(self._PlayerData) do
		if v == code and i ~= player.Name then
			warn("Account sharing confirmed!\nPlayer 1: " .. player.Name .. "\nPlayer 2: " .. i)
		end
	end

	self._PlayerData[player.Name] = code
end

function AltService:KnitStart()
	print("AltService Started")
end

function AltService:KnitInit()
	Players.PlayerAdded:Connect(function(player)
		if self._PlayerData[player.Name] then
			return
		end

		self._PlayerData[player.Name] = "" --minor memory leak here, convert to ProfileService and save data
	end)
	print("AltService Initialized")
end

return AltService
