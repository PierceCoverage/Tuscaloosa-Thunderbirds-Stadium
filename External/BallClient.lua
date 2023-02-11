-- Services --
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")
-- Variables --
local Player = game.Players.LocalPlayer
repeat
	wait()
until Player and Player.Character and Player.CharacterAppearanceLoaded
local Mouse = Player:GetMouse()
local Character = Player.Character
local RemoteEvent = Character:FindFirstChild("Football"):FindFirstChild("RemoteEvent")
local KeyDown = nil
local LockModule = require(ReplicatedFirst:WaitForChild("Modules"):WaitForChild("_Lock"))
-- Body Parts --
local Head, Torso = Character:WaitForChild("Head"), Character:WaitForChild("Torso")
local Humanoid, HumanoidRootPart = Character:WaitForChild("Humanoid"), Character:WaitForChild("HumanoidRootPart")
-- Values --
local Power = 60
local CanUse = false
local InQB = false
-- Animations --
local Ball = script.Parent.Hitboxes.Jersey.Animations.Ball
local QBAnimation = Character.Humanoid:LoadAnimation(Ball.QB_Idle)
local QBThrow = Character.Humanoid:LoadAnimation(Ball.QB_Throw)
local QBRunAnimation = Character.Humanoid:LoadAnimation(Ball.QB_OnTheRun)
---

-- Functions --
local connection

function QBMode(Boolean)
	if Boolean then
		Character.CharacterInformation.InQBMode.Value = true
		LockModule:Mode(true)
        
		connection = Humanoid.Running:Connect(function(Speed)
			if Speed == 0 and not InQB then
				InQB = true
				local Moved = false
				-- Anims --
				if not Moved then
					QBAnimation:Play()
				end
				Humanoid.Running:Wait()
				Moved = true
				QBAnimation:Stop()
				InQB = false
			end
		end)
	else
		Character.CharacterInformation.InQBMode.Value = false
		InQB = false
		LockModule:Mode(false)
		QBAnimation:Stop()
		if connection then
			connection:Disconnect()
		end
	end
end
--
function ClearUis()
	local AppearenceInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	-- Goals --
	local BarGoal = { Transparency = 1 }
	local MeterGoal = { Transparency = 1 }
	local BorderGoal = { Size = UDim2.new(0.7, 0, 0.79, 0), Transparency = 1 }
	local TextGoal = { Size = UDim2.new(0.7, 0, 0.7, 0), TextTransparency = 1 }
	-- Play Tween --
	local BarTween = TweenService:Create(
		HumanoidRootPart:FindFirstChild("PowerBar")
			:FindFirstChild("Border")
			:FindFirstChild("Meter")
			:FindFirstChild("Bar"),
		AppearenceInfo,
		BarGoal
	)
	local MeterTween = TweenService:Create(
		HumanoidRootPart:FindFirstChild("PowerBar"):FindFirstChild("Border"):FindFirstChild("Meter"),
		AppearenceInfo,
		MeterGoal
	)
	local BorderTween = TweenService:Create(
		HumanoidRootPart:FindFirstChild("PowerBar"):FindFirstChild("Border"),
		AppearenceInfo,
		BorderGoal
	)
	local TextTween = TweenService:Create(
		HumanoidRootPart:FindFirstChild("PowerText"):FindFirstChild("Power"),
		AppearenceInfo,
		TextGoal
	)
	--
	BarTween:Play()
	MeterTween:Play()
	BorderTween:Play()
	TextTween:Play()
	-- Destroy --
	TextTween.Completed:Connect(function()
		HumanoidRootPart:FindFirstChild("PowerText"):Destroy()
		HumanoidRootPart:FindFirstChild("PowerBar"):Destroy()
	end)
end
--
function LoadUis()
	local AppearenceInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	-- Goals --
	local BarGoal = { Transparency = 0 }
	local MeterGoal = { Transparency = 0.7 }
	local BorderGoal = { Size = UDim2.new(0.9, 0, 0.99, 0), Transparency = 0.3 }
	local TextGoal = { Size = UDim2.new(0.9, 0, 0.99, 0), TextTransparency = 0 }
	-- Play Tween --
	local BarTween = TweenService:Create(
		HumanoidRootPart:FindFirstChild("PowerBar")
			:FindFirstChild("Border")
			:FindFirstChild("Meter")
			:FindFirstChild("Bar"),
		AppearenceInfo,
		BarGoal
	):Play()
	local MeterTween = TweenService:Create(
		HumanoidRootPart:FindFirstChild("PowerBar"):FindFirstChild("Border"):FindFirstChild("Meter"),
		AppearenceInfo,
		MeterGoal
	):Play()
	local BorderTween =
		TweenService
			:Create(HumanoidRootPart:FindFirstChild("PowerBar"):FindFirstChild("Border"), AppearenceInfo, BorderGoal)
			:Play()
	local TextTween =
		TweenService
			:Create(HumanoidRootPart:FindFirstChild("PowerText"):FindFirstChild("Power"), AppearenceInfo, TextGoal)
			:Play()
