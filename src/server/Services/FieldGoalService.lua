local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local FieldGoalService = Knit.CreateService({
	Name = "FieldGoalService",
})

function FieldGoalService:KnitStart()
	print("FieldGoalService Started")
end

function FieldGoalService:KnitInit()
	local Field = workspace:WaitForChild("Field")
	local Walls = Field.Walls
	local Uprights = Field.Uprights
	local name = "Football"

	for i, wall in pairs(Walls:GetChildren()) do
		local debounce = false

		wall.Touched:Connect(function(hit)
			if debounce == false and hit.Name == name then
				debounce = true
				_G.autoStop = true
				debounce = false
			end
		end)
	end

	for _, upright in pairs(Uprights:GetDescendants()) do
		if upright.Name == "Points Ring" then
			local debounce = false

			upright.Touched:Connect(function(hit)
				local MessageService = Knit.GetService("MessageService")
				if debounce == false and hit.Name == name then
					debounce = true
					_G.autoStop = true
					MessageService:Send(Players:GetPlayers(), "Field Goal is Good")
					debounce = false
				end
			end)
		end
	end

	print("FieldGoalService Initialized")
end

return FieldGoalService
