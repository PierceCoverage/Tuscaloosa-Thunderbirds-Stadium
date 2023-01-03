local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerCountService = Knit.CreateService({
	Name = "PlayerCountService",
	Client = {
		Count = Knit.CreateSignal(),
	},
})

function PlayerCountService:KnitStart()
	local GameService = Knit.GetService("GameService")

	local Field = workspace.Field["Field Grass"].FieldSize

	local xMax = (Field.Position.X + (Field.Size.X / 2) + 30) + 6
	local xMin = (Field.Position.X - (Field.Size.X / 2) - 30) - 6
	local zMin = (Field.Position.Z - (Field.Size.Z / 2)) - 6
	local zMax = (Field.Position.Z + (Field.Size.Z / 2)) + 6

	local function CountPlayers()
		local Home = GameService.Values.Home.Team
		local Away = GameService.Values.Away.Team
		local homeCounter = 0
		local awayCounter = 0

		for _, player in pairs(Home:GetPlayers()) do
			local Character = player.Character
			local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil

			if not Character or not HumanoidRootPart then
				continue
			end

			local Position = HumanoidRootPart.Position

			if Position.X < xMax and Position.X > xMin and Position.Z > zMin and Position.Z < zMax then
				homeCounter += 1
			end
		end

		for _, player in pairs(Away:GetPlayers()) do
			local Character = player.Character
			local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil

			if not Character or not HumanoidRootPart then
				continue
			end

			local Position = HumanoidRootPart.Position

			if Position.X < xMax and Position.X > xMin and Position.Z > zMin and Position.Z < zMax then
				awayCounter += 1
			end
		end

		return homeCounter, awayCounter
	end

	task.spawn(function()
		while task.wait(1) do
			local H, A = CountPlayers()
			self.Client.Count:FireAll(H, A)
		end
	end)

	print("PlayerCountService Started")
end

function PlayerCountService:KnitInit()
	print("PlayerCountService Initialized")
end

return PlayerCountService
