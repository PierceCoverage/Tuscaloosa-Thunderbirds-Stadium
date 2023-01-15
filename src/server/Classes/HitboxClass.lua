local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Maid = require(ReplicatedStorage.Packages.maid)

local GameService = Knit.GetService("GameService")
local HitboxService = Knit.GetService("HitboxService")
local IndicatorService = Knit.GetService("IndicatorService")
local MessageService = Knit.GetService("MessageService")

local HitboxClass = {}
HitboxClass.__index = HitboxClass

local function create_part()
	local Part = Instance.new("Part")
	Part.Size = Vector3.new(2, 4, 2) --Set hitbox size
	Part.Transparency = 1
	Part.Massless = true
	Part.Anchored = false
	Part.CanCollide = false
	Part.Name = "Hitbox"
	return Part
end

local function team_check(p1, p2)
	if p1.Team == p2.Team then
		return false
	end

	if p1.Team ~= GameService.Values.Home.Team and p1.Team ~= GameService.Values.Away.Team then
		return false
	end

	if p2.Team ~= GameService.Values.Home.Team and p2.Team ~= GameService.Values.Away.Team then
		return false
	end

	return true
end

local function magnitude_check(j1, j2)
	local players_diving = 0

	local distance = (j1.Position - j2.Position).Magnitude
	if math.abs(j1.Orientation.X) < 3 and math.abs(j1.Orientation.Z) < 3 then
		players_diving += 1
	end

	if math.abs(j2.Orientation.X) < 3 and math.abs(j2.Orientation.Z) < 3 then
		players_diving += 1
	end

	if players_diving == 2 then
		--Two Players Diving
		if distance > 7 * 3 then --5 Yards
			return false
		end
	elseif players_diving == 1 then
		--One Player Diving
		if distance > 6 * 3 then --4 Yards
			return false
		end
	else
		--No Players Diving
		if distance > 5 * 3 then --3 Yards
			return false
		end
	end

	return true
end

function HitboxClass.new(character): table --returns a Hitbox
	assert(character and character:FindFirstChild("Humanoid"), "Character must be provided and be a real player.")

	local self = setmetatable({}, HitboxClass)
	self.Hitbox = create_part()
	self._Maid = Maid.new()
	self._Character = character
	self._Player = Players:GetPlayerFromCharacter(character)
	self.Debounce = false

	local Weld = Instance.new("Weld")

	Weld.Part0 = character:WaitForChild("HumanoidRootPart")
	Weld.Part1 = self.Hitbox

	Weld.Parent = self.Hitbox

	self.Hitbox.Parent = character

	self._Maid:GiveTask(self.Hitbox.Touched:Connect(function(Part)
		if self.Debounce then
			return
		end

		if Part.Name == "Hitbox" then
			--if magnitude_check(self.Hitbox, Part) then
			if Part.Parent:FindFirstChild("Humanoid") then
				local OtherPlayer = Players:GetPlayerFromCharacter(Part.Parent)

				if team_check(self._Player, OtherPlayer) then
					HitboxService:Touched(character, Part.Parent)
				end
			end
			--end
		end
	end))

	self._Maid:GiveTask(self.Hitbox.Destroying:Connect(function()
		self:Destroy()
	end))

	return self
end

function HitboxClass:Destroy()
	self._Maid:Destroy()
	self = nil
end

return HitboxClass
