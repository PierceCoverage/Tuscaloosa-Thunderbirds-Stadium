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
	local GameService = Knit.GetService("GameService")

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

	local highlights = {}

	LOSPart.Touched:Connect(function(otherPart)
		if GameService.Values.Clock.Running then --check DBLOS
			local HumanoidRootPart = otherPart.Parent:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				local ws = Vector2.new(
					HumanoidRootPart.AssemblyLinearVelocity.X,
					HumanoidRootPart.AssemblyLinearVelocity.Z
				).Magnitude
				local heightSpeed = HumanoidRootPart.AssemblyLinearVelocity.Y
				local check1 = HumanoidRootPart.Orientation.X == 0
				local check2 = HumanoidRootPart.Orientation.Z == 0
				local check4 = heightSpeed > 58.31

				if check1 and check2 then
					if check4 then
						warn(otherPart.Parent.Name, " appears to be JPing!")
					end
				else
					if highlights[otherPart.Parent.Name] then
						return
					end
					highlights[otherPart.Parent.Name] =
						HighlightClass.new(workspace:FindFirstChild(otherPart.Parent.Name), "dblos")
					task.delay(3, function()
						highlights[otherPart.Parent.Name]:Destroy()
					end)
					--DBLOS!
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
