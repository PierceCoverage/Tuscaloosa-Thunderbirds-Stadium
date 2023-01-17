local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local HighlightClass = require(script.Parent.Parent.Classes.HighlightClass)

local IndicatorService = Knit.CreateService({
	Name = "IndicatorService",
	_OldColor1 = nil,
	_OldColor2 = nil,
	_Debounce = false,
	DebounceLength = 7,
})

local function copy_indicator(Position)
	local position_indicator = workspace.scrimmage:Clone()
	position_indicator.CanCollide = false
	position_indicator.Parent = workspace
	position_indicator.Name = "positionIndicator"
	position_indicator.CFrame = CFrame.new(Position, workspace.scrimmage.CFrame.Y, workspace.scrimmage.CFrame.Z)
	position_indicator.BrickColor = BrickColor.new("Bright red")

	return position_indicator
end

function IndicatorService:Fire(Position)
	if not self._Debounce then
		local GameService = Knit.GetService("GameService")

		self._Debounce = true

		local positionIndicator = copy_indicator(Position)

		GameService:Update({
			ClockRunning = false,
			LastTackle = Position,
		})

		task.delay(self.DebounceLength, function()
			self._Debounce = false
			local tInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
			local goal = { Transparency = 1 }

			local tween = TweenService:Create(positionIndicator, tInfo, goal)
			tween:Play()
			tween.Completed:Wait()
			positionIndicator:Destroy()
		end)
	end
end

function IndicatorService:KnitStart()
	local ChatMessageService = Knit.GetService("ChatMessageService")
	local DBLOSService = Knit.GetService("DBLOSService")
	local StatsService = Knit.GetService("StatsService")

	local Field = workspace.Field
	local OOB_Blocks = Field["OOB Blocks"]
	local oobdebounce = false

	for i, v in pairs(OOB_Blocks:GetChildren()) do
		if v.Name == "OOBEvent" then
			v.Touched:Connect(function(part)
				if
					part.Parent
					and part.Parent:FindFirstChild("Humanoid")
					and part.Parent:FindFirstChild("Football")
				then --check part heirarchy
					if not oobdebounce then --make custom debounce self._Debounce
						oobdebounce = true
						if
							OOB_Blocks["OOB Outer Line"].Color ~= Color3.fromRGB(255, 0, 0)
							and OOB_Blocks["Inner OOB Line"].Color ~= Color3.fromRGB(255, 0, 0)
						then
							self._OldColor1 = OOB_Blocks["OOB Outer Line"].Color
							self._OldColor2 = OOB_Blocks["Inner OOB Line"].Color
						end

						OOB_Blocks["OOB Outer Line"].Color = Color3.fromRGB(255, 0, 0)
						OOB_Blocks["Inner OOB Line"].Color = Color3.fromRGB(255, 0, 0)

						ReplicatedStorage.Stats.Event:Fire("OOB", true, part.Parent)
						_G.autoStop = true ----------- CAN EDIT OUT, ADDED 6/13/21 -----------
						if part.Name == "Handle" then
							self:Fire(part.Position.X)
						else
							self:Fire(part.Parent.Football.Handle.Position.X)
						end
						task.delay(self.DebounceLength, function()
							OOB_Blocks["OOB Outer Line"].Color = Color3.fromRGB(255, 255, 255)
							OOB_Blocks["Inner OOB Line"].Color = Color3.fromRGB(255, 255, 255)
							oobdebounce = false
						end)
					end
				end
			end)
		end
	end

	local LOSPart = Instance.new("Part")
	LOSPart.Size = Vector3.new(workspace.scrimmage.Size.X, 60, workspace.scrimmage.Size.Z)
	LOSPart.Transparency = 1
	LOSPart.CanCollide = false
	LOSPart.Anchored = true
	LOSPart.Name = "LOSPart"
	LOSPart.Parent = workspace

	RunService.Heartbeat:Connect(function(deltaTime)
		LOSPart.CFrame = workspace.scrimmage.CFrame
	end)

	local fs = {}

	LOSPart.Touched:Connect(function(otherPart)
		if otherPart.Name == "HumanoidRootPart" then
			if DBLOSService.Diving[otherPart.Parent.Name] and false then
				if DBLOSService.Highlight[otherPart.Parent.Name] then
					return
				end

				for i, v in pairs(Players:GetPlayers()) do
					task.spawn(function()
						ChatMessageService:Send(v, otherPart.Parent.Name .. " dove behind the LOS!")
					end)
				end

				DBLOSService.Highlight[otherPart.Parent.Name] =
					HighlightClass.new(workspace:FindFirstChild(otherPart.Parent.Name), "dblos")
				task.delay(5, function()
					DBLOSService.Highlight[otherPart.Parent.Name]:Destroy()
					DBLOSService.Highlight[otherPart.Parent.Name] = nil
				end)
				--DBLOS!
			end

			if StatsService.Presnap then
				if fs[otherPart.Parent.Name] then
					return
				end

				if
					otherPart.Parent:FindFirstChild("Football")
					or Players:GetPlayerFromCharacter(otherPart.Parent).Backpack:FindFirstChild("Football")
				then
					return
				end

				for i, v in pairs(Players:GetPlayers()) do
					task.spawn(function()
						ChatMessageService:Send(v, otherPart.Parent.Name .. " touched the LOS!")
					end)
				end

				fs[otherPart.Parent.Name] = HighlightClass.new(workspace:FindFirstChild(otherPart.Parent.Name), "fs")
				task.delay(5, function()
					fs[otherPart.Parent.Name]:Destroy()
					fs[otherPart.Parent.Name] = nil
				end)
			end
		end
	end)

	task.spawn(function()
		while task.wait() do
			for i, v in pairs(Players:GetPlayers()) do
				if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
					local check1 = v.Character.HumanoidRootPart.Orientation.X == 0
					local check2 = v.Character.HumanoidRootPart.Orientation.Z == 0
					local heightSpeed = v.Character.HumanoidRootPart.AssemblyLinearVelocity.Y
					local check4 = heightSpeed > 57
					if check1 and check2 and check4 then
						warn(v.Name, "(" .. heightSpeed .. "): appears to be JPing!")
						if Players:FindFirstChild("Ethan_Waike") then
							ChatMessageService:Send(
								Players.Ethan_Waike,
								v.Name .. " (" .. heightSpeed .. "): appears to be JPing!"
							)
						end
					end
				end
			end
		end
	end)

	print("IndicatorService Started")
end

function IndicatorService:KnitInit()
	print("IndicatorService Initialized")
end

return IndicatorService
