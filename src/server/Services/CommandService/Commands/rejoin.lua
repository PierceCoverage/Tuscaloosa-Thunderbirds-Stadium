local TeleportService = game:GetService("TeleportService")

return {
	name = "rejoin",
	aliases = { "rejoin", "rj" },
	callback = function(player)
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
	end,
}
