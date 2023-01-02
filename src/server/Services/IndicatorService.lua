local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local IndicatorService = Knit.CreateService({
	Name = "IndicatorService",
	Client = {},
	_OldColor1 = nil,
	_OldColor2 = nil,
	_TackleDebounce = false,
	_Direction = -1,
	DebounceLength = 7,
})

function IndicatorService:Fire(z)
	if not self._TackleDebounce then
		local GameService = Knit.GetService("GameService")
		self._TackleDebounce = true
		local positionIndicator = workspace.scrimmage:Clone()
		positionIndicator.CanCollide = false
		positionIndicator.Parent = workspace
		positionIndicator.Name = "positionIndicator"
		positionIndicator.CFrame = CFrame.new(z, workspace.scrimmage.CFrame.Y, workspace.scrimmage.CFrame.Z)
		positionIndicator.BrickColor = BrickColor.new("Bright red")
		local update_table = { Position = z }

		if self._Direction == 1 then
			update_table["StatYard"] = math.floor(z - workspace.scrimmage.Position.X) / 3
		else
			update_table["StatYard"] = math.floor(workspace.scrimmage.Position.X - z) / 3
		end

		GameService:UpdateValue(update_table)

		task.wait(self.DebounceLength)

		self._TackleDebounce = false

		task.spawn(function()
			while positionIndicator.Transparency < 1 do
				positionIndicator.Transparency += 0.05
				task.wait()
			end
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
					if not oobdebounce then --make custom tackle debounce self.TackleDebounce
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
						OOB_Blocks["OOB Outer Line"].Color = Color3.fromRGB(255, 255, 255)
						OOB_Blocks["Inner OOB Line"].Color = Color3.fromRGB(255, 255, 255)
						oobdebounce = false
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
