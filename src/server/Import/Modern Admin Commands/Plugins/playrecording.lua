local Plugin = {

	PlayRecord = {
		Commands = {"replay"};-- Commands
		Args = {};-- Command arguments | Use 'player' if the argument is a player (# evasion)
		Description = "replays the play";-- Command Description
		Hidden = false; -- Is it hidden from the command list? --WIP
		Fun = false;-- Is it fun? -- WIP
		AdminLevel = "Admins";    -- Admin level; Moderators, Admins, Owners, Creators
		Function = function(plr,args)
			if plr.Team == game.Teams.Referee then
				game.ReplicatedStorage.ReplayRemote:FireAllClients({'PlayRecord'})
			end
		end
	};
};
return Plugin
