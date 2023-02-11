Commands, Service, Config = nil, nil, nil

return function()
	Commands.Create({
		Name = "bench",
		Aliases = { "bench", "ben" },
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
					players.PlayerInformation.Benched.Value = false
				elseif players.PlayerInformation.Benched.Value == false then
					players.PlayerInformation.Benched.Value = true
					if players.Team.Name == TeamService:GetHomeTeam().Name then -- home team
						local newPos = workspace.Worksapce.Field.Sideline.hSidelines.Teleport
						players.Character:WaitForChild("HumanoidRootPart").CFrame =
							CFrame.new(newPos.CFrame.X, newPos.CFrame.Y + 3, newPos.CFrame.Z)
					elseif players.Team.Name == TeamService:GetAwayTeam().Name then -- away team
						local newPos = workspace.Worksapce.Field.Sideline.aSidelines.Teleport
						players.Character:WaitForChild("HumanoidRootPart").CFrame =
							CFrame.new(newPos.CFrame.X, newPos.CFrame.Y + 3, newPos.CFrame.Z)
					end
				end
			end
		end,
	})
end
