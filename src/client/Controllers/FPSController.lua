local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local FPSController = Knit.CreateController { Name = "FPSController" }

function FPSController:KnitStart()

    print('FPSController Started')
end

function FPSController:KnitInit()
    task.spawn(function()
        local UIController = Knit.GetController("UIController")

        local Start = tick()
        local Count = 0
        RunService.Heartbeat:Connect(function(deltaTime)
            local current_tick = tick()
            if current_tick-Start >= 1 then
                UIController:SetFPS(Count)
                Count = 0
                Start = current_tick
            else
                Count += 1
            end
        end)
    end)
    
    print('FPSController Initialized')
end

return FPSController
