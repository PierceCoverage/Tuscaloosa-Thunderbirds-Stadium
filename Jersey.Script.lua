math.randomseed(tick())

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local IndicatorService = Knit.GetService("IndicatorService")
local MessageService = Knit.GetService("MessageService")
local GameService = Knit.GetService("GameService")

local Player = game.Players:GetPlayerFromCharacter(script.Parent.Parent)
local Hum = script.Parent.Parent.Humanoid
local HRP = script.Parent.Parent.HumanoidRootPart
local StatsEvent = game.ReplicatedStorage:WaitForChild("Stats").Event
local blockDeb = false

local function runDeb()
	blockDeb = true
	task.wait(0.45)
	blockDeb = false
end
local function Message(msg, type)
	MessageService:Send(Players:GetPlayers(), msg, type)
end

function Block(Direction, RootPart)
	if blockDeb then
		return
	end
	local Person = Players:GetPlayerFromCharacter(RootPart.Parent)
	if not Person then
		return
	end
	task.spawn(runDeb)
	ReplicatedStorage.TackleEvent:FireClient(Person, Direction)
end

local debounce = false
local last = os.clock()

local descendants = script.Parent:GetDescendants()

local function hitbox(Part)
	local OtherPlayer = Players:GetPlayerFromCharacter(Part.Parent)

	if OtherPlayer then
		if
			Player.Team
			and (Player.Team.Name == "OFN Media" or Player.Team.Name == "Referee" or Player.Team.Name == "Fans")
		then
			return
		end
		if
			OtherPlayer.Team.Name == "OFN Media"
			or OtherPlayer.Team.Name == "Referee"
			or OtherPlayer.Team.Name == "Fans"
		then
			return
		end
		if Part.Name == "Jersey" and OtherPlayer.Team ~= Player.Team and HRP.Parent:FindFirstChild("Football") then
			-----------------------------------------------------------------------
			-- Range cap for tackle

			local dist = (Vector2.new(Part.Position.X, Part.Position.Z) - Vector2.new(
				HRP.Parent.Jersey.Position.X,
				HRP.Parent.Jersey.Position.Z
			)).Magnitude

			if math.abs(HRP.Orientation.X) < 3 and math.abs(HRP.Orientation.Z) < 3 then
				-- Not Diving
				if dist > 8.1 then -- tackle cap range (2.7 Yards)
					--print("[NO DIVE TACKLE] Possible Lag Tackle of: " .. yard .. " from " .. Player.Name)
					return
				end
			else
				-- Diving
				if dist > 14.4 then -- tackle cap range for dive (4.8 Yards)
					--print("[DIVE TACKLE] Possible Lag Tackle of: " .. yard .. " from " .. Player.Name)
					return
				end
			end

			-----------------------------------------------------------------------

			local position1 = Part.Position
			local position2 = HRP.Parent.Jersey.Position
			local distance = (position1 - position2).magnitude
			local num = distance / 3
			local yards = math.floor(num * 100) / 100
			if debounce == false then
				Message(("%s tackled %s from %i yards away."):format(Player.Name, OtherPlayer.Name, yards), "Tackle")
				ReplicatedStorage.TackleEvent:FireClient(Player, false, true)
				ReplicatedStorage.TackleEvent:FireClient(OtherPlayer, false, true)
				debounce = true
			end
			if not GameService.Values["TackleDebounce"] then
				IndicatorService:Fire(HRP.Parent.Football.Handle.Position.X)
				StatsEvent:Fire("Tackle", OtherPlayer.Name, Player.Name)
				ReplicatedStorage.Stats.YardLine.Value = HRP.Parent.Football.Handle.Position.Z
			end
			_G.autoStop = true
			Part.Parent.Humanoid.PlatformStand = true
			HRP.Parent.Humanoid.PlatformStand = true
			task.wait(1)
			debounce = false
			task.wait(1.5)
			Hum.PlatformStand = false
			Part.Parent.Humanoid.PlatformStand = false
		elseif
			Part.Name == "Jersey"
			and OtherPlayer.TeamColor ~= Player.TeamColor
			and not Part.Parent:FindFirstChild("Football")
			and not script.Parent.Parent:FindFirstChild("Football")
		then
			-------------------------------------------------------------------------
			-- Block range cap
			if blockDeb then
				return
			end
			local dt = os.clock() - last
			if dt >= 1 / 60 then
				last = os.clock()
				-- Range cap on block
				local dist = (Vector2.new(Part.Position.X, Part.Position.Z) - Vector2.new(
					HRP.Parent.Jersey.Position.X,
					HRP.Parent.Jersey.Position.Z
				)).Magnitude

				if math.abs(HRP.Orientation.X) < 3 and math.abs(HRP.Orientation.Z) < 3 then
					-- Not Diving
					if dist > 11.4 then -- Valid block range (3.8 Yards)
						--print("[NO DIVE BLOCK] Possible Lag Block of: " .. yard .. " from " .. Player.Name)
						return
					end
				else
					--Diving
					if dist > 14.4 then -- Valid block range for dive (4.8 Yards)
						--print("[DIVE BLOCK] Possible Lag Block of: " .. yard .. " from " .. Player.Name)
						return
					end
				end
				Block(Part.CFrame.lookVector, HRP)
			else
				last += dt
			end

			-------------------------------------------------------------------------
		end
	end
end

script.Parent.Touched:Connect(hitbox)
