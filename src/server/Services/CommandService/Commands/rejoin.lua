return {
	name = "rejoin",
	aliases = { "rejoin", "rj" },
	callback = function(player)
		local Players = game:GetService("Players")
		local TeleportService = game:GetService("TeleportService")
		local data = {
			id = player.UserId,
			cframe = (player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
					and player.Character:FindFirstChild("HumanoidRootPart").CFrame
				or nil,
			Team = player.Team,
		}

		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)

		while player and player.Parent == Players do
			task.wait()
		end

		local start = tick()

		local connection
		connection = Players.PlayerAdded:Connect(function(player)
			if player.UserId == data.id then
				player.Team = data.Team
				if data.cframe then
					local character = player.CharacterAdded:Wait()
					task.wait()
					character:WaitForChild("HumanoidRootPart").CFrame = data.cframe
				end
				connection:Disconnect()
			elseif tick() - start > 20 then
				connection:Disconnect()
			end
		end)
	end,
}
