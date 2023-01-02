local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local LiveService = Knit.CreateService({
	Name = "LiveService",
	Client = {},
	_isGame = false,
	_isPAT = false,
	_intedByHome = false,
})

local updating = false
local old_home_score
local old_away_score
local last_score = nil

function LiveService:GetUpdateType()
	local GameService = Knit.GetService("GameService")

	if not old_home_score then
		old_home_score = GameService.Values["HomeScore"]
	end

	if not old_away_score then
		old_home_score = GameService.Values["AwayScore"]
	end

	local HomeScore = GameService.Values["HomeScore"]
	local AwayScore = GameService.Values["AwayScore"]

	if HomeScore > old_home_score then
		local score_diff = HomeScore - old_home_score
		if score_diff > 0 then
			if score_diff == 1 then
				return "PAT"
			elseif score_diff == 2 then
				if self._isPAT then
					return "2PC"
				else
					return "SAFETY"
				end
			elseif score_diff == 3 then
				return "FIELD GOAL"
			elseif score_diff == 6 then
				return "TOUCHDOWN"
			end
		end
	elseif AwayScore > old_away_score then
		local scoreDif = AwayScore - old_away_score
		if scoreDif > 0 then
			if scoreDif == 1 then
				return "PAT"
			elseif scoreDif == 2 then
				if self._isPAT then
					return "2PC"
				else
					return "SAFETY"
				end
			elseif scoreDif == 3 then
				return "FIELD GOAL"
			elseif scoreDif == 6 then
				return "TOUCHDOWN"
			end
		end
	end
end

local function get_down_message(down) end

local function sendMessage(message, teamData)
	local data = {
		["username"] = teamData.TeamData.Name,
		["content"] = message,
		["avatar_url"] = string.format(
			"https://www.roblox.com/asset-thumbnail/image?assetId=%i&width=420&height=420&format=png",
			teamData.TeamData.Logo
		),
	}

	data = HttpService:JSONEncode(data)
	HttpService:PostAsync(
		"https://NFL-Bot.ethanwaike.repl.co/api/webhooks/1057534055849132113/RTWjtfUftrt2RkB0ZdXYnQlYGJ_wu9mVGIGd_vc1NIGl_iQW5HdJ_nweVU6RCV9cLmp_",
		data
	)
end

