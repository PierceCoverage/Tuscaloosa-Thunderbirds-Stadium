-- Services --
local UserInputService = game:GetService("UserInputService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TeamService = Knit.GetService("TeamService")

-- Variables --
local HitPart = script.Parent.Parent
local HitboxFolder = HitPart.Parent
local Character = HitboxFolder.Parent
local Player = game.Players:GetPlayerFromCharacter(Character)
repeat
	wait()
until Player and Player.CharacterAppearanceLoaded
local Mouse = Player:GetMouse()
local Animations = HitPart:WaitForChild("Animations")
local RemoteEvent = HitPart:WaitForChild("RemoteEvent")
local MainEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RemoteEvent")
local RagdollModule = require(ReplicatedFirst:WaitForChild("Modules"):WaitForChild("_Ragdoll"))
local LockModule = require(ReplicatedFirst:WaitForChild("Modules"):WaitForChild("_Lock"))
-- Char Children --
local HumanoidRootPart, Humanoid = Character:WaitForChild("HumanoidRootPart"), Character:WaitForChild("Humanoid")
local Head, Torso = Character:WaitForChild("Head"), Character:WaitForChild("Torso")
local LArm, LLeg = Character:WaitForChild("Left Arm"), Character:WaitForChild("Left Leg")
local RArm, RLeg = Character:WaitForChild("Right Arm"), Character:WaitForChild("Right Leg")
-- Values --
local MidDist = 0
local HighDist = 0
local LLowDist = 0
local RLowDist = 0
local LeftDist = 0
local RightDist = 0
local Football, Distance, CanUse = nil, nil, false
local Diving = false
local DivePower, RotPower = 2.15, 8
local KeyDown = nil
local Power = 60
local CanLook = false
-- Animations --
local Animations = script.Parent.Parent.Animations
local Stances = Animations.Stances
local Ball = Animations.Ball
-- Offense
local QB = Character.Humanoid:LoadAnimation(Stances.QB)
local RB = Character.Humanoid:LoadAnimation(Stances.RB)
local WR = Character.Humanoid:LoadAnimation(Stances.WR)
local TE = Character.Humanoid:LoadAnimation(Stances.TE)
local OL = Character.Humanoid:LoadAnimation(Stances.OL)
-- Defense
local CB = Character.Humanoid:LoadAnimation(Stances.CB)
local S = Character.Humanoid:LoadAnimation(Stances.S)
local LB = Character.Humanoid:LoadAnimation(Stances.LB)
local TWO = Character.Humanoid:LoadAnimation(Stances.DLINE.TWOPOINT)
local THREE = Character.Humanoid:LoadAnimation(Stances.DLINE.THREEPOINT)
local FOUR = Character.Humanoid:LoadAnimation(Stances.DLINE.FOURPOINT)
-- Other --
local HOLD = Character.Humanoid:LoadAnimation(Ball.B_Idle)
local SLIDE = Character.Humanoid:LoadAnimation(Ball.Slide)
local KNEEL = Character.Humanoid:LoadAnimation(Ball.Kneel)
-- Tables --
local Anims = {
	["Mid"] = Humanoid:LoadAnimation(Animations.Catch:WaitForChild("Mid")),
	["High"] = Humanoid:LoadAnimation(Animations.Catch:WaitForChild("High")),
	["Low"] = Humanoid:LoadAnimation(Animations.Catch:WaitForChild("Low")),
	["Left"] = Humanoid:LoadAnimation(Animations.Catch:WaitForChild("Left")),
	["Right"] = Humanoid:LoadAnimation(Animations.Catch:WaitForChild("Right")),
}
---

-- Functions --
function isMoving()
	local X1 = Humanoid.MoveDirection.Magnitude
	return (X1 and X1 > 0)
end

--
function Lock()
	LockModule:Mode(not LockModule:IsLocked())
end
--
function InMotion()
	if
		Humanoid.MoveDirection == Vector3.new(0, 0, 0)
		or Humanoid.MoveDirection.X == 0 and Humanoid.MoveDirection.Z == 0
	then
		return false
	end
	return true
end
--
function Dive()
	if not InMotion() then
		return
	end
	if Diving == false and Humanoid.PlatformStand == false then
		Diving = true
		-- Velocity --
		local Velocity = Humanoid.MoveDirection * Humanoid.WalkSpeed
		Torso.RotVelocity = Vector3.new(Velocity.Z / RotPower, 0, -Velocity.X / RotPower)
		Torso.Velocity = Vector3.new(
			Velocity.X,
			6 * (Humanoid.JumpPower / Humanoid.JumpPower) * Humanoid.MoveDirection.Magnitude,
			Velocity.Z
		) * DivePower
		Humanoid.PlatformStand = true
		wait(2)
		if Humanoid.PlatformStand == true then
			Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
		wait(1.7)
		Diving = false
	end
end
--
function OnDoll(Ragdolled)
	if Ragdolled then
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
		Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
	else
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
		Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end
--
function StopAnimations()
	QB:Stop()
	WR:Stop()
	TE:Stop()
	CB:Stop()
	RB:Stop()
	OL:Stop()
	S:Stop()
	LB:Stop()
end
--
MainEvent.OnClientEvent:Connect(OnDoll)
--
function Catch()
	if CanUse then
		if not Character:FindFirstChild("Football") then
			CanUse = false
			-- Find Closest Ball --
			for _, Item in pairs(workspace:GetChildren()) do
				if Item.Name == "Football" and Item:IsA("MeshPart") then
					local CheckDist = (Torso.Position - Item.Position).Magnitude
					if Distance == nil then
						Football = Item
						Distance = CheckDist
					else
						if CheckDist < Distance then
							Football = Item
							Distance = CheckDist
						end
					end
				end
			end
			-- Get Closest Body Part --
			if not Character:FindFirstChild("Football") then
				if workspace:FindFirstChild("Football") then
					-- Distances --
					MidDist = (Torso.Position - Football.Position).Magnitude
					HighDist = (Head.Position - Football.Position).Magnitude
					LLowDist = (LLeg.Position - Football.Position).Magnitude
					RLowDist = (RLeg.Position - Football.Position).Magnitude
					RightDist = (RArm.Position - Football.Position).Magnitude
					LeftDist = (LArm.Position - Football.Position).Magnitude
					--
					RemoteEvent:FireServer({ "Jersey", "Catch" })
					local Distances = { MidDist, HighDist, LLowDist, RLowDist, LeftDist, RightDist }
					local Closest = nil
					for I = 2, #Distances do
						if Distances[I] < Distances[I - 1] then
							Closest = Distances[I]
						end
					end
					-- Play Animations --
					if Closest == MidDist then
						Anims["Mid"]:Play()
					elseif Closest == HighDist then
						Anims["High"]:Play()
					elseif Closest == LLowDist then
						Anims["Low"]:Play()
					elseif Closest == RLowDist then
						Anims["Low"]:Play()
					elseif Closest == LeftDist then
						Anims["Left"]:Play()
					elseif Closest == RightDist then
						Anims["Right"]:Play()
					end
				end
			end
		end
		wait(2)
		Football = nil
		Distance = nil
		CanUse = true
	end
end
---

-- Presets --
CanUse = true
CanDive = true
InLock = false
---

-- Main --
UserInputService.InputBegan:Connect(function(Input, Busy)
	if Busy then
		return
	end
	--
	if Input.UserInputType == Enum.UserInputType.Keyboard then
		local Key = Input.KeyCode
		-- Binds --
		if Key == Enum.KeyCode.C then
			if not Character:FindFirstChild("Football") then
				RemoteEvent:FireServer({ "Jersey", "Catch" })
				Catch()
			else
				if not Diving and InMotion() and Character:FindFirstChild("Football") then
					if Character.CharacterInformation.UseKneel.Value == false then
						RemoteEvent:FireServer({ "Jersey", "Slide" })
					end
				end
			end
		elseif Key == Enum.KeyCode.E then
			if not Diving and InMotion() and not Character:FindFirstChild("Football") then
				Dive()
			end
		elseif Key == Enum.KeyCode.V then
			if not Diving and Character:FindFirstChild("Football") then
				if Character.CharacterInformation.UseSlide.Value == false then
					Character.CharacterInformation.UseKneel.Value = true
					RemoteEvent:FireServer({ "Jersey", "Kneel" })
				end
			end
		elseif Key == Enum.KeyCode.X then
			if not Character:FindFirstChild("Football") then
				RemoteEvent:FireServer({ "Jersey", "Block" })
				wait(2.75)
			end
		elseif Key == Enum.KeyCode.T then
			if not Diving and Character:FindFirstChild("Football") then
				RemoteEvent:FireServer({ "Jersey", "Truck" })
			elseif not Diving and not Character:FindFirstChild("Football") then
				RemoteEvent:FireServer({ "Jersey", "Hitstick" })
			end
		elseif Key == Enum.KeyCode.G then
			if not Diving and Character:FindFirstChild("Football") then
				RemoteEvent:FireServer({ "Jersey", "Stiffarm" })
			end
		elseif Key == Enum.KeyCode.LeftShift then
			if not Character:FindFirstChild("Football") then
				if InLock == false then
					InLock = true
					Lock()
				elseif InLock == true then
					InLock = false
					Lock()
				end
			end
		elseif Key == Enum.KeyCode.N then
			if Player.Team.Name == TeamService:GetHomeTeam().Name then
				if game.ReplicatedStorage.Values.ServerPossession.Value == true then
					if
						Player.PlayerInformation.OPOS.Value == "SCRAM-QB"
						or Player.PlayerInformation.OPOS.Value == "STRONG-QB"
						or Player.PlayerInformation.OPOS.Value == "BAL-QB"
					then
						QB:Play()
					elseif
						Player.PlayerInformation.OPOS.Value == "SPEED-RB"
						or Player.PlayerInformation.OPOS.Value == "REC-RB"
						or Player.PlayerInformation.OPOS.Value == "POWER-RB"
					then
						RB:Play()
					elseif
						Player.PlayerInformation.OPOS.Value == "VERT-WR"
						or Player.PlayerInformation.OPOS.Value == "DEEP-WR"
						or Player.PlayerInformation.OPOS.Value == "POSS-WR"
					then
						WR:Play()
					elseif
						Player.PlayerInformation.OPOS.Value == "SPEED-TE"
						or Player.PlayerInformation.OPOS.Value == "REC-TE"
						or Player.PlayerInformation.OPOS.Value == "BLOCK-TE"
					then
						TE:Play()
					elseif
						Player.PlayerInformation.OPOS.Value == "SPEED-C"
						or Player.PlayerInformation.OPOS.Value == "EGILE-C"
						or Player.PlayerInformation.OPOS.Value == "PERCISED-C"
					then
						OL:Play()
					end
				elseif game.ReplicatedStorage.Values.ServerPossession.Value == false then
					if
						Player.PlayerInformation.DPOS.Value == "SPEED-LB"
						or Player.PlayerInformation.DPOS.Value == "COVER-LB"
						or Player.PlayerInformation.DPOS.Value == "BAL-LB"
					then
						LB:Play()
					elseif
						Player.PlayerInformation.DPOS.Value == "SHORT-CB"
						or Player.PlayerInformation.DPOS.Value == "DEEP-CB"
						or Player.PlayerInformation.DPOS.Value == "BAL-CB"
					then
						CB:Play()
					elseif
						Player.PlayerInformation.DPOS.Value == "STRONG-S"
						or Player.PlayerInformation.DPOS.Value == "WEAK-S"
						or Player.PlayerInformation.DPOS.Value == "BAL-S"
					then
						S:Play()
					elseif
						Player.PlayerInformation.DPOS.Value == "SPEED-DL"
						or Player.PlayerInformation.DPOS.Value == "POWER-DL"
						or Player.PlayerInformation.DPOS.Value == "BAL-DL"
					then
					end
				end
			elseif Player.Team.Name == TeamService:GetAwayTeam().Name then
				if game.ReplicatedStorage.Values.ServerPossession.Value == false then
					if
						Player.PlayerInformation.OPOS.Value == "SCRAM-QB"
						or Player.PlayerInformation.OPOS.Value == "STRONG-QB"
						or Player.PlayerInformation.OPOS.Value == "BAL-QB"
					then
						QB:Play()
					elseif
						Player.PlayerInformation.OPOS.Value == "SPEED-RB"
						or Player.PlayerInformation.OPOS.Value == "REC-RB"
						or Player.PlayerInformation.OPOS.Value == "POWER-RB"
					then
						RB:Play()
					elseif
						Player.PlayerInformation.OPOS.Value == "VERT-WR"
						or Player.PlayerInformation.OPOS.Value == "DEEP-WR"
						or Player.PlayerInformation.OPOS.Value == "POSS-WR"
					then
						WR:Play()
					elseif
						Player.PlayerInformation.OPOS.Value == "SPEED-TE"
						or Player.PlayerInformation.OPOS.Value == "REC-TE"
						or Player.PlayerInformation.OPOS.Value == "BLOCK-TE"
					then
						TE:Play()
					elseif
						Player.PlayerInformation.OPOS.Value == "SPEED-C"
						or Player.PlayerInformation.OPOS.Value == "EGILE-C"
						or Player.PlayerInformation.OPOS.Value == "PERCISED-C"
					then
						OL:Play()
					end
				elseif game.ReplicatedStorage.Values.ServerPossession.Value == true then
					if
						Player.PlayerInformation.DPOS.Value == "SPEED-LB"
						or Player.PlayerInformation.DPOS.Value == "COVER-LB"
						or Player.PlayerInformation.DPOS.Value == "BAL-LB"
					then
						LB:Play()
					elseif
						Player.PlayerInformation.DPOS.Value == "SHORT-CB"
						or Player.PlayerInformation.DPOS.Value == "DEEP-CB"
						or Player.PlayerInformation.DPOS.Value == "BAL-CB"
					then
						CB:Play()
					elseif
						Player.PlayerInformation.DPOS.Value == "STRONG-S"
						or Player.PlayerInformation.DPOS.Value == "WEAK-S"
						or Player.PlayerInformation.DPOS.Value == "BAL-S"
					then
						S:Play()
					elseif
						Player.PlayerInformation.DPOS.Value == "SPEED-DL"
						or Player.PlayerInformation.DPOS.Value == "POWER-DL"
						or Player.PlayerInformation.DPOS.Value == "BAL-DL"
					then
					end
				end
			end
		end
	elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
		if UserInputService.KeyboardEnabled then
			if Character:FindFirstChild("Football") then
				return
			else
				RemoteEvent:FireServer({ "Jersey", "Catch" })
				Catch()
			end
		end
	end
end)
-- Humanoid Things --
Humanoid.StateChanged:Connect(function(Old, New)
	if New == Enum.HumanoidStateType.Jumping then
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
		wait(1.5)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	end
end)
-- RenderStepped --
RunService.RenderStepped:Connect(function()
	if Character.Humanoid.MoveDirection.Magnitude > 0 then
		StopAnimations()
	elseif Character:FindFirstChildOfClass("Tool") then
		StopAnimations()
	end
end)
-- Values --
Character.CharacterInformation.InQBMode.Changed:Connect(function()
	if Character.CharacterInformation.InQBMode.Value == true then
	else
	end
end)

Character.CharacterInformation.UseSlide.Changed:Connect(function()
	if Character.CharacterInformation.UseSlide.Value == true then
		SLIDE:Play()
	else
		SLIDE:Stop()
	end
end)

Character.CharacterInformation.UseKneel.Changed:Connect(function()
	if Character.CharacterInformation.UseKneel.Value == true then
		KNEEL:Play()
	else
		KNEEL:Stop()
	end
end)

Character.ChildAdded:Connect(function()
	if Character:FindFirstChild("Football") then
		HOLD:Play()
	else
		HOLD:Stop()
	end
end)

Character.ChildRemoved:Connect(function()
	if not Character:FindFirstChild("Football") then
		HOLD:Stop()
	else
		return
	end
end)
---

-- Finalize --
print(Character.Name .. "'s " .. script.Name .. " Has Loaded.")
---
