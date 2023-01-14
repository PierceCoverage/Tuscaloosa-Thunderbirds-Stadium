local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local BindsController = Knit.CreateController({
	Name = "BindsController",
	Binds = {},
})

function BindsController:ReceiveButtonPress(key)
    local DiveController = Knit.GetController("DiveController")
    local StaminaController = Knit.GetController("StaminaController")
    if key == "Controller_Dive" or key == "Keyboard_Dive" then
        DiveController:Dive()
    elseif key == "Controller_OPDive" or key == "Keyboard_OPDive" then
        DiveController:OPDive()
    elseif key == "Controller_Stamina" or key == "Keyboard_Stamina" then
        StaminaController:StamChange()
    elseif key == "Controller_Handoff" or key == "Keyboard_Handoff" then
        if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") and Players.LocalPlayer.Character:FindFirstChild("Football") then
            Players.LocalPlayer.Character.Football.Handle.RemoteEvent:FireServer({ "x down" })
        end
    elseif key == "Controller_Reach" or key == "Keyboard_Reach" then
        if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") and Players.LocalPlayer.Character:FindFirstChild("Football") then
            Players.LocalPlayer.Character.Football.Handle.RemoteEvent:FireServer({ "c down" })
        end
    end
end

function BindsController:ReceiveButtonRelease(key)
    if key == "Controller_Handoff" or key == "Keyboard_Handoff" then
        if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") and Players.LocalPlayer.Character:FindFirstChild("Football") then
            Players.LocalPlayer.Character.Football.Handle.RemoteEvent:FireServer({ "x up" })
        end
    elseif key == "Controller_Reach" or key == "Keyboard_Reach" then
        if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid") and Players.LocalPlayer.Character:FindFirstChild("Football") then
            Players.LocalPlayer.Character.Football.Handle.RemoteEvent:FireServer({ "c up" })
        end
    end
end

function BindsController:ChangeBind(bindname: string, New: Enum.KeyCode)
    self.Binds[bindname] = New
end

function BindsController:KnitStart()
	--Get binds from a service

	local binds = {} --Point back from a service used to save and load binds

	if binds and binds[1] then --Future: Add functionality to check if new binds were scripted in/are available in the settings
		self.Binds = binds
	else
		self.Binds = require(script.Default)
	end
	print("BindsController Started")
end

function BindsController:KnitInit()
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then
            return
        end

        local key

        for i, v in pairs(self.Binds) do
            if input.KeyCode == v then
                key = i
            end
        end

        if not key then
            return
        end

        self:ReceiveButtonPress(key)
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then
            return
        end
        
        local key

        for i, v in pairs(self.Binds) do
            if input.KeyCode == v then
                key = i
            end
        end

        if not key then
            return
        end

        self:ReceiveButtonRelease(key)
    end)
	print("BindsController Initialized")
end

return BindsController