function LiveService:ScoreUpdate(update_type)
	if not self._isGame then
		return
	end

	if updating then
		return
	end

	if not update_type then
		update_type = self:GetUpdateType()
	end

	updating = true

	task.wait(5)
	local TeamService = Knit.GetService("TeamService")
	local GameService = Knit.GetService("GameService")
	local Away = GameService.Values.Away
	local Home = GameService.Values.Home

	local HomeScore = Home.Score
	local AwayScore = Away.Score

	local quarter_message = string.format("Q%i", GameService.Values["Quarter"])

	local Clock = GameService.Values["Clock"].Value
	local Minutes = math.floor(Clock / 60)
	local Seconds = Clock % 60

	local clock_message = tostring(Minutes) .. ":" .. (Seconds > 9 and tostring(Seconds) or "0" .. tostring(Seconds))

	local Down = GameService.Values["Down"]
	local down_message = get_down_message(Down)

	local HomeWinning = HomeScore > AwayScore
	local winning_team_emoji = HomeWinning and Home.Team.Name or Away.Team.Name
	local winning_score = HomeWinning and HomeScore or AwayScore
	local losing_team_emoji = HomeWinning and Away.Team.Name or Home.Team.Name
	local losing_score = HomeWinning and AwayScore or HomeScore
	local formatting =
		"⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n%s\n%s %i\n%s %i\n\n`%s | %s | %s`\n⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"
	if update_type == "TOUCHDOWN" then
		local text = "**TOUCHDOWN**"

		if AwayScore ~= old_away_score then
			text = string.upper(text:format(Home.Team.Name))
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				down_message
			)
			sendMessage(message, TeamService:GetTeamData(Away.Team.Name))
			old_away_score = AwayScore
		elseif HomeScore ~= old_home_score then
			text = string.upper(text:format(Home.Team.Name))
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				down_message
			)
			sendMessage(message, TeamService:GetTeamData(Home.Team.Name))

			old_home_score = HomeScore
		end
		self._isPAT = true
	elseif update_type == "EOQ" then
		local text = "**END OF QUARTER**"
		local message = string.format(
			formatting,
			text,
			winning_team_emoji,
			winning_score,
			losing_team_emoji,
			losing_score,
			quarter_message,
			clock_message,
			down_message
		)
		local id

		if AwayScore > HomeScore then
			id = TeamService:GetTeamData(Away.Team.Name)
		else
			id = TeamService:GetTeamData(Home.Team.Name)
		end

		sendMessage(message, id)
	elseif update_type == "INTERCEPTION" then
		local text = "**INTERCEPTION**"
		if self.intedByHome then
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Home.Team.Name))
		else
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Away.Team.Name))
		end
		self._isPAT = false
	elseif update_type == "PAT" then --must be manually called
		local text = "**PAT GOOD**"
		if AwayScore ~= old_away_score then
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Away.Team.Name))

			old_away_score = AwayScore
		elseif HomeScore ~= old_home_score then
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Home.Team.Name))

			old_home_score = HomeScore
		end
		if _G.fdnum == 1 then
			workspace.down.P.CFrame = CFrame.new(-150 + 90, workspace.down.P.Position.Y, workspace.down.P.Position.Z)
				* CFrame.Angles(0, math.rad(-90), 0)
			workspace.F.P.CFrame = CFrame.new(0, workspace.F.P.Position.Y, workspace.F.P.Position.Z)
				* CFrame.Angles(0, math.rad(-90), 0)
		elseif _G.fdnum == -1 then
			workspace.down.P.CFrame = CFrame.new(150 - 90, workspace.down.P.Position.Y, workspace.down.P.Position.Z)
				* CFrame.Angles(0, math.rad(-90), 0)
			workspace.F.P.CFrame = CFrame.new(0, workspace.F.P.Position.Y, workspace.F.P.Position.Z)
				* CFrame.Angles(0, math.rad(-90), 0)
		end
		_G.fdnum *= -1
		self._isPAT = false
	elseif update_type == "2PC" then
		local text = "**2-POINT CONVERSION**"
		if AwayScore ~= old_away_score then
			if last_score == Home.Team.Name then
				--if last score was home team but now away team got 2pc
				self:scoreUpdate("2PCRET")
				return
			end

			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Away.Team.Name))

			old_away_score = AwayScore
		elseif HomeScore ~= old_home_score then
			if last_score == Away.Team.Name then
				self:ScoreUpdate("2PCRET")
				return
			end

			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Home.Team.Name))

			old_home_score = HomeScore
		end
		self._isPAT = false
	elseif update_type == "2PCNG" then
		local text = "**2-POINT CONVERSION FAILED**"
		if last_score == Away.Team.Name then
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Away.Team.Name))

			old_away_score = AwayScore
		elseif last_score == Home.Team.Name then
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Home.Team.Name))

			old_home_score = HomeScore
		end
		self._isPAT = false
	elseif update_type == "2PCRET" then
		local text = "**2-POINT CONVERSION INTERCEPTED AND RETURNED FOR 2**"
		if AwayScore ~= old_away_score then
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Away.Team.Name))

			old_away_score = AwayScore
		elseif HomeScore ~= old_home_score then
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Home.Team.Name))

			old_home_score = HomeScore
		end
		self._isPAT = false
	elseif update_type == "SAFETY" then
		local text = "**SAFETY**"
		if AwayScore ~= old_away_score then
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Away.Team.Name))

			old_away_score = AwayScore
		elseif HomeScore ~= old_home_score then
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Home.Team.Name))

			old_home_score = HomeScore
		end
		self._isPAT = false
	elseif update_type == "FIELD GOAL" then
		local text = "**FIELD GOAL**"
		if AwayScore ~= old_away_score then
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Away.Team.Name))
			old_away_score = AwayScore
		elseif HomeScore ~= old_home_score then
			local message = string.format(
				formatting,
				text,
				winning_team_emoji,
				winning_score,
				losing_team_emoji,
				losing_score,
				quarter_message,
				clock_message,
				"Kickoff"
			)
			sendMessage(message, TeamService:GetTeamData(Home.Team.Name))
			old_home_score = HomeScore
		end
		self._isPAT = false
		--does not take priority!
	else
		--	local text = "**SCORE UPDATE**"
		--	local message = string.format(formatting, text, winning_team_emoji, winning_score, losing_team_emoji, losing_score, quarter_message, clock_message, down_message,)
		--	sendMessage(message)
	end
	updating = false
end

function LiveService:Game(bool: boolean)
	self._isGame = bool
end

function LiveService:KnitStart()
	print("LiveService Started")
end

function LiveService:KnitInit()
	print("LiveService Initialized")
end

return LiveService
