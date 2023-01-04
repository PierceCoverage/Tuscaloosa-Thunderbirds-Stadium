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
	return self.Server:ReceiveData(player, code)
end

local debounce = {}

function ScoreboardService:ReceiveData(player: Player, code: string)
	if debounce[player.Name] then
		return
	end

	debounce[player.Name] = true
	task.delay(0.5, function()
		debounce[player.Name] = false
	end)

	if player.Team.Name ~= "Referee" then
		return
	end

	local ChainsService = Knit.GetService("ChainsService")
	local IndicatorService = Knit.GetService("IndicatorService")
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
			GameService:Update({ HomeScore = tonumber(amount) })
			LiveService:ScoreUpdate()
		elseif action == "M" then
			GameService:Update({ HomeScore = -tonumber(amount) })
			LiveService:ScoreUpdate()
		elseif action == "F" then
			GameService:Update({ HomeScore = 3 })
			GameService:Update({ ClockRunning = false })
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
			GameService:Update({ Down = 5 })
		elseif code:sub(2, len) == "TD" then
			GameService:Update({ HomeScore = 6 })
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
			GameService:Update({ ClockRunning = false })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Touchdown!", true)
			if DEBOUNCE == true then
				DEBOUNCE = false
				ReplicatedStorage.Touchdown:FireAllClients(player, "Home")
				task.delay(3, function()
					DEBOUNCE = true
				end)
			end
			LiveService:ScoreUpdate("TOUCHDOWN")
			GameService:Update({ Down = 6 })
		elseif code:sub(2, 3) == "TO" then
			if code:sub(4, 4) == "M" then
				if GameService.Values.Home.Timeouts == 0 then
					return
				end
				GameService:Update({ HomeTimeouts = -1 })
				GameService:Update({ ClockRunning = false })
				MessageService:Send(Players:GetPlayers(), player.Name .. ": Timeout Home")
			else
				if GameService.Values.Home.Timeouts == 3 then
					return
				end
				GameService:Update({ ClockRunning = false })
				GameService:Update({ HomeTimeouts = 1 })
			end
		elseif code:sub(2, len) == "SFT" then
			GameService:Update({ HomeScore = 2 })
			GameService:Update({ ClockRunning = false })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Safety Home", true)
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
			GameService:Update({ Down = 5 })
		elseif code:sub(2, len) == "2P" then
			GameService:Update({ HomeScore = 2 })
			GameService:Update({ ClockRunning = false })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": 2 Point Conversion is Good", true)
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
			GameService:Update({ Down = 5 })
		end
	elseif item == "A" then
		if action == "P" then
			GameService:Update({ AwayScore = tonumber(amount) })
			LiveService:ScoreUpdate()
		elseif action == "M" then
			GameService:Update({ AwayScore = -tonumber(amount) })
			LiveService:ScoreUpdate()
		elseif action == "F" then
			GameService:Update({ AwayScore = 3 })
			GameService:Update({ ClockRunning = false })
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
			GameService:Update({ Down = 5 })
		elseif code:sub(2, len) == "TD" then
			GameService:Update({ AwayScore = 6 })
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
			GameService:Update({ ClockRunning = false })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Touchdown!", true)
			if DEBOUNCE == true then
				DEBOUNCE = false
				ReplicatedStorage.Touchdown:FireAllClients(player, "Away")
				task.delay(3, function()
					DEBOUNCE = true
				end)
			end
			LiveService:ScoreUpdate("TOUCHDOWN")
			GameService:Update({ Down = 6 })
		elseif code:sub(2, 3) == "TO" then
			if code:sub(4, 4) == "M" then
				if GameService.Values.Away.Timeouts == 0 then
					return
				end

				GameService:Update({ AwayTimeouts = -1 })
				GameService:Update({ ClockRunning = false })
				MessageService:Send(Players:GetPlayers(), player.Name .. ": Timeout Away")
			else
				if GameService.Values.Away.Timeouts == 3 then
					return
				end
				GameService:Update({ ClockRunning = false })
				GameService:Update({ AwayTimeouts = 1 })
			end
		elseif code:sub(2, len) == "SFT" then
			GameService:Update({ AwayScore = 2 })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Safety Away", true)
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
			GameService:Update({ Down = 5 })
		elseif code:sub(2, len) == "2P" then
			GameService:Update({ AwayScore = 2 })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": 2 Point Conversion is Good", true)
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
			GameService:Update({ Down = 5 })
		end
	elseif item == "C" then
		if action == "P" then
			GameService:Update({ ClockValue = tonumber(amount) })
		elseif action == "R" then
			GameService:Update({ ClockValue = (5 * 60) - GameService.Values.Clock.Value })
		elseif code:sub(2, len) == "STP" then
			ReplicatedStorage.ReplayRemote:FireAllClients({ "StopRecord" })
			self:RunClock(false)
		elseif code:sub(2, len) == "STA" then
			self:RunClock(true)
		elseif action == "M" then
			GameService:Update({ ClockValue = -tonumber(amount) })
		end
	elseif item == "P" then
		if code:sub(2, len) == "STA" then
			self.Client.Event:FireAll("Blown")
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Blown", true)
			ReplicatedStorage.ReplayRemote:FireAllClients({ "Record" })
			GameService:WorkspaceBalls()
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
			GameService:Update({ PlayClockValue = 20 - GameService.Values.PlayClock.Value })
		end
	elseif item == "Q" then
		if action == "M" then
			GameService:Update({
				Quarter = GameService.Values.Quarter > 1 and GameService.Values.Quarter - 1 or 1,
			})
		elseif action == "P" then
			GameService:Update({
				Quarter = GameService.Values.Quarter + 1,
			})
		end
	elseif item == "D" then
		if action == "M" then
			GameService:Update({ Down = GameService.Values.Down > 1 and GameService.Values.Down - 1 or 1 })
		elseif action == "P" then
			GameService:Update({ Down = GameService.Values.Down < 5 and GameService.Values.Down + 1 or 5 })
		end
	else
		if code == "K" then
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Completed Pass", true)
		elseif code == "EOQ" then
			GameService:Update({ ClockRunning = false })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": End of Quarter", true)
			LiveService:ScoreUpdate("EOQ")
		elseif code == "FLG" then
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Flag", true)
			self.Client.Event:FireAll("Flag")
		elseif code == "FRC" then
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Fumble Recovery", true)
		elseif code == "INC" then
			GameService:Update({ ClockRunning = false })
			GameService:Update({ Down = 1 })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Incomplete Pass", true)
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
			GameService:Update({ ClockRunning = false })
			GameService:Update({ Down = 1 })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Incomplete, Out of Boundaries", true)

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
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Interception", true)
			self.Client.Event:FireAll("Pos")
			LiveService._intedByHome = GameService:HomeTeamHasBall()
			LiveService:ScoreUpdate("INTERCEPTION")
		elseif code == "LAT" then
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Lateral Pass", true)
		elseif code == "LS" then
			GameService:Update({ ClockRunning = false })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Lag Sack", true)
		elseif code == "OOB" then
			GameService:Update({ ClockRunning = false })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Out of Boundaries", true)
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
			GameService:Update({ Down = 1 })
		elseif code == "RMSG" then
			GameService:Update({ ClockRunning = false })
			MessageService:Send(Players:GetPlayers())
			self.Client.Event:FireAll("Reset")
		elseif code == "RVW" then
			GameService:Update({ ClockRunning = false })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Reviewing the Previous Play", true)
			self.Client.Event:FireAll("Review")
		elseif code == "SACK" then
			GameService:Update({ ClockRunning = false })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Sack", true)
		elseif code == "TB" then
			GameService:Update({ ClockRunning = false })
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Touchback", true)
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
			GameService:Update({ Down = 1 })
		elseif code == "BALLPOS" then
			self.Client.Event:FireAll("Pos")
		elseif code == "FLGDEAD" then
			self:RunClock(false)
			self:RunPC(false)
			MessageService:Send(Players:GetPlayers(), player.Name .. ": Dead Play", true)
			self.Client.Event:FireAll("Flag")
		end
	end
