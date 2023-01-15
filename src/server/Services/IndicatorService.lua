local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Knit = require(ReplicatedStorage.Packages.Knit)

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
		local ChainsService = Knit.GetService("ChainsService")
		local GameService = Knit.GetService("GameService")

		self._Debounce = true

		local positionIndicator = copy_indicator(Position)

		local update_table = {
			ClockRunning = false,
			LastTackle = Position,
		}

		if ChainsService._Direction == 1 then
			update_table["StatYard"] = math.floor(Position - workspace.scrimmage.Position.X) / 3
		else
			update_table["StatYard"] = math.floor(workspace.scrimmage.Position.X - Position) / 3
		end

		GameService:Update(update_table)

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

	print("IndicatorService Started")
end

function IndicatorService:KnitInit()
	print("IndicatorService Initialized")
end

return IndicatorService