end
--
function UpdatePower()
	local BarInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	-- Goals --
	local BarGoal = { Size = UDim2.new(1, 0, Power / 100, 0) }
	local BarTween = TweenService:Create(
		Character:FindFirstChild("HumanoidRootPart")
			:FindFirstChild("PowerBar")
			:FindFirstChild("Border")
			:FindFirstChild("Meter")
			:FindFirstChild("Bar"),
		BarInfo,
		BarGoal
	):Play()
	-- Update Text --
	Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("PowerText"):FindFirstChild("Power").Text = "<i>"
		.. Power
		.. "</i>"
end
--
function Equip()
	LoadUis()
	--
	Power = 60
	UpdatePower()
	-- Throw --
	if UserInputService.MouseEnabled then
		UserInputService.InputBegan:Connect(function(Input, Typing)
			if Typing then
				return
			end
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				if
					Character:FindFirstChild("Football")
					and Character.CharacterInformation.InQBMode.Value == true
					and Humanoid
					and Humanoid.Health > 0
					and not Humanoid.PlatformStand
				then
					local Target = Mouse.Hit.Position
					if Head then
						ClearUis()
						LockModule:Mode(false)
						local Start = Head.CFrame.Position
						QBAnimation:Stop()
						QBThrow:Play()
						wait(0.3)
						RemoteEvent:FireServer({ "Throw", Start, Target, Power })
						QBAnimation:Stop()
						Character.CharacterInformation.InQBMode.Value = false
					end
				end
			end
		end)
	end
	-- Binds --
	UserInputService.InputBegan:Connect(function(Input, Busy)
		if Busy then
			return
		end
		if Input.UserInputType == Enum.UserInputType.Keyboard then
			local Key = Input.KeyCode
			-- Power Binds --
			if Key == Enum.KeyCode.R then
				if Character:FindFirstChild("Football") then
					if KeyDown then
						return
					end
					KeyDown = Key
					while KeyDown and KeyDown == Key do
						Power = Power < 100 and Power + 5 or 100
						UpdatePower()
						if Power >= 100 then
							break
						end
						wait(1 / 5)
					end
					UpdatePower()
				end
				--
			elseif Key == Enum.KeyCode.F then
				if Character:FindFirstChild("Football") then
					if KeyDown then
						return
					end
					KeyDown = Key
					while KeyDown and KeyDown == Key do
						Power = Power > 25 and Power - 5 or 25
						UpdatePower()
						if Power <= 25 then
							break
						end
						wait(1 / 5)
					end
					UpdatePower()
				end
				-- Addons --
			elseif Key == Enum.KeyCode.Q then
				if Character:FindFirstChild("Football") then
					if Character.CharacterInformation.InQBMode.Value then
						QBMode(false)
					else
						QBMode(true)
					end
				end
			elseif Key == Enum.KeyCode.X then
				if Character:FindFirstChild("Football") then
					RemoteEvent:FireServer({ "HandBall", "On" })
				end
			end
		end
	end)
	--
	UserInputService.InputEnded:Connect(function(Input, Busy)
		if Busy then
			return
		end
		if Input.UserInputType == Enum.UserInputType.Keyboard then
			local Key = Input.KeyCode
			if Key == Enum.KeyCode.R then
				if KeyDown == Key then
					KeyDown = nil
				end
			elseif Key == Enum.KeyCode.F then
				if KeyDown == Key then
					KeyDown = nil
				end
			elseif Key == Enum.KeyCode.X then
				if Character:FindFirstChild("Football") then
					RemoteEvent:FireServer({ "HandBall", "Off" })
				end
			end
		end
	end)
end
---

-- Presets --
Equip()
---

-- Main --
Character.ChildRemoved:Connect(function(Child)
	if Child.Name == "Football" then
		ClearUis()
	end
end)
--
Character.ChildAdded:Connect(function(Child)
	if Child.Name == "Football" then
		Equip()
	end
end)
--
--RemoteEvent.OnClientEvent:Connect(function()

--end)
---

-- Finalize --
print(Character.Name .. "'s " .. script.Name .. " Has Loaded.")
---
