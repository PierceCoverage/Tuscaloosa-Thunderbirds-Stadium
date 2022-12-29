local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local StaminaController = Knit.CreateController({
	Name = "StaminaController",
	SprintSpeed = 18,
	WalkSpeed = 14,
	MaxStam = 250,
	CurStam = 250,
	Running = false,
	Character = nil,
	stamdebounce = false,
})

local SG = Instance.new("ScreenGui")
local BG = Instance.new("Frame", SG)
local BG2 = Instance.new("Frame", BG)
local Bar = Instance.new("Frame", BG2)
local Text = Instance.new("TextLabel", BG)

function StaminaController:LoadStaminaGui()
	SG.Name = "Stamina"
	BG.Size = UDim2.new(0, 270, 0, 30)
	BG.Style = Enum.FrameStyle.Custom
	BG.Position = UDim2.new(0, 3, 1, -75)
	BG.BackgroundTransparency = 0.5
	BG.BackgroundColor3 = Color3.new(50 / 255, 50 / 255, 50 / 255)
	BG.BorderSizePixel = 0
	BG2.Size = UDim2.new(1, -10, 1, -10)
	BG2.Style = Enum.FrameStyle.Custom
	BG2.Position = UDim2.new(0, 5, 0, 5)
	BG2.BackgroundTransparency = 1
	BG2.BackgroundColor3 = Color3.new(50 / 255, 50 / 255, 50 / 255)
	BG2.BorderSizePixel = 0
	Bar.Position = UDim2.new(0, 0, 0, 0)
	Bar.BorderSizePixel = 0
	Text.Size = UDim2.new(0, 270, 0, 30)
	Text.BackgroundTransparency = 1
	Text.TextColor3 = Color3.new(1, 1, 1)
	Text.Text = "Stamina"
	Text.BorderSizePixel = 0
	Text.Font = Enum.Font.SourceSansBold
	Text.TextSize = 20
	Bar.Size = UDim2.new(self.CurStam / self.MaxStam, 0, 1, 0)
	Bar.BackgroundColor3 = Color3.new(1 - self.CurStam / self.MaxStam, self.CurStam / self.MaxStam, 0)
	Bar.Position = UDim2.new(0, 0, 0, 0)
	SG.Parent = Players.LocalPlayer.PlayerGui
end

function StaminaController:StaminaRegen()
	if self.Running then
		while self.Running and self.CurStam > 0 do
			--Sprinting
			wait()
			self.CurStam = self.CurStam > 0 and self.CurStam - 1 or 0
			Bar.Size = UDim2.new(self.CurStam / self.MaxStam, 0, 1, 0)
			Bar.BackgroundColor3 = Color3.new(1 - self.CurStam / self.MaxStam, self.CurStam / self.MaxStam, 0)
		end
		self.Running = false
		self.Character.Humanoid.WalkSpeed = 14
		self:StaminaRegen()
	else
		self.Regening = true
		while not self.Running do
			--Regening
			wait()
			self.CurStam = self.CurStam < self.MaxStam and self.CurStam + 0.25 or self.MaxStam
			Bar.Size = UDim2.new(self.CurStam / self.MaxStam, 0, 1, 0)
			Bar.BackgroundColor3 = Color3.new(1 - self.CurStam / self.MaxStam, self.CurStam / self.MaxStam, 0)
		end
		self.Regening = false
	end
end

function StaminaController:StamChange()
	if self.Character.Humanoid.WalkSpeed == 0 then
		return
	end
	if self.stamdebounce == false then
		self.stamdebounce = true
		if not self.Running then
			self.Running = true
			self.Character.Humanoid.WalkSpeed = 18
			task.spawn(function()
				self:StaminaRegen()
			end)
			task.wait(0.1)
			self.stamdebounce = false
		else
			self.Running = false
			self.Character.Humanoid.WalkSpeed = 14
			task.spawn(function()
				self:StaminaRegen()
			end)
			task.wait(0.1)
			self.stamdebounce = false
		end
	end
end

function StaminaController:KnitStart()
	print("StaminaController Started")
end

function StaminaController:KnitInit()
	Players.LocalPlayer.CharacterAdded:Connect(function(character)
		self.Character = character

		character:WaitForChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			character.Humanoid.WalkSpeed = self.Running and self.SprintSpeed or self.WalkSpeed
		end)

		self:LoadStaminaGui()
	end)
	print("StaminaController Initialized")
end

return StaminaController
