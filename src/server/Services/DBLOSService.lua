local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local DBLOSService = Knit.CreateService({
	Name = "DBLOSService",
	Client = {},
	Players = {},
})

function DBLOSService.Client:Fire(player: Player)
	return DBLOSService.Server:Fire(player)
end

function DBLOSService:Fire(player: Player)
	local ChainsService = Knit.GetService("ChainsService")
	local GameService = Knit.GetService("GameService")
	local IndicatorService = Knit.GetService("IndicatorService")

	if player.TeamColor == GameService.Values.Home.Team or player.TeamColor == GameService.Values.Away.Team then
		if
			player.Character
			and player.Character.HumanoidRootPart.Position.Z < 80
			and player.Character.HumanoidRootPart.Position.Z > -80
			and player.Character.HumanoidRootPart.Position.X < 180
			and player.Character.HumanoidRootPart.Position.X > -180
			and player.Character.HumanoidRootPart.Position.X
			and (GameService.Values["DBLOS"][player.Name])
		then
			if
				IndicatorService._Direction == 1
				and player.Character.HumanoidRootPart.Position.X > ChainsService.down.Position.X
			then
				local old_value = GameService.Values["DBLOS"]
				table.insert(old_value, player.Name)
				GameService:Update("DBLOS", old_value)
				task.delay(5, function()
					old_value = GameService.Values["DBLOS"]
					for i, v in pairs(old_value) do
						if v == player.Name then
							table.remove(old_value, i)
						end
					end
					GameService:Update("DBLOS", old_value)
				end)
			elseif
				IndicatorService._Direction == -1
				and player.Character.HumanoidRootPart.Position.X < ChainsService.down.Position.X
			then
				table.insert(self.Players, player.Name)

				task.wait(5)

				for i, v in pairs(self.Players) do
					if v == player.Name then
						table.remove(self.Players, i)
					end
				end
			end
		end
	end
end

function DBLOSService:KnitStart()
	print("DBLOSService Started")
end

function DBLOSService:KnitInit()
	print("DBLOSService Initialized")
end

return DBLOSService
