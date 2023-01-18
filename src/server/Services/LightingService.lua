local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local LightingService = Knit.CreateService {
    Name = "LightingService",
    Client = {
        Update = Knit.CreateSignal(),
    },
}

function LightingService:Update(player, tbl)
    self.Client.Update:Fire(player, tbl)
end

function LightingService:KnitStart()
    
    print('LightingService Started')
end

function LightingService:KnitInit()
    
    print('LightingService Initialized')
end

return LightingService
