local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local CommandService = Knit.CreateService {
    Name = "CommandService",
    Client = {},
}

function CommandService:KnitStart()
    
    print('CommandService Started')
end

function CommandService:KnitInit()
    
    print('CommandService Initialized')
end

return CommandService
