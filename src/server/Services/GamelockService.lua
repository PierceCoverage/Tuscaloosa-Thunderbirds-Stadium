local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Teams = game:GetService("Teams")
local Knit = require(ReplicatedStorage.Packages.Knit)

local GamelockService = Knit.CreateService({
	Name = "GamelockService",
	_GameLock = false,
	Boundaries = {
		xMax = 0,
		xMin = 0,
		zMax = 0,
		zMin = 0,
	},
	Teams = {},
})

function GamelockService:Lock(bool: boolean)
	self._GameLock = bool
end

function GamelockService:KnitStart()
	local function set_boundaries()
		local Field = workspace.Field["Field Grass"].FieldSize
		self.Boundaries.xMax = Field.Position.X + (Field.Size.X / 2) + 30
		self.Boundaries.xMin = Field.Position.X - (Field.Size.X / 2) - 30
		self.Boundaries.zMax = Field.Position.Z + (Field.Size.Z / 2)
		self.Boundaries.zMin = Field.Position.Z - (Field.Size.Z / 2)
	end

	local function count_players()
		for _, player in pairs(Players:GetPlayers()) do
			if not player.Team then
				continue
			end
			local character = player.Character
			if character then
				local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if HumanoidRootPart then
					local Position = HumanoidRootPart.Position
					if
						Position.X < self.Boundaries.xMax
						and Position.X > self.Boundaries.xMin
						and Position.Z > self.Boundaries.zMin
						and Position.Z < self.Boundaries.zMax
					then
						if
							player.Team == Teams:FindFirstChild("Fans")
							or player.Team == Teams:FindFirstChild("OFN Media")
						then
							if self._GameLock then
								player.Team = Teams:FindFirstChild("OFN Media")
							end
						else
							if self.Teams[player.Team.Name] then
								self.Teams[player.Team.Name] += 1
							else
								self.Teams[player.Team.Name] = 1
							end
						end
					end
				end
			end
		end
	end

	task.spawn(function()
		set_boundaries()

		while task.wait() do
			count_players()
		end
	end)

	print("GamelockService Started")
end

function GamelockService:KnitInit()
	Players.PlayerAdded:Connect(function(player)
		local whitelisted = false
		if player:IsInGroup(16519943) then
			if player:GetRankInGroup(16519943) > 1 then
				whitelisted = true
			end
		end

		if not whitelisted and not RunService:IsStudio() then
			player:Kick("Must be ranked in group")
		end
	end)
	print("GamelockService Initialized")
end

return GamelockService
