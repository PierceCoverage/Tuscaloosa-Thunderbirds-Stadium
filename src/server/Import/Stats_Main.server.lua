--local data = game:GetService("DataStoreService"):GetDataStore("GameStats");

local AwayTDYards = 0
local HomeTDYards = 0
local TDYards = 0
local LastPlayTD = false
local Down = game.ReplicatedStorage.GameValues.Down
local clock
local DownDistance = "1st down"

local FBStats = game.ReplicatedStorage.Stats
local NextTouch = FBStats.Touchdown.NextTouch
local TouchdownPlayer = FBStats.Touchdown.Player
local LastQB = FBStats.LastQB
local LastC = FBStats.LastC
local CurrentTackler = " "
local CurrentTackled

local YardLine = FBStats.YardLine
local StatYard = FBStats.StatYard
local FieldPosGen = workspace.Field['Field Grass'].FieldSize.Position
local LOSPosGen = workspace.scrimmage

local serverNumber = 0
local currentServerData = {}

--pcall(function()
--	local placeTable = data:GetAsync(game.PlaceId)
--	print(#placeTable)
--	serverNumber = #placeTable + 1
--	print("Server Number: "..tostring(serverNumber))
--end)

if game.ReplicatedStorage:WaitForChild('Stats').ClockRunning.Value then
	clock = true
else
	clock = false
end

FBStats.ClockRunning.Changed:connect(function()
	if game.ReplicatedStorage.Stats.ClockRunning.Value then
		clock = true
	else
		clock = false
	end
end)

function ChangeDown()
	if Down.Value == 1 then
		DownDistance = "1st down"
	elseif Down.Value == 2 then
		DownDistance = "2nd down"
	elseif Down.Value == 3 then
		DownDistance = "3rd down"
	elseif Down.Value == 4 then
		DownDistance = "4th down"
	end
end


FBStats.Event.Event:connect(function(arg, tackler, tackled)
	wait(.2)
	if clock and arg == "Tackle" then
		----------- Tackled -----------
		local StatText = ""
		local int = false
		local lastQBPlr = game.Players:FindFirstChild(LastQB.Value)
		local TackledPlr = game.Players:FindFirstChild(tackled)
		local FieldPos = FieldPosGen.X
		local LOSPos = LOSPosGen.Position.X
		LastPlayTD = false
		ChangeDown()
		if LastQB.Value == "Off" then
			if StatYard.Value < 0 then
				if (FieldPos + 150) - YardLine.Value < 0 or YardLine.Value - (FieldPos - 150) < 0 then
					StatText = (tackled .. " safetied by " .. tackler .. (" for ") .. (StatYard.Value) .. (" yards on ").. DownDistance)
				else
					if StatYard.Value > -3 then
						StatText = (tackled .. " tackled for loss by " .. tackler .. (" for ") .. (StatYard.Value) .. (" yards on ").. DownDistance)
					else
						StatText = (tackled .. " sacked by " .. tackler .. (" for ") .. (StatYard.Value) .. (" yards on ").. DownDistance)
					end
				end
			else
				if (FieldPos + 150) - YardLine.Value < 0 or YardLine.Value - (FieldPos - 150) < 0 then
					if _G.fdnum == -1 then
						TDYards = math.floor((math.floor((LOSPos)-(FieldPos - 150))/3)+.5)
					else
						TDYards = math.floor((math.floor(FieldPos + 150-(LOSPos))/3)+.5)
					end
					StatText =  (tackled .. " rushes " .. (TDYards) .. (" yards for a TD on ").. DownDistance)
					LastPlayTD = true
				else
					StatText = (tackled .. " rushes for " .. (StatYard.Value) .. (" yards on ").. DownDistance)
				end
			end
		elseif lastQBPlr.TeamColor ~= TackledPlr.TeamColor then
			int = true
			if (FieldPos + 150) - YardLine.Value < 0 or YardLine.Value - (FieldPos - 150) < 0 then
				if _G.fdnum == 1 and (FieldPos + 150 - YardLine.Value < 0) then
					StatText = ((LastQB.Value) .. " intercepted by " .. tackled .. ", touchback on "..DownDistance)
				elseif _G.fdnum == -1 and (YardLine.Value - (FieldPos - 150) < 0) then
					StatText = ((LastQB.Value) .. " intercepted by " .. tackled .. ", touchback on "..DownDistance)
				else
					StatText = ((LastQB.Value) .. " intercepted by " .. tackled.. " for a TD on "..DownDistance)
					LastPlayTD = true
				end
			else
				StatText = ((LastQB.Value) .. " intercepted by " .. tackled .. " on "..DownDistance)
			end
		else 
			if FieldPos + 150 - YardLine.Value < 0 or YardLine.Value - (FieldPos - 150) < 0 then
				if StatYard.Value < 0 then
					StatText = (tackled .. " saftied by " .. tackler .. (" for ") .. (StatYard.Value) .. (" yards on ").. DownDistance)
				else
					if _G.fdnum == -1 then
						TDYards = math.floor((math.floor(LOSPos-(FieldPos - 150))/3)+.5)
					elseif _G.fdnum == 1 then
						TDYards = math.floor((math.floor(FieldPos + 150-LOSPos)/3)+.5)
					end
					StatText = ((LastQB.Value) .. " to " .. tackled .. " for a " .. (TDYards) .. " yard TD on ".. DownDistance)
					LastPlayTD = true
				end
			else
				StatText = ((LastQB.Value) .. " to " .. tackled .. " for " .. (StatYard.Value) .. " yards on ".. DownDistance)
			end
		end
		FBStats.RemoteEvent:FireAllClients("StatDisplay",StatText)
	elseif clock and arg == "OOB" then
		----------- Ran OOB -----------
		task.wait(.1)
		local StatText = ""
		local int = false
		local lastQBPlr = game.Players:FindFirstChild(LastQB.Value)
		local TackledPlr = game.Players:FindFirstChild(tackled.Name)
		local FieldPos = FieldPosGen.X
		local LOSPos = LOSPosGen.Position.X
		LastPlayTD = false
		ChangeDown()
		if LastQB.Value == "Off" then
			if StatYard.Value < 0 then
				if (FieldPos + 150) - YardLine.Value < 0 or YardLine.Value - (FieldPos - 150) < 0 then
					StatText = (tackled.Name .. " runs OOB, safety")
				else
					StatText = (tackled.Name .. " runs OOB, loss of " .. (StatYard.Value) .. (" yards"))
				end
			else
				if (FieldPos + 150) - YardLine.Value < 0 or YardLine.Value - (FieldPos - 150) < 0 then
					if _G.fdnum == -1 then
						TDYards = math.floor((math.floor((LOSPos)-(FieldPos - 150))/3)+.5)
					else
						TDYards = math.floor((math.floor(FieldPos + 150-(LOSPos))/3)+.5)
					end
					StatText =  (tackled.Name .. " rushes " .. (TDYards) .. ("y for a TD"))
					LastPlayTD = true
				else
					StatText = (tackled.Name .. " rushes for " .. (StatYard.Value) .. (" yards on ").. DownDistance)
				end
			end
			---finished above
		elseif lastQBPlr.TeamColor ~= TackledPlr.TeamColor then
			int = true
			if (FieldPos + 150) - YardLine.Value < 0 or YardLine.Value - (FieldPos - 150) < 0 then
				if _G.fdnum == 1 and (FieldPos + 150 - YardLine.Value < 0) then
					StatText = ((LastQB.Value) .. " intercepted by " .. tackled.Name .. ", touchback on "..DownDistance .. " (OOB)")
				elseif _G.fdnum == -1 and (YardLine.Value - (FieldPos - 150) < 0) then
					StatText = ((LastQB.Value) .. " intercepted by " .. tackled.Name .. ", touchback on "..DownDistance .. " (OOB)")
				else
					StatText = ((LastQB.Value) .. " intercepted by " .. tackled.Name .. " for a TD on "..DownDistance .. " (OOB)")
					LastPlayTD = true
				end
			else
				StatText = ((LastQB.Value) .. " intercepted by " .. tackled.Name .. " on "..DownDistance .. " (OOB)")
			end
		else
			if FieldPos + 150 - YardLine.Value < 0 or YardLine.Value - (FieldPos - 150) < 0 then
				if StatYard.Value < 0 then
					StatText = (tackled.Name .. " runs OOB, safety")
				else
					if _G.fdnum == -1 then
						TDYards = math.floor((math.floor((LOSPos)-(FieldPos - 150))/3)+.5)
					elseif _G.fdnum == 1 then
						TDYards = math.floor((math.floor(FieldPos + 150-(LOSPos))/3)+.5)
					end
					StatText = ((LastQB.Value) .. " to " .. tackled.Name .. " for a " .. (TDYards) .. " y TD on ".. DownDistance .. " (OOB)")
					LastPlayTD = true
				end
			else
				StatText = ((LastQB.Value) .. " to " .. tackled.Name .. " for " .. (StatYard.Value) .. " yards on ".. DownDistance .. " (OOB)")
			end
		end
		FBStats.RemoteEvent:FireAllClients("StatDisplay",StatText)
	end
end)


--game.ReplicatedStorage:WaitForChild('Stats').RemoteEvent.OnClientEvent:Connect(function(arg1)
--	if arg1 == "HomeTD" or arg1 == "AwayTD" then
--		if LastPlayTD == false then
--			if _G.fdnum == -1 then
--				AwayTDYards = math.floor((math.floor((game.Workspace.scrimmage.Position.Z)-(workspace.Field.Main.Position.Z-150))/3)+.5)
--			elseif _G.fdnum == 1 then
--				AwayTDYards = math.floor((math.floor(workspace.Field.Main.Position.Z+150-(game.Workspace.scrimmage.Position.Z))/3)+.5)
--			end
--		end
--		local int = false
--		local lastQBPlr = game.Players:FindFirstChild(LastQB.Value)
--		local Receiver = game.ReplicatedStorage.Stats.Touchdown.Player.Value
--		CurrentTackled = game.Players:FindFirstChild(game.ReplicatedStorage.ACC_Global.Touchdown.Player.Value)
--		local locateReceiver = game.Players:FindFirstChild(Receiver)
--		if LastQB.Value == "Off" then
--			StatText = (Receiver .. " rushes " .. (AwayTDYards) .. ("y for a TD"))
--		elseif CurrentTackled and lastQBPlr.TeamColor ~= CurrentTackled.TeamColor then
--			StatText = (LastQB.Value .. " intercepted by " .. Receiver .. " for a TD")
--		else
--			StatText = (LastQB.Value .. " to " .. Receiver .. " for a " .. (AwayTDYards) .. "y TD")
--		end
--	elseif arg1 == "Incomplete" then
--		local lastQBPlr = game.Players:FindFirstChild(LastQB.Value)
--		if lastQBPlr then
--			StatText = LastQB.Value .. " throws an incomplete pass on " .. DownDistance
--		end
--	end
--end)