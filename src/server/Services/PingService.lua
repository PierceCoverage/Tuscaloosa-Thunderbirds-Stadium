local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PingService = Knit.CreateService({
	Name = "PingService",
	Client = {},
	_PlayerTable = {},
	MaxPing = 1, --in seconds
})

function PingService.Client:Ping(player: Player)
	return self.Server:Ping(player)
end

function PingService:Ping(player)
	if self._PlayerTable[player.Name] then
		if (tick() - self._PlayerTable[player.Name]) - 1 > self.MaxPing then
			local time = tick() - self._PlayerTable[player.Name]
			local rounded = math.floor((time * 1000) + 0.5) / 1000
			warn(("%s has hit a lag spike of %s seconds."):format(player.Name, rounded))
			self._PlayerTable[player.Name] = tick()
		end
	end

	self._PlayerTable[player.Name] = tick()

	return
end

function PingService:KnitStart()
	print("PingService Started")
end

function PingService:KnitInit()
	print("PingService Initialized")
end

return PingService
