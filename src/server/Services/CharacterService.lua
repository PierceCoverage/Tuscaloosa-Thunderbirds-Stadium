local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local CharacterService = Knit.CreateService {
    Name = "CharacterService",
    JumpPower = 55,
}

function CharacterService:KnitStart()
    print('CharacterService Started')
end

function CharacterService:KnitInit()
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            local Humanoid = character:WaitForChild("Humanoid")
            Humanoid.JumpPower = self.JumpPower
            Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            Humanoid.HealthDisplayDistance = 0
            Humanoid.NameDisplayDistance = math.huge
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
            
            if player.Team.Name == "OFN Media" then
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

    print('CharacterService Initialized')
end

return CharacterService
