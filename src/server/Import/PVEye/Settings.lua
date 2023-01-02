local M = {}--[[

[- WELCOME -]
Thanks for using PhantomVisual's Eye by PhantomVisual!
This script will automatically update!
If you want to see update logs, re-insert the script and check here!
If you run into bugs, PLEASE contact the creator through ROBLOX.

[- LOGS -]
3/26/18 - Created PV's Eye Settings; HBE Settings;
8/15/18 - Created GUI; ScreenWatch; About; AdminCommand; UnAdminCommand; Search box for ScreenWatch;

[- GLOBAL SETTINGS -]
Humiliate		=	<bool> Global message in chat of who cheated

[- SCREENWATCH SETTINGS -]
Enabled			=	<bool>
PVEye_Admins	=	<bool> PV's Eye auto adds trusted moderators
Admins			=	<table> Add custom people who can use screen watching
Command			=	<string> A command you chat to bring up PV's Eye

[- BANS SETTINGS -]
DataStore		= 	<string> Used to store permanent bans
PVEye_Bans		=	<bool> PV's Eye auto bans known cheaters
List			=	<table> Add custom people to the ban list (accepts IDs and Usernames)
KickMessage		= 	<string> Message player gets when kicked

[- STANDARD SETTINGS -]
Enabled			=	<bool>
Punish			=	"None" / "Kick" / "SBan" (ServerBan) / "PBan" (PermanentBan)
KickMessage		=	<string> Message player gets when kicked
MessageSettings	=	{Text (message displayed), Color (color of message), Font (font of message), FontSize (size of font)}
																																																																																																--]]

M.Humiliate = true

M.ScreenWatch = {
	Enabled = true,
	PVEye_Admins = false,
	Admins = { "Ethan_Waike" },
	Command = "/e !pveye",
	AdminCommand = "/e !admin",
	UnAdminCommand = "/e !unadmin",
}

M.Bans = {
	DataStore = "Bans_1",
	PVEye_Bans = false,
	List = {},
	KickMessage = "PVEye Detected: Banned from the game",
}

M.PVEyeSecured = {}

return M
