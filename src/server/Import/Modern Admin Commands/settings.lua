local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local TeamService = Knit.GetService("TeamService")

local HomeTeam = TeamService._HomeTeam
local League = HomeTeam.LeagueData.League

local settings = {

	ToolLocation = game.ServerStorage.Tools,

	DebugAdmin = true, -- Gives me creator admin to debug

	MainScript = 11886224229, -- Don't change unless you know what you're doing

	Prefix = ":",

	GroupId = 0,

	Creators = { "Ethan_Waike", "RNF", "Gallic" }, -- Username:UserID'

	Owners = {},

	Admins = {},

	Moderators = {},

	Banned = {},

	CommandPerms = {},

	GroupAdmin = {
		"16519943:255:Owners:false", --Com
		"16519943:254:Owners:false", --CC
		"16519943:253:Owners:false", --LT
	}, -- GroupID:GroupRank:AdminLevel:AllAboveRanksIncluded

	BanMessage = "You are banned.",

	LockMessage = {}, --Slock WIP

	LogLimit = 1000,
}

if game.PrivateServerOwnerId ~= 0 then
	local username = Players:GetNameFromUserIdAsync(game.PrivateServerOwnerId)
	table.insert(settings.Creators, username)
end

return settings
