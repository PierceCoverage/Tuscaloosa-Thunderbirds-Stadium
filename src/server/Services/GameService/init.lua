local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local GameService
GameService = Knit.CreateService({
	Name = "GameService",
	Client = {
		SendValues = Knit.CreateSignal(),
	},
	Values = {},
})

function GameService:WorkspaceBalls()
	for _, v in pairs(workspace:GetChildren()) do
		if v.Name == "Football" then
			v:Destroy()
		end
	end
end

function GameService:HomeTeamHasBall()
	for _, v in pairs(self.Values.Home.Team:GetPlayers()) do
		if v.Character and v.Character:FindFirstChild("Football") then
			return true
		end
	end
end

function GameService:ClearBalls()
	if self.Values.Ball then
		return self.Values.Ball
	else
		local distanceAllowed = 12

		for i, v in pairs(game.Players:GetChildren()) do
			if v.Character:FindFirstChild("Football") and v.Character["Football"]:IsA("Tool") then
				if
					(v.Character.Football.Handle.Position - workspace.scrimmage.Position).magnitude > distanceAllowed
				then
					v.Character.Football:Destroy()
				end
			end
		end
	end
end

function GameService.Client:Get()
	return self.Server:Get()
end

function GameService:Get()
	return self.Values
end

function GameService:Update(toupdate: table)
	for i, v in pairs(toupdate) do
		if i == "HomeTimeouts" then
			if self.Values.Home.Timeouts + v >= 0 and self.Values.Home.Timeouts + v <= 3 then
				self.Values.Home.Timeouts += v
			end
		elseif i == "HomeTeam" then
			self.Values.Home.Team = v
		elseif i == "HomeScore" then
			if self.Values.Home.Score + v >= 0 then
				self.Values.Home.Score += v
			end
		elseif i == "AwayTimeouts" then
			if self.Values.Away.Timeouts + v >= 0 and self.Values.Away.Timeouts + v <= 3 then
				self.Values.Away.Timeouts += v
			end
		elseif i == "AwayTeam" then
			self.Values.Away.Team = v
		elseif i == "AwayScore" then
			if self.Values.Away.Score + v >= 0 then
				self.Values.Away.Score += v
			end
		elseif i == "ClockRunning" then
			self.Values.Clock.Running = v
		elseif i == "ClockValue" then
			if self.Values.Clock.Value + v >= 0 then
				self.Values.Clock.Value += v
			end
		elseif i == "PlayClockValue" then
			if self.Values.PlayClock.Value + v >= 0 then
				self.Values.PlayClock.Value += v
			end
		elseif i == "PlayClockRunning" then
			self.Values.PlayClock.Running = v
		else
			self.Values[i] = v
		end
	end

	self.Client.SendValues:FireAll(self.Values)
end

function GameService:KnitStart()
	print("GameService Started")
end

function GameService:KnitInit()
	self.Values = require(script.values)

	print("GameService Initialized")
end

return GameService
