local TeleportService = game:GetService("TeleportService")

return {
	name = "refresh",
	aliases = { "refresh", "re" },
	callback = function(player)
		if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local cframe = player.Character.HumanoidRootPart.CFrame

			if cframe then
				task.spawn(function()
					local character = player.CharacterAdded:Wait()
					local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
					task.wait()
					HumanoidRootPart.CFrame = cframe
				end)

				player:LoadCharacter()
			end
		end
	end,
}
