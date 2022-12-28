local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local CharacterService = Knit.CreateService {
    Name = "CharacterService",
    Client = {},
}

function CharacterService:KnitStart()
    print('CharacterService Started')
end

function CharacterService:KnitInit()
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            local Humanoid = character:WaitForChild("Humanoid")
            Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            Humanoid.HealthDisplayDistance = 0
            Humanoid.NameDisplayDistance = math.huge
        end)

        player:GetPropertyChangedSignal("Team"):Connect(function()
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
