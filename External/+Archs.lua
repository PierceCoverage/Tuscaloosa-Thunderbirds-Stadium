-- Services --
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
-- Variables --
local HitPart = script.Parent.Parent
local HitboxFolder = HitPart.Parent
local Character = HitboxFolder.Parent
local Player = Players:GetPlayerFromCharacter(Character)
local Humanoid = Character:WaitForChild("Humanoid", 2)
-- Modules --
local ArchData = require(ReplicatedFirst:WaitForChild("Modules"):WaitForChild("_ArchInfo"))
local RemoteEvent = HitPart:WaitForChild("RemoteEvent")
-- Function --
-- Speed Handler --
local function SpeedHandler()
	local TeamService = Knit.GetService("TeamService")
	for I, V in pairs(Players:GetChildren()) do
		if V.Team.Name == TeamService:GetHomeTeam().Name then
			if game.ReplicatedStorage.Values.ServerPossession.Value == true then
				if V.PlayerInformation.OPOS.Value == "STRONG-QB" then
					Humanoid.WalkSpeed = ArchData.QB.StrongArm.WalkSpeed
					Humanoid.JumpPower = ArchData.QB.StrongArm.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "SCRAM-QB" then
					Humanoid.WalkSpeed = ArchData.QB.Scrambler.WalkSpeed
					Humanoid.JumpPower = ArchData.QB.Scrambler.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "BAL-QB" then
					Humanoid.WalkSpeed = ArchData.QB.Balanced.WalkSpeed
					Humanoid.JumpPower = ArchData.QB.Balanced.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "SPEED-RB" then
					Humanoid.WalkSpeed = ArchData.RB.SpeedBack.WalkSpeed
					Humanoid.JumpPower = ArchData.RB.SpeedBack.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "REC-RB" then
					Humanoid.WalkSpeed = ArchData.RB.Receiving.WalkSpeed
					Humanoid.JumpPower = ArchData.RB.Receiving.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "POWER-RB" then
					Humanoid.WalkSpeed = ArchData.RB.PowerBack.WalkSpeed
					Humanoid.JumpPower = ArchData.RB.PowerBack.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "VERT-WR" then
					Humanoid.WalkSpeed = ArchData.WR.VertThreat.WalkSpeed
					Humanoid.JumpPower = ArchData.WR.VertThreat.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "DEEP-WR" then
					Humanoid.WalkSpeed = ArchData.WR.DeepThreat.WalkSpeed
					Humanoid.JumpPower = ArchData.WR.DeepThreat.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "POSS-WR" then
					Humanoid.WalkSpeed = ArchData.WR.Possession.WalkSpeed
					Humanoid.JumpPower = ArchData.WR.Possession.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "SPEED-TE" then
					Humanoid.WalkSpeed = ArchData.TE.Speed.WalkSpeed
					Humanoid.JumpPower = ArchData.TE.Speed.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "REC-TE" then
					Humanoid.WalkSpeed = ArchData.TE.Receiving.WalkSpeed
					Humanoid.JumpPower = ArchData.TE.Receiving.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "BLOCK-TE" then
					Humanoid.WalkSpeed = ArchData.TE.Blocking.WalkSpeed
					Humanoid.JumpPower = ArchData.TE.Blocking.JumpPower
					Player.Character.CharacterInformation.BlockPower.Value = Player.Character.CharacterInformation.BlockPower.Value
						+ 35
				elseif V.PlayerInformation.OPOS.Value == "SPEED-C" then
					Humanoid.WalkSpeed = ArchData.OL.Speed.WalkSpeed
					Humanoid.JumpPower = ArchData.OL.Speed.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "EGILE-C" then
					Humanoid.WalkSpeed = ArchData.OL.Egile.WalkSpeed
					Humanoid.JumpPower = ArchData.OL.Egile.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "PERCISED-C" then
					Humanoid.WalkSpeed = ArchData.OL.Percised.WalkSpeed
					Humanoid.JumpPower = ArchData.OL.Percised.JumpPower
				end
			elseif game.ReplicatedStorage.Values.ServerPossession.Value == false then
				if V.PlayerInformation.DPOS.Value == "SPEED-LB" then
					Humanoid.WalkSpeed = ArchData.LB.Speed.WalkSpeed
					Humanoid.JumpPower = ArchData.LB.Speed.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "COVER-LB" then
					Humanoid.WalkSpeed = ArchData.LB.Coverage.WalkSpeed
					Humanoid.JumpPower = ArchData.LB.Coverage.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "BAL-LB" then
					Humanoid.WalkSpeed = ArchData.LB.Balanced.WalkSpeed
					Humanoid.JumpPower = ArchData.LB.Balanced.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "SHORT-CB" then
					Humanoid.WalkSpeed = ArchData.CB.Short.WalkSpeed
					Humanoid.JumpPower = ArchData.CB.Short.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "DEEP-CB" then
					Humanoid.WalkSpeed = ArchData.CB.Deep.WalkSpeed
					Humanoid.JumpPower = ArchData.CB.Deep.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "BAL-CB" then
					Humanoid.WalkSpeed = ArchData.CB.Balanced.WalkSpeed
					Humanoid.JumpPower = ArchData.CB.Balanced.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "STRONG-S" then
					Humanoid.WalkSpeed = ArchData.S.Strong.WalkSpeed
					Humanoid.JumpPower = ArchData.S.Strong.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "WEAK-S" then
					Humanoid.WalkSpeed = ArchData.S.Weak.WalkSpeed
					Humanoid.JumpPower = ArchData.S.Weak.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "BAL-S" then
					Humanoid.WalkSpeed = ArchData.S.Balanced.WalkSpeed
					Humanoid.JumpPower = ArchData.S.Balanced.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "SPEED-DL" then
					Humanoid.WalkSpeed = ArchData.DL.Speed.WalkSpeed
					Humanoid.JumpPower = ArchData.DL.Speed.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "POWER-DL" then
					Humanoid.WalkSpeed = ArchData.DL.Power.WalkSpeed
					Humanoid.JumpPower = ArchData.DL.Power.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "BAL-DL" then
					Humanoid.WalkSpeed = ArchData.DL.Balanced.WalkSpeed
					Humanoid.JumpPower = ArchData.DL.Balanced.JumpPower
				end
			end
		elseif V.Team.Name == TeamService:GetAwayTeam() then
			if game.ReplicatedStorage.Values.ServerPossession.Value == true then
				if V.PlayerInformation.OPOS.Value == "STRONG-QB" then
					Humanoid.WalkSpeed = ArchData.QB.StrongArm.WalkSpeed
					Humanoid.JumpPower = ArchData.QB.StrongArm.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "SCRAM-QB" then
					Humanoid.WalkSpeed = ArchData.QB.Scrambler.WalkSpeed
					Humanoid.JumpPower = ArchData.QB.Scrambler.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "BAL-QB" then
					Humanoid.WalkSpeed = ArchData.QB.Balanced.WalkSpeed
					Humanoid.JumpPower = ArchData.QB.Balanced.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "SPEED-RB" then
					Humanoid.WalkSpeed = ArchData.RB.SpeedBack.WalkSpeed
					Humanoid.JumpPower = ArchData.RB.SpeedBack.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "REC-RB" then
					Humanoid.WalkSpeed = ArchData.RB.Receiving.WalkSpeed
					Humanoid.JumpPower = ArchData.RB.Receiving.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "POWER-RB" then
					Humanoid.WalkSpeed = ArchData.RB.PowerBack.WalkSpeed
					Humanoid.JumpPower = ArchData.RB.PowerBack.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "VERT-WR" then
					Humanoid.WalkSpeed = ArchData.WR.VertThreat.WalkSpeed
					Humanoid.JumpPower = ArchData.WR.VertThreat.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "DEEP-WR" then
					Humanoid.WalkSpeed = ArchData.WR.DeepThreat.WalkSpeed
					Humanoid.JumpPower = ArchData.WR.DeepThreat.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "POSS-WR" then
					Humanoid.WalkSpeed = ArchData.WR.Possession.WalkSpeed
					Humanoid.JumpPower = ArchData.WR.Possession.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "SPEED-TE" then
					Humanoid.WalkSpeed = ArchData.TE.Speed.WalkSpeed
					Humanoid.JumpPower = ArchData.TE.Speed.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "REC-TE" then
					Humanoid.WalkSpeed = ArchData.TE.Receiving.WalkSpeed
					Humanoid.JumpPower = ArchData.TE.Receiving.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "BLOCK-TE" then
					Humanoid.WalkSpeed = ArchData.TE.Blocking.WalkSpeed
					Humanoid.JumpPower = ArchData.TE.Blocking.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "SPEED-C" then
					Humanoid.WalkSpeed = ArchData.OL.Speed.WalkSpeed
					Humanoid.JumpPower = ArchData.OL.Speed.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "EGILE-C" then
					Humanoid.WalkSpeed = ArchData.OL.Egile.WalkSpeed
					Humanoid.JumpPower = ArchData.OL.Egile.JumpPower
				elseif V.PlayerInformation.OPOS.Value == "PERCISED-C" then
					Humanoid.WalkSpeed = ArchData.OL.Percised.WalkSpeed
					Humanoid.JumpPower = ArchData.OL.Percised.JumpPower
				end
			elseif game.ReplicatedStorage.Values.ServerPossession.Value == false then
				if V.PlayerInformation.DPOS.Value == "SPEED-LB" then
					Humanoid.WalkSpeed = ArchData.LB.Speed.WalkSpeed
					Humanoid.JumpPower = ArchData.LB.Speed.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "COVER-LB" then
					Humanoid.WalkSpeed = ArchData.LB.Coverage.WalkSpeed
					Humanoid.JumpPower = ArchData.LB.Coverage.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "BAL-LB" then
					Humanoid.WalkSpeed = ArchData.LB.Balanced.WalkSpeed
					Humanoid.JumpPower = ArchData.LB.Balanced.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "SHORT-CB" then
					Humanoid.WalkSpeed = ArchData.CB.Short.WalkSpeed
					Humanoid.JumpPower = ArchData.CB.Short.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "DEEP-CB" then
					Humanoid.WalkSpeed = ArchData.CB.Deep.WalkSpeed
					Humanoid.JumpPower = ArchData.CB.Deep.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "BAL-CB" then
					Humanoid.WalkSpeed = ArchData.CB.Balanced.WalkSpeed
					Humanoid.JumpPower = ArchData.CB.Balanced.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "STRONG-S" then
					Humanoid.WalkSpeed = ArchData.S.Strong.WalkSpeed
					Humanoid.JumpPower = ArchData.S.Strong.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "WEAK-S" then
					Humanoid.WalkSpeed = ArchData.S.Weak.WalkSpeed
					Humanoid.JumpPower = ArchData.S.Weak.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "BAL-S" then
					Humanoid.WalkSpeed = ArchData.S.Balanced.WalkSpeed
					Humanoid.JumpPower = ArchData.S.Balanced.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "SPEED-DL" then
					Humanoid.WalkSpeed = ArchData.DL.Speed.WalkSpeed
					Humanoid.JumpPower = ArchData.DL.Speed.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "POWER-DL" then
					Humanoid.WalkSpeed = ArchData.DL.Power.WalkSpeed
					Humanoid.JumpPower = ArchData.DL.Power.JumpPower
				elseif V.PlayerInformation.DPOS.Value == "BAL-DL" then
					Humanoid.WalkSpeed = ArchData.DL.Balanced.WalkSpeed
					Humanoid.JumpPower = ArchData.DL.Balanced.JumpPower
				end
			end
		end
	end
