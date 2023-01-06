local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local DiveController = Knit.CreateController({
	Name = "DiveController",
	Diving = false,
	DivingCooldown = false,
	Character = nil,
	JumpDeb = false,
	CanJump = true,
	UI = nil,
})

function DiveController:LoadDiveCooldown()
	local SG = Instance.new("ScreenGui")
	local DBG = Instance.new("Frame", SG)
	local DBG2 = Instance.new("Frame", DBG)
	local DiveBar = Instance.new("Frame", DBG2)

	DBG.Name = "Dive_Bar"
	DBG.Size = UDim2.new(0, 270, 0, 15)
	DBG.Style = Enum.FrameStyle.Custom
	DBG.Position = UDim2.new(0, 3, 1, -40)
	DBG.BackgroundTransparency = 0.5
	DBG.BackgroundColor3 = Color3.new(50 / 255, 50 / 255, 50 / 255)
	DBG.BorderSizePixel = 0

	DBG2.Name = "DBG2"
	DBG2.Size = UDim2.new(1, -10, 1, -10)
	DBG2.Style = Enum.FrameStyle.Custom
	DBG2.Position = UDim2.new(0, 5, 0, 5)
	DBG2.BackgroundTransparency = 1
	DBG2.BackgroundColor3 = Color3.new(50 / 255, 50 / 255, 50 / 255)
	DBG2.BorderSizePixel = 0

	DiveBar.Name = "DiveBar"
	DiveBar.Position = UDim2.new(0, 0, 0, 0)
	DiveBar.BorderSizePixel = 0
	DiveBar.Size = UDim2.new(1, 0, 1, 0)
	DiveBar.BackgroundColor3 = Color3.new(1, 1, 1)
	DiveBar.Position = UDim2.new(0, 0, 0, 0)

	self.UI = SG
	SG.Parent = Players.LocalPlayer.PlayerGui
end

function DiveController:ShowDiveCooldown()
	local tick_rn = tick()
	local diveCooldownTime = 4
	local DiveBar = self.UI.Dive_Bar.DBG2.DiveBar
	DiveBar.BackgroundColor3 = Color3.new(1, 0, 0)

	while self.DivingCooldown do
		local scale = 1 - (diveCooldownTime - (tick() - tick_rn)) / diveCooldownTime
		scale = math.min(1, scale)
		DiveBar.Size = UDim2.new(scale, 0, 1, 0)
		if scale > 0.99 then
			DiveBar.BackgroundColor3 = Color3.new(1, 1, 1)
		end
		task.wait()
	end
end

function DiveController:CreateBodyGyro(GoalCFrame)
	self.Diving = true
	self.DivingCooldown = true
	task.spawn(function()
		self:ShowDiveCooldown()
	end)
	local bg = Instance.new("BodyGyro")
	bg.CFrame = GoalCFrame
	bg.MaxTorque = Vector3.new(999999, 999999, 999999)
	bg.Parent = self.Character:WaitForChild("HumanoidRootPart")
	self.Character.HumanoidRootPart.Velocity = Vector3.new(0, 1, 0)
		+ self.Character.HumanoidRootPart.CFrame.LookVector * 2 * self.Character.Humanoid.WalkSpeed
	self.Character.HumanoidRootPart.CFrame = GoalCFrame
	self.Character.Humanoid.PlatformStand = true
	task.delay(1, function()
		self.Character.HumanoidRootPart.Velocity = Vector3.new()
		if bg then
			bg:Destroy()
		end
	end)
	task.delay(4, function()
		--print("Dive off cooldown")
		self.DivingCooldown = false
		self.Character.Humanoid.PlatformStand = false
		--Humanoid.AutoRotate = true
	end)
end

local running = false
function DiveController:JumpDeb()
	if not running then
		running = true
		self.CanJump = false
		self.tick_rn = tick()
		while tick() - self.tick_rn < 1 do
			task.wait()
		end
		self.CanJump = true
		running = false
	end
end

function DiveController:HasBall()
	if self.Character:FindFirstChild("Football") or Players.LocalPlayer.Backpack:FindFirstChild("Football") then
		return true
	end

	return false
end

