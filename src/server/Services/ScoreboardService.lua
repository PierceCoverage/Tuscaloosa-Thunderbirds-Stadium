local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ScoreboardService = Knit.CreateService({
	Name = "ScoreboardService",
	Client = {
		StopRecord = Knit.CreateSignal(),
		Event = Knit.CreateSignal(),
	},
	_AutoStop = false,
})

local DEBOUNCE = false

function ScoreboardService.Client:SendData(player: Player, code: string)
	if player.Team.Name ~= "Referee" then
		return
	end

	local ChainsService = Knit.GetService("ChainsService")
	local IndicatorService = Knit.GetService("ChainsService")
	local GameService = Knit.GetService("GameService")
	local LiveService = Knit.GetService("LiveService")
	local MessageService = Knit.GetService("MessageService")

	local len = code:len()
	local item = code:sub(1, 1)
	local action = code:sub(2, 2)

	local amount

	if action == "P" or action == "M" then
		amount = code:sub(3, len)
	end
	if item == "H" then
		if action == "P" then
			GameService.Values.Home.Score += tonumber(amount)
			LiveService:ScoreUpdate()
		elseif action == "M" then
			GameService.Values.Home.Score -= tonumber(amount)
			LiveService:ScoreUpdate()
		elseif action == "F" then
			GameService.Values.Home.Score += 3
			GameService.Values.Clock.Running = false
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Field Goal is Good!", true)
			if IndicatorService._Direction == 1 then
				ChainsService.down.P.CFrame = CFrame.new(
					-150 + 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			elseif IndicatorService._Direction == -1 then
				ChainsService.down.P.CFrame = CFrame.new(
					150 - 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			end
			IndicatorService._Direction *= -1
			LiveService:ScoreUpdate("FIELD GOAL")
			GameService.Values.Down = 5
		elseif code:sub(2, len) == "TD" then
			GameService.Values.Home.Score += 6
			if IndicatorService._Direction == 1 then
				ChainsService.down.P.CFrame = CFrame.new(
					150 - 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					150,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			elseif IndicatorService._Direction == -1 then
				ChainsService.down.P.CFrame = CFrame.new(
					-150 + 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					-150,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			end
			GameService.Values.Clock.Running = false
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Touchdown!", true)
			if DEBOUNCE == true then
				DEBOUNCE = false
				ReplicatedStorage.Touchdown:FireAllClients(player, "Home")
				task.wait(3)
				DEBOUNCE = true
			end
			LiveService:ScoreUpdate("TOUCHDOWN")
			GameService.Values.Down = 6
		elseif code:sub(2, 3) == "TO" then
			if code:sub(4, 4) == "M" then
				if GameService.Values.Home.Timeouts == 0 then
					return
				end
				GameService.Values.Home.Timeouts -= 1
				GameService.Values.Clock.Running = false
				MessageService:Send(Players:GetPlayers(), player.Name .. ": Timeout Home")
			else
				if GameService.Values.Home.Timeouts == 3 then
					return
				end
				GameService.Values.Clock.Running = false
				GameService.Values.Home.Timeouts += 1
			end
		elseif code:sub(2, len) == "SFT" then
			GameService.Values.Home.Score = GameService.Values.Home.Score + 2
			GameService.Values.Clock.Running = false
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Safety Home", true)
			if IndicatorService._Direction == 1 then
				ChainsService.down.P.CFrame = CFrame.new(
					-150 + 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			elseif IndicatorService._Direction == -1 then
				ChainsService.down.P.CFrame = CFrame.new(
					150 - 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			end
			IndicatorService._Direction *= -1
			LiveService:ScoreUpdate("SAFETY")
			GameService.Values.Down = 5
		elseif code:sub(2, len) == "2P" then
			GameService.Values.Home.Score += 2
			GameService.Values.Clock.Running = false
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": 2 Point Conversion is Good", true)
			if IndicatorService._Direction == 1 then
				ChainsService.down.P.CFrame = CFrame.new(
					-150 + 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			elseif IndicatorService._Direction == -1 then
				ChainsService.down.P.CFrame = CFrame.new(
					150 - 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			end
			IndicatorService._Direction *= -1
			LiveService:ScoreUpdate("2PC")
			GameService.Values.Down = 5
		end
	elseif item == "A" then
		if action == "P" then
			GameService.Values.Away.Score += tonumber(amount)
			LiveService:ScoreUpdate()
		elseif action == "M" then
			GameService.Values.Away.Score -= tonumber(amount)
			LiveService:ScoreUpdate()
		elseif action == "F" then
			GameService.Values.Away.Score += 3
			GameService.Values.Clock.Running = false
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Field Goal is Good!", true)
			if IndicatorService._Direction == 1 then
				ChainsService.down.P.CFrame = CFrame.new(
					-150 + 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			elseif IndicatorService._Direction == -1 then
				ChainsService.down.P.CFrame = CFrame.new(
					150 - 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			end
			IndicatorService._Direction *= -1
			LiveService:ScoreUpdate("FIELD GOAL")
			GameService.Values.Down = 5
		elseif code:sub(2, len) then
			GameService.Values.Away.Score += 6
			if IndicatorService._Direction == 1 then
				ChainsService.down.P.CFrame = CFrame.new(
					150 - 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					150,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			elseif IndicatorService._Direction == -1 then
				ChainsService.down.P.CFrame = CFrame.new(
					-150 + 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					-150,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			end
			GameService.Values.Clock.Running = false
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Touchdown!", true)
			if DEBOUNCE == true then
				DEBOUNCE = false
				ReplicatedStorage.Touchdown:FireAllClients(player, "Away")
				task.wait(3)
				DEBOUNCE = true
			end
			LiveService:ScoreUpdate("TOUCHDOWN")
			GameService.Values.Down = 6
		elseif code:sub(2, 3) == "TO" then
			if code:sub(4, 4) == "M" then
				if GameService.Values.Away.Timeouts == 0 then
					return
				end

				GameService.Values.Away.Timeouts -= 1
				GameService.Values.Clock.Running = false
				MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Timeout Away")
			else
				if GameService.Values.Away.Timeouts == 3 then
					return
				end
				GameService.Values.Clock.Running = false
				GameService.Values.Away.Timeouts += 1
			end
		elseif code:sub(2, len) == "SFT" then
			GameService.Values.Away.Score += 2
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Safety Away", true)
			if IndicatorService._Direction == 1 then
				ChainsService.down.P.CFrame = CFrame.new(
					-150 + 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			elseif IndicatorService._Direction == -1 then
				ChainsService.down.P.CFrame = CFrame.new(
					150 - 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			end
			IndicatorService._Direction *= -1
			LiveService:ScoreUpdate("SAFETY")
			GameService.Values.Down = 5
		elseif code:sub(2, len) == "2P" then
			GameService.Values.Away.Score += 2
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": 2 Point Conversion is Good", true)
			if IndicatorService._Direction == 1 then
				ChainsService.down.P.CFrame = CFrame.new(
					-150 + 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			elseif IndicatorService._Direction == -1 then
				ChainsService.down.P.CFrame = CFrame.new(
					150 - 90,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			end
			IndicatorService._Direction *= -1
			LiveService:ScoreUpdate("2PC")
			GameService.Values.Down = 5
		end
	elseif item == "C" then
		if action == "P" then
			GameService.Values.Clock.Value += tonumber(amount)
		elseif action == "R" then
			GameService.Values.Clock.Value = 5 * 60
		elseif code:sub(2, len) == "STP" then
			ReplicatedStorage.ReplayRemote:FireAllClients({ "StopRecord" })
			self:RunClock(false)
		elseif code:sub(2, len) == "STA" then
			self:RunClock(true)
		elseif action == "M" then
			GameService.Values.Clock.Value -= tonumber(amount)
		end
	elseif item == "P" then
		if code:sub(2, len) == "STA" then
			self.Client.Event:FireAllClients("Blown")
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Blown", true)
			ReplicatedStorage.ReplayRemote:FireAllClients({ "Record" })
			GameService:workspaceFinder()
			GameService:ClearBalls()
			if #Players:GetPlayers() > 15 and #Teams.Referee:GetPlayers() > 0 then
				LiveService._isGame = true
			else
				LiveService._isGame = false
			end
			self:RunPC(true)
		elseif code:sub(2, len) == "STP" then
			self:RunPC(false)
		elseif code:sub(2, len) == "R" then
			GameService.Values.PlayClock.Value = 25
		end
	elseif item == "Q" then
		if action == "M" then
			GameService.Values.Quarter = if GameService.Values.Quarter > 1 then GameService.Values.Quarter - 1 else 1
		elseif action == "P" then
			GameService.Values.Quarter += 1
		end
	elseif item == "D" then
		if action == "M" then
			GameService.Values.Down = GameService.Values.Down > 1 and GameService.Values.Down - 1 or 1
		elseif action == "P" then
			GameService.Values.Down = GameService.Values.Down < 5 and GameService.Values.Down + 1 or 5
		end
	else
		if code == "K" then
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Completed Pass", true)
		elseif code == "EOQ" then
			GameService.Values.Clock.Running = false
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": End of Quarter", true)
			LiveService:ScoreUpdate("EOQ")
		elseif code == "FLG" then
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Flag", true)
			self.Client.Event:FireAllClients("Flag")
		elseif code == "FRC" then
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Fumble Recovery", true)
		elseif code == "INC" then
			GameService.Values.Clock.Running = false
			GameService.Values.Down = GameService.Values.Down + 1
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Incomplete Pass", true)
			if LiveService._isPAT then
				if IndicatorService._Direction == 1 then
					ChainsService.down.P.CFrame = CFrame.new(
						-150 + 90,
						ChainsService.down.P.Position.Y,
						ChainsService.down.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
					ChainsService.first.P.CFrame = CFrame.new(
						0,
						ChainsService.first.P.Position.Y,
						ChainsService.first.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
				elseif IndicatorService._Direction == -1 then
					ChainsService.down.P.CFrame = CFrame.new(
						150 - 90,
						ChainsService.down.P.Position.Y,
						ChainsService.down.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
					ChainsService.first.P.CFrame = CFrame.new(
						0,
						ChainsService.first.P.Position.Y,
						ChainsService.first.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
				end
				IndicatorService._Direction *= -1
				LiveService:ScoreUpdate("2PCNG")
			end
			LiveService._isPAT = false
		elseif code == "INCOOB" then
			GameService.Values.Clock.Running = false
			GameService.Values.Down = GameService.Values.Down + 1
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Incomplete, Out of Boundaries", true)

			if LiveService._isPAT then
				if IndicatorService._Direction == 1 then
					ChainsService.down.P.CFrame = CFrame.new(
						-150 + 90,
						ChainsService.down.P.Position.Y,
						ChainsService.down.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
					ChainsService.first.P.CFrame = CFrame.new(
						0,
						ChainsService.first.P.Position.Y,
						ChainsService.first.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
				elseif IndicatorService._Direction == -1 then
					ChainsService.down.P.CFrame = CFrame.new(
						150 - 90,
						ChainsService.down.P.Position.Y,
						ChainsService.down.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
					ChainsService.first.P.CFrame = CFrame.new(
						0,
						ChainsService.first.P.Position.Y,
						ChainsService.first.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
				end
				IndicatorService._Direction *= -1
			end
			LiveService._isPAT = false
		elseif code == "INT" then
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Interception", true)
			self.Client.Event:FireAllClients("Pos")
			LiveService._intedByHome = GameService:HomeTeamHasBall()
			LiveService:ScoreUpdate("INTERCEPTION")
		elseif code == "LAT" then
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Lateral Pass", true)
		elseif code == "LS" then
			GameService.Values.Clock.Running = false
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Lag Sack", true)
		elseif code == "OOB" then
			GameService.Values.Clock.Running = false
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Out of Boundaries", true)
			if IndicatorService._Direction == 1 then
				ChainsService.down.P.CFrame = CFrame.new(
					-30,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			elseif IndicatorService._Direction == -1 then
				ChainsService.down.P.CFrame = CFrame.new(
					30,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					0,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			end
			if LiveService._isPAT then
				if IndicatorService._Direction == 1 then
					ChainsService.down.P.CFrame = CFrame.new(
						-150 + 90,
						ChainsService.down.P.Position.Y,
						ChainsService.down.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
					ChainsService.first.P.CFrame = CFrame.new(
						0,
						ChainsService.first.P.Position.Y,
						ChainsService.first.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
				elseif IndicatorService._Direction == -1 then
					ChainsService.down.P.CFrame = CFrame.new(
						150 - 90,
						ChainsService.down.P.Position.Y,
						ChainsService.down.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
					ChainsService.first.P.CFrame = CFrame.new(
						0,
						ChainsService.first.P.Position.Y,
						ChainsService.first.P.Position.Z
					) * CFrame.Angles(0, math.rad(-90), 0)
				end
				IndicatorService._Direction *= -1
				LiveService:ScoreUpdate("2PCNG")
			end
			GameService.Values.Down = 1
		elseif code == "RMSG" then
			GameService.Values.Clock.Running = false
			MessageService:SendMessage("")
			self.Client.Event:FireAllClients("Reset")
		elseif code == "RVW" then
			GameService.Values.Clock.Running = false
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Reviewing the Previous Play", true)
			self.Client.Event:FireAllClients("Review")
		elseif code == "SACK" then
			GameService.Values.Clock.Running = false
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Sack", true)
		elseif code == "TB" then
			GameService.Values.Clock.Running = false
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Touchback", true)
			if IndicatorService._Direction == 1 then
				ChainsService.down.P.CFrame = CFrame.new(
					-150 + 60,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					-150 + 90,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			elseif IndicatorService._Direction == -1 then
				ChainsService.down.P.CFrame = CFrame.new(
					150 - 60,
					ChainsService.down.P.Position.Y,
					ChainsService.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				ChainsService.first.P.CFrame = CFrame.new(
					150 - 90,
					ChainsService.first.P.Position.Y,
					ChainsService.first.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
			end
			GameService.Values.Down = 1
		elseif code == "BALLPOS" then
			self.Client.Event:FireAllClients("Pos")
		elseif code == "FLGDEAD" then
			self:RunClock(false)
			self:RunPC(false)
			MessageService:SendMessage(Players:GetPlayers(), player.Name .. ": Dead Play", true)
			self.Client.Event:FireAllClients("Flag")
		end
	end
end

function ScoreboardService:SetAutoStop(bool: boolean)
	print(bool)
end

function ScoreboardService:RunPC(bool: boolean)
	local GameService = Knit.GetService("GameService")

	if bool and GameService.Values.PlayClock.GameService.Values.Clock.Running then
		return
	end

	if GameService.Values.PlayClock.Value == 0 then
		return
	end

	if bool then
		GameService.Values.PlayClock.GameService.Values.Clock.Running = true
		ReplicatedStorage.Stats.LastQB.Value = "Off"

		repeat
			GameService.Values.PlayClock.Value -= 1
		until GameService.Values.PlayClock.GameService.Values.Clock.Running == false
			or GameService.Values.PlayClock.Value == 0

		GameService.Values.PlayClock.GameService.Values.Clock.Running = false
	else
		GameService.Values.PlayClock.GameService.Values.Clock.Running = false
	end
end

function ScoreboardService:RunClock(bool: boolean)
	local GameService = Knit.GetService("GameService")

	if bool and GameService.Values.Clock.GameService.Values.Clock.Running then
		return
	end

	if GameService.Values.Clock.Value == 0 then
		return
	end

	self._AutoStop = false

	if bool then
		GameService.Values.Clock.GameService.Values.Clock.Running = true
		repeat
			GameService.Values.Clock.Value -= 1
			task.wait(1)
		until GameService.Values.Clock.GameService.Values.Clock.Running == false
			or GameService.Values.Clock.Value == 0
			or self._AutoStop == true
		GameService.Values.Clock.GameService.Values.Clock.Running = false
		self.Client.StopRecord:FireAllClients()
		GameService.Values.Clock.GameService.Values.Clock.Running = false
		self._AutoStop = false
	else
		GameService.Values.Clock.GameService.Values.Clock.Running = false
		self._AutoStop = false
	end
end

function ScoreboardService:KnitStart()
	print("ScoreboardService Started")
end

function ScoreboardService:KnitInit()
	print("ScoreboardService Initialized")
end

return ScoreboardService
