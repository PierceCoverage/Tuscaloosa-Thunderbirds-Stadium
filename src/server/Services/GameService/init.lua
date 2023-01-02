local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local GameService = Knit.CreateService({
	Name = "GameService",
	Client = {},
	Values = {},
})

function GameService.Client:Get(Key)
	return GameService.Server.Values[Key]
end

function GameService:UpdateValue(toupdate: table)
    for i, v in pairs(toupdate) do
        self.Values[i] = v
    end
end

function GameService:KnitStart()
	print("GameService Started")
end

function GameService:KnitInit()
	self.Values = require(script.values)
	print("GameService Initialized")
end

return GameService
