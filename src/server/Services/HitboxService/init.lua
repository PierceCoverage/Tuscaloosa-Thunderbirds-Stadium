local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local HitboxService = Knit.CreateService({
	Name = "HitboxService",
	Client = {
		Block = Knit.CreateSignal(),
	},
	LastTackle = 0,
	Debounce = false,
	PlayerDebounce = {},
})

function HitboxService:Touched(Character1, Character2)
	if self.PlayerDebounce[Character1.Name] or self.PlayerDebounce[Character2.Name] then
		return
	end

	self.PlayerDebounce[Character1.Name] = true
	self.PlayerDebounce[Character2.Name] = true

	task.delay(0.25, function()
		self.PlayerDebounce[Character1.Name] = nil
		self.PlayerDebounce[Character2.Name] = nil
	end)

	local fb = Character1:FindFirstChild("Football")
		or Players:FindFirstChild(Character1.Name).Backpack:FindFirstChild("Football")
		or Character2:FindFirstChild("Football")
		or Players:FindFirstChild(Character2.Name).Backpack:FindFirstChild("Football")

	if fb then
		fb = fb.Handle
		self:Tackle(fb.Position.X, Character1, Character2)
	else
		self:Block(Character1, Character2)
	end
end

function HitboxService:Block(Character1, Character2)
	HitboxService.Client.Block:Fire(
		Players:FindFirstChild(Character1.Name),
		Character2.HumanoidRootPart.CFrame.LookVector
	)
	HitboxService.Client.Block:Fire(
		Players:FindFirstChild(Character2.Name),
		Character1.HumanoidRootPart.CFrame.LookVector
	)
end

function HitboxService:Tackle(Position, Character1, Character2)
	if self.Debounce then
		return
	end

	local IndicatorService = Knit.GetService("IndicatorService")
	local MessageService = Knit.GetService("MessageService")

	self.Debounce = true
	task.delay(4, function()
		self.Debounce = false
	end)

	self.LastTackle = Position

	local distance = (Character1.HumanoidRootPart.Position - Character2.HumanoidRootPart.Position).Magnitude / 3
	distance = math.floor(distance * 100) / 100

	MessageService:Send(
		Players:GetPlayers(),
		("%s tackled %s from %s yards away."):format(Character1.Name, Character2.Name, tostring(distance)),
		"Tackle"
	)

	IndicatorService:Fire(Position)

	Character1.Humanoid.PlatformStand = true
	Character2.Humanoid.PlatformStand = true

	task.delay(2.5, function()
		Character1.Humanoid.PlatformStand = false
		Character2.Humanoid.PlatformStand = false
	end)
end

function HitboxService:KnitStart()
	print("HitboxService Started")
end

function HitboxService:KnitInit()
	local HitboxClass = require(script.Parent.Parent.Classes.HitboxClass)

	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			local Hitbox = HitboxClass.new(character)

			character.Destroying:Connect(function()
				Hitbox:Destroy()
			end)
		end)
	end)

	print("HitboxService Initialized")
end

return HitboxService
