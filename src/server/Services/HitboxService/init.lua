local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local HitboxService = Knit.CreateService({
	Name = "HitboxService",
	Client = {
		Block = Knit.CreateSignal(),
	},
})

function HitboxService:KnitStart()
	print("HitboxService Started")
end

function HitboxService:KnitInit()
	local HitboxClass = require(script.HitboxClass)

	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			local Hitbox = HitboxClass.new(character)

			character.Destroying:Connect(function()
				Hitbox:Destroy()
			end)
		end)
	end)

	print("HitboxService Initialized")
end

return HitboxService
