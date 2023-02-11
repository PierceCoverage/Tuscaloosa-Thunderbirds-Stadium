local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local LiveCharacter = require(script.Parent.Parent.Import.LiveCharacter)

local CharacterService = Knit.CreateService({
	Name = "CharacterService",
	_Controller = {},
})

function CharacterService:KnitStart()
	print("CharacterService Started")
end

function CharacterService:KnitInit()
	Players.PlayerAdded:Connect(function(player)
		self._Controller[player.Name] = LiveCharacter:autoUpdatePlayerAppearance(player)

		player.CharacterAdded:Connect(function(character)
			local Humanoid = character:WaitForChild("Humanoid")
			Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
			Humanoid.HealthDisplayDistance = 0
			Humanoid.NameDisplayDistance = 0
		end)

		player.CharacterAppearanceLoaded:Connect(function(character)
			character.DescendantAdded:Connect(function(descendant)
				if descendant.Name == "Football" and descendant:IsA("Accoutrement") then
					descendant.Name = "FakeFootball"
				end
			end)
		end)

		player:GetPropertyChangedSignal("Team"):Connect(function()
			if not player.Team then
				return
			end

			if player.Team.Name == "HSFL Media" then
				if workspace:FindFirstChild(player.Name) then
					player.Character:Destroy()
				end
			else
				if not workspace:FindFirstChild(player.Name) then
					player:LoadCharacter()
				end
			end
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._Controller[player.Name]:Disconnect()
		self._Controller[player.Name] = nil
	end)

	print("CharacterService Initialized")
end

return CharacterService
