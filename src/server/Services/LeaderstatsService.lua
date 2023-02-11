local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local LeaderstatsService = Knit.CreateService({
	Name = "LeaderstatsService",
})

function LeaderstatsService:KnitStart() --Can yield
	print("LeaderstatsService Started")
end

function LeaderstatsService:KnitInit() --No yield
	local function create_leaderstats(player: Player): Model
		local leaderstats = Instance.new("Model")
		local rank = Instance.new("StringValue", leaderstats)

		leaderstats.Name = "leaderstats"

		rank.Name = "Rank"
		rank.Value = "..."

		leaderstats.Parent = player

		return leaderstats
	end

	Players.PlayerAdded:Connect(function(player)
		local leaderstats = create_leaderstats(player)
		leaderstats.Rank.Value = player:GetRoleInGroup(16495631)
	end)

	print("LeaderstatsService Initialized")
end

return LeaderstatsService