end

function ScoreboardService:SetAutoStop(bool: boolean)
	self._AutoStop = bool
end

function ScoreboardService:RunPC(bool: boolean)
	local GameService = Knit.GetService("GameService")

	if bool and GameService.Values.PlayClock.Running then
		return
	end

	if GameService.Values.PlayClock.Value == 0 then
		return
	end

	if bool then
		GameService:Update({ PlayClockRunning = true })
		ReplicatedStorage.Stats.LastQB.Value = "Off"
		task.delay(0.5, function()
			repeat
				GameService:Update({ PlayClockValue = -1 })
				task.spawn(function()
					GameService.Client.SendValues:FireAll(GameService.Values)
				end)
				task.wait(1)
			until GameService.Values.PlayClock.Running == false or GameService.Values.PlayClock.Value == 0

			GameService:Update({ PlayClockRunning = false })
		end)
	else
		GameService:Update({ PlayClockRunning = false })
	end
end

function ScoreboardService:RunClock(bool: boolean)
	local GameService = Knit.GetService("GameService")
	if bool and GameService.Values.Clock.Running then
		return
	end
	if GameService.Values.Clock.Value == 0 then
		return
	end
	self._AutoStop = false

	if bool then
		GameService:Update({ ClockRunning = true })
		task.delay(0.5, function()
			repeat
				GameService:Update({ ClockValue = -1 })
				task.spawn(function()
					GameService.Client.SendValues:FireAll(GameService.Values)
				end)
				task.wait(1)
			until GameService.Values.Clock.Running == false
				or GameService.Values.Clock.Value == 0
				or self._AutoStop == true
			GameService:Update({ ClockRunning = false })
			self.Client.StopRecord:FireAll()
			GameService:Update({ ClockRunning = false })
			self._AutoStop = false
		end)
	else
		GameService:Update({ ClockRunning = false })
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