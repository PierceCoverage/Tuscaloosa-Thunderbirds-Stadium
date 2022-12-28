local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PingService = Knit.CreateService {
    Name = "PingService",
    Client = {},
}

function PingService.Client:Ping(player: Player)
    return
end

function PingService:KnitStart()
    
    print('PingService Started')
end

function PingService:KnitInit()
    
    print('PingService Initialized')
end

return PingService
