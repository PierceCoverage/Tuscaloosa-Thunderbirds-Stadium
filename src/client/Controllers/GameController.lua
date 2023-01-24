local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local GameController = Knit.CreateController { 
    Name = "GameController",
    Values = {}
}

function GameController:KnitStart()
    local GameService = Knit.GetService("GameService")

    task.spawn(function()
        self.Values = GameService:Get()
    end)

    GameService.Send:Connect(function(v)
		self.Values = v
	end)

    print('GameController Started')
end

function GameController:KnitInit()
    
    print('GameController Initialized')
end


return GameController