function DiveController:OPDive()
	if self:HasBall() then
		if self.Character.Humanoid.PlatformStand and self.CanJump then -- Tackled
			--print("Backspace get up")
			task.spawn(function()
				self:JumpDeb()
			end)
			self.Diving = false
			self.Character.Humanoid.PlatformStand = false
			self.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			--Humanoid.AutoRotate = true
		end
	else
		if not self.DivingCooldown and not self.Character.Humanoid.PlatformStand then -- e or backspaced pressed when dive is off cooldown
			if self.CanJump then -- backspace pressed
				--print("backspace dive")
				task.spawn(function()
					self:JumpDeb()
				end)
				self.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				self:CreateBodyGyro(
					self.Character.HumanoidRootPart.CFrame * CFrame.new(0, -0.5, 0) * CFrame.Angles(-math.pi / 2, 0, 0)
				)
			elseif not self.CanJump then -- space backspace
				--print("space backspace")
				self:CreateBodyGyro(
					self.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0) * CFrame.Angles(-math.pi / 2, 0, 0)
				)
			end
		elseif self.CanJump and self.Character.Humanoid.PlatformStand then -- e or backspace pressed when dive is on cooldown. Add "and Backspace" to condition to remove e + e interaction
			--print("Backspace get up")
			task.spawn(function()
				self:JumpDeb()
			end)
			if self.Character.HumanoidRootPart:FindFirstChild("BodyGyro") then
				self.Character.HumanoidRootPart.BodyGyro:Destroy()
			end
			self.Diving = false
			self.Character.Humanoid.PlatformStand = false
			self.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			--Humanoid.AutoRotate = true
		end
	end
end

function DiveController:Dive()
	if self:HasBall() then
		if self.Character.Humanoid.PlatformStand and self.CanJump then -- Tackled
			--print("Backspace get up")
			task.spawn(function()
				self:JumpDeb()
			end)
			self.Diving = false
			self.Character.Humanoid.PlatformStand = false
			self.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			--Humanoid.AutoRotate = true
		end
	else
		if not self.DivingCooldown and not self.Character.Humanoid.PlatformStand then -- e or backspaced pressed when dive is off cooldown
			--print("e dive")
			self:CreateBodyGyro(
				self.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0) * CFrame.Angles(-math.pi / 2, 0, 0)
			)
		elseif self.CanJump and self.Character.Humanoid.PlatformStand then -- e or backspace pressed when dive is on cooldown. Add "and Backspace" to condition to remove e + e interaction
			--print("Backspace get up")
			task.spawn(function()
				self:JumpDeb()
			end)
			if self.Character.HumanoidRootPart:FindFirstChild("BodyGyro") then
				self.Character.HumanoidRootPart.BodyGyro:Destroy()
			end
			self.Diving = false
			self.Character.Humanoid.PlatformStand = false
			self.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			--Humanoid.AutoRotate = true
		end
	end
end

function DiveController:KnitStart()
	ContextActionService:UnbindAction("EnableKeyboardUINavigation")

	print("DiveController Started")
end

function DiveController:KnitInit()
	local function onCharacterAdded(character)
		self.Character = character

		local Humanoid = character:WaitForChild("Humanoid")
		self:LoadDiveCooldown()

		Humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
			if Humanoid.Jump then
				if self.CanJump then
					if self.Diving then
						--print("Space get up")
						task.spawn(function()
							self:JumpDeb()
						end)
						if character.HumanoidRootPart:FindFirstChild("BodyGyro") then
							character.HumanoidRootPart.BodyGyro:Destroy()
						end
						self.Diving = false
						Humanoid.PlatformStand = false
						Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
						--Humanoid.AutoRotate = true
					else --not Diving
						if Humanoid.PlatformStand then -- Tackled
							--print("Tackled get up")
							task.spawn(function()
								self:JumpDeb()
							end)
							Humanoid.PlatformStand = false
							Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
							--Humanoid.AutoRotate = true
						else
							--print("Jump")
							task.spawn(function()
								self:JumpDeb()
							end)
							--Massless jump
							for i = 1, #character:GetDescendants() do
								if character:GetDescendants()[i]:IsA("BasePart") then
									character:GetDescendants()[i].Massless = true
								end
							end
							Humanoid.Jump = true
							task.wait()
							for i = 1, #character:GetDescendants() do
								if
									character:GetDescendants()[i]:IsA("BasePart")
									and character:GetDescendants()[i].Name ~= "Jersey"
								then
									character:GetDescendants()[i].Massless = false
								end
							end
						end
					end
				else
					Humanoid.Jump = false
				end
			end
		end)
	end

	if Players.LocalPlayer and Players.LocalPlayer.Character then
		onCharacterAdded(Players.LocalPlayer.Character)
	end
	Players.LocalPlayer.CharacterAdded:Connect(function(character)
		onCharacterAdded(character)
	end)

	print("DiveController Initialized")
end

return DiveController
