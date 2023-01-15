local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Knit = require(ReplicatedStorage.Packages.Knit)

local HighlightClass = require(script.Parent.Parent.Classes.HighlightClass)

local PingService = Knit.CreateService({
	Name = "PingService",
	Client = {},
	_PlayerTable = {},
	MaxPing = 0.5, --in seconds
})

function PingService.Client:Ping(player: Player)
	return self.Server:Ping(player)
end

function PingService:Ping(player)
	local GameService = Knit.GetService("GameService")
	local ChatMessageService = Knit.GetService("ChatMessageService")

	if player.Team == GameService.Values.Home.Team or player.Team == GameService.Values.Away.Team then
		if self._PlayerTable[player.Name] then
			if (tick() - self._PlayerTable[player.Name]) > self.MaxPing then
				local time = tick() - self._PlayerTable[player.Name]
				local rounded = math.floor((time * 1000) + 0.5) / 1000
				for i, v in pairs(Teams.Referee:GetPlayers()) do
					task.spawn(function()
						ChatMessageService:Send(
							v,
							("%s has hit a lag spike of %s seconds."):format(player.Name, rounded)
						)
					end)
				end
				warn(("%s has hit a lag spike of %s seconds."):format(player.Name, rounded))
				self._PlayerTable[player.Name] = tick()
			end
		end
		self._PlayerTable[player.Name] = tick()
	end
	return
end

local highlights = {}

function PingService:SendLag(player: string, lagging: boolean)
	if lagging then
		highlights[player] = HighlightClass.new(workspace:FindFirstChild(player), "lag")
	else
		if highlights[player] then
			highlights[player]:Destroy()
		end
	end
end

function PingService:KnitStart()
	print("PingService Started")
end

function PingService:KnitInit()
	Players.PlayerAdded:Connect(function(player)
		player:GetPropertyChangedSignal("Team"):Connect(function()
			local GameService = Knit.GetService("GameService")
			if player.Team == GameService.Values.Home.Team or player.Team == GameService.Values.Away.Team then
				return
			end

			self._PlayerTable[player.Name] = nil
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		if self._PlayerTable[player.Name] then
			self._PlayerTable[player.Name] = nil
		end
	end)

	task.spawn(function()
		local PlayerTable = {}

		while task.wait() do
			for name, time in pairs(self._PlayerTable) do
				task.spawn(function()
					if tick() - time > self.MaxPing then
						if not PlayerTable[name] then
							PlayerTable[name] = true
							self:SendLag(name, true)
						end
					else
						if PlayerTable[name] then
							self:SendLag(name, false)
							PlayerTable[name] = nil
						end
					end
				end)
			end
		end
	end)
	print("PingService Initialized")
end

return PingService
