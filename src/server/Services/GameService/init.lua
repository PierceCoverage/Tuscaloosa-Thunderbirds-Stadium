local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local GameService = Knit.CreateService({
	Name = "GameService",
	Client = {},
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
	for _, v in pairs(self.Values.HomeTeam:GetPlayers()) do
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

function GameService.Client:Get(Key)
	return GameService.Server.Values[Key]
end

function GameService:UpdateValue(toupdate: table)
	for i, v in pairs(toupdate) do
		self.Values[i] = v
	end
end

function GameService:KnitStart()
	print("GameService Started")
end

function GameService:KnitInit()
	self.Values = require(script.values)
	print("GameService Initialized")
end

return GameService