end
--

-- Main --
RemoteEvent.OnServerEvent:Connect(function(Plr, Input)
	if Player and Player == Plr then
		if Input[1] == "Arch" then
			-- [ OFFENSE ] --
			-- QB --
			if Input[2] == "SCRAM-QB" then
				Plr.PlayerInformation.OPOS.Value = "SCRAM-QB"
				SpeedHandler()
			elseif Input[2] == "STR ARM-QB" then
				Plr.PlayerInformation.OPOS.Value = "STRONG-QB"
				SpeedHandler()
			elseif Input[2] == "BALANCE-QB" then
				Plr.PlayerInformation.OPOS.Value = "BAL-QB"
				SpeedHandler()
				-- RB --
			elseif Input[2] == "SPEED-RB" then
				Plr.PlayerInformation.OPOS.Value = "SPEED-RB"
				SpeedHandler()
			elseif Input[2] == "REC-RB" then
				Plr.PlayerInformation.OPOS.Value = "REC-RB"
				SpeedHandler()
			elseif Input[2] == "POWER-RB" then
				Plr.PlayerInformation.OPOS.Value = "POWER-RB"
				SpeedHandler()
				-- WR --
			elseif Input[2] == "VERT-WR" then
				Plr.PlayerInformation.OPOS.Value = "VERT-WR"
				SpeedHandler()
			elseif Input[2] == "DEEP-WR" then
				Plr.PlayerInformation.OPOS.Value = "DEEP-WR"
				SpeedHandler()
			elseif Input[2] == "POSS-WR" then
				Plr.PlayerInformation.OPOS.Value = "POSS-WR"
				SpeedHandler()
				-- TE --
			elseif Input[2] == "SPEED-TE" then
				Plr.PlayerInformation.OPOS.Value = "SPEED-TE"
				SpeedHandler()
			elseif Input[2] == "REC-TE" then
				Plr.PlayerInformation.OPOS.Value = "REC-TE"
				SpeedHandler()
			elseif Input[2] == "BLOCK-TE" then
				Plr.PlayerInformation.OPOS.Value = "BLOCK-TE"
				SpeedHandler()
				-- OL --
			elseif Input[2] == "SPEED-C" then
				Plr.PlayerInformation.OPOS.Value = "SPEED-C"
				SpeedHandler()
			elseif Input[2] == "EGILE-C" then
				Plr.PlayerInformation.OPOS.Value = "EGILE-C"
				SpeedHandler()
			elseif Input[2] == "PERCISED-C" then
				Plr.PlayerInformation.OPOS.Value = "PERCISED-C"
				SpeedHandler()
				-- [ DEFENSE ] --
				-- LB --
			elseif Input[2] == "SPEED-LB" then
				Plr.PlayerInformation.DPOS.Value = "SPEED-LB"
				SpeedHandler()
			elseif Input[2] == "COVER-LB" then
				Plr.PlayerInformation.DPOS.Value = "COVER-LB"
				SpeedHandler()
			elseif Input[2] == "BALANCE-LB" then
				Plr.PlayerInformation.DPOS.Value = "BAL-LB"
				SpeedHandler()
				-- CB --
			elseif Input[2] == "SHORT-CB" then
				Plr.PlayerInformation.DPOS.Value = "SHORT-CB"
				SpeedHandler()
			elseif Input[2] == "DEEP-CB" then
				Plr.PlayerInformation.DPOS.Value = "DEEP-CB"
				SpeedHandler()
			elseif Input[2] == "BALANCE-CB" then
				Plr.PlayerInformation.DPOS.Value = "BAL-CB"
				SpeedHandler()
				-- S --
			elseif Input[2] == "STRONG-S" then
				Plr.PlayerInformation.DPOS.Value = "STRONG-S"
				SpeedHandler()
			elseif Input[2] == "WEAK-S" then
				Plr.PlayerInformation.DPOS.Value = "WEAK-S"
				SpeedHandler()
			elseif Input[2] == "BALANCE-S" then
				Plr.PlayerInformation.DPOS.Value = "BAL-S"
				SpeedHandler()
				-- DL --
			elseif Input[2] == "SPEED-DL" then
				Plr.PlayerInformation.DPOS.Value = "SPEED-DL"
				SpeedHandler()
			elseif Input[2] == "POWER-DL" then
				Plr.PlayerInformation.DPOS.Value = "POWER-DL"
				SpeedHandler()
			elseif Input[2] == "BALANCE-DL" then
				Plr.PlayerInformation.DPOS.Value = "BAL-DL"
				SpeedHandler()
			end
		end
	end
end)

game.ReplicatedStorage.Values.ServerPossession:GetPropertyChangedSignal("Value"):Connect(function()
	SpeedHandler()
end)
