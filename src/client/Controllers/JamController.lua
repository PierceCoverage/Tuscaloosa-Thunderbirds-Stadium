local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local JamController = Knit.CreateController { Name = "JamController" }

function JamController:KnitStart()
    local HitboxService = Knit.GetService("HitboxService")
    HitboxService.Block:Connect(function(direction)
        if not Players.LocalPlayer.Character then
            return
        end

        local HumanoidRootPart = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            return
        end

		if not HumanoidRootPart:FindFirstChild("Push") then
			local Push = Instance.new("BodyVelocity")
			Push.Name = "Push"
			Push.MaxForce = Vector3.new(1e7, 1e7, 1e7)
			Push.P = 125
			Push.Velocity = direction * 13.5 --9
			Push.Parent = HumanoidRootPart

			Push:GetPropertyChangedSignal("Velocity"):Connect(function()
				Push.Velocity = direction * 13.5
			end)

			task.delay(0.25, function()
				Push:Destroy()
			end)
		end
    end)
    print('JamController Started')
end

function JamController:KnitInit()

    print('JamController Initialized')
end

return JamController
