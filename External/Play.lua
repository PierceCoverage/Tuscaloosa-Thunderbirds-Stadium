Commands, Service, Config = nil, nil, nil

return function()
	Commands.Create({
		Name = "newplay",
		Aliases = { "newplay", "play" },
		Level = 3,
		Disabled = false,
		Category = "Package",
		Args = {},
		Run = function(plr, args)
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local Knit = require(ReplicatedStorage.Packages.Knit)
			local TeamService = Knit.GetService("TeamService")
			print("ran")
			for indexed, players in pairs(Service.GetPlayers(plr, args[1])) do
				if players.PlayerInformation.Benched.Value == true then
					return
				elseif players.PlayerInformation.Benched.Value == false then
					if players.Team.Name == TeamService:GetHomeTeam().Name then -- home team
					elseif players.Team.Name == TeamService:GetAwayTeam().Name then -- away team
					end
				end
			end
		end,
	})
end
