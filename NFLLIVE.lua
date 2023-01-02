local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TeamService = Knit.GetService("TeamService")
local GameService = Knit.GetService("GameService")

local TeamInformation = require(ReplicatedStorage.Assets.Modules.TeamInformation)
local League = TeamInformation:GetHomeTeam().LeagueData.League

local oldAwayScore = GameService.Values["AwayScore"]
local oldHomeScore = GameService.Values["HomeScore"]

local url =
	"https://NFL-Bot.ethanwaike.repl.co/api/webhooks/1057534055849132113/RTWjtfUftrt2RkB0ZdXYnQlYGJ_wu9mVGIGd_vc1NIGl_iQW5HdJ_nweVU6RCV9cLmp_"
--[[

:eagles_secondary: 31 (Pos)
:thunderbirds~3: 22

The :thunderbirds: scored a touchdown!
Q4 | 2:20 | PAT

]]

local formatting =
	"⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯\n%s\n%s %i\n%s %i\n\n`%s | %s | %s`\n⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯"

local quarterFormat = "Q%i"

local lastScore = nil
local updating = false
shared.intedByHome = false
shared.isGame = false
shared.isPAT = false


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
	HttpService:PostAsync(url, data)
end

function shared:scoreUpdate(updateType)
	if shared.isGame then
		if updating then
			return
		end
		updating = true
		task.wait(5)
		--figure out updateType
		if not updateType then
			if GameService.Values["HomeScore"] > oldHomeScore then
				local scoreDif = GameService.Values["HomeScore"] - oldHomeScore
				if scoreDif > 0 then
					if scoreDif == 1 then
						updateType = "PAT"
					elseif scoreDif == 2 then
						if shared.isPAT then
							updateType = "2PC"
						else
							updateType = "SAFETY"
						end
					elseif scoreDif == 3 then
						updateType = "FIELD GOAL"
					elseif scoreDif == 6 then
						updateType = "TOUCHDOWN"
					end
				end
			elseif GameService.Values["AwayScore"] > oldAwayScore then
				local scoreDif = GameService.Values["AwayScore"] - oldAwayScore
				if scoreDif > 0 then
					if scoreDif == 1 then
						updateType = "PAT"
					elseif scoreDif == 2 then
						if shared.isPAT then
							updateType = "2PC"
						else
							updateType = "SAFETY"
						end
					elseif scoreDif == 3 then
						updateType = "FIELD GOAL"
					elseif scoreDif == 6 then
						updateType = "TOUCHDOWN"
					end
				end
			end
		end

		local quarterMessage = string.format(quarterFormat, GameService.Values["Quarter"])

		local Value = GameService.Values["Clock"]
		local Minutes = math.floor(Value / 60)
		local Seconds = Value % 60

		local clockMessage = tostring(Minutes) .. ":" .. (Seconds > 9 and tostring(Seconds) or "0" .. tostring(Seconds))

		local Value = GameService.Values["Down"]
		local downMessage = ""
		if Value == 1 then
			downMessage = "1st Down"
		elseif Value == 2 then
			downMessage = "2nd Down"
		elseif Value == 3 then
			downMessage = "3rd Down"
		elseif Value == 4 then
			downMessage = "4th Down"
		elseif Value == 5 then
			downMessage = "Kickoff"
		elseif Value == 6 then
			downMessage = "PAT"
		else
			downMessage = "Kickoff"
		end

		local winningTeamEmoji
		local winningScore --Home or Away
		local losingTeamEmoji
		local losingScore

		if GameService.Values["HomeScore"] > GameService.Values["AwayScore"] then
			winningTeamEmoji = TeamService._HomeTeam.Name
			winningScore = GameService.Values["HomeScore"]
			losingTeamEmoji = TeamService._AwayTeam.Name
			losingScore = GameService.Values["AwayScore"]
		else
			winningTeamEmoji = TeamService._AwayTeam.Name
			winningScore = GameService.Values["AwayScore"]
			losingTeamEmoji = TeamService._HomeTeam.Name
			losingScore = GameService.Values["HomeScore"]
		end

		if updateType == "TOUCHDOWN" then
			local text = "**TOUCHDOWN**"

			if GameService.Values["AwayScore"] ~= oldAwayScore then
				text = string.upper(text:format(TeamService._HomeTeam.Name))
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					downMessage
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._AwayTeam.Name))
				oldAwayScore = GameService.Values["AwayScore"]
			elseif GameService.Values["HomeScore"] ~= oldHomeScore then
				text = string.upper(text:format(TeamService._HomeTeam.Name))
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					downMessage
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._HomeTeam.Name))

				oldHomeScore = GameService.Values["HomeScore"]
			end
			shared.isPAT = true
		elseif updateType == "EOQ" then
			local text = "**END OF QUARTER**"
			local message = string.format(
				formatting,
				text,
				winningTeamEmoji,
				winningScore,
				losingTeamEmoji,
				losingScore,
				quarterMessage,
				clockMessage,
				downMessage
			)
			local id

			if GameService.Values["AwayScore"] > GameService.Values["HomeScore"] then
				id = TeamInformation:GetTeamData(TeamService._AwayTeam.Name)
			else
				id = TeamInformation:GetTeamData(TeamService._HomeTeam.Name)
			end

			sendMessage(message, id)
		elseif updateType == "INTERCEPTION" then
			local text = "**INTERCEPTION**"
			if shared.intedByHome then
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._HomeTeam.Name))
			else
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._AwayTeam.Name))
			end
			shared.isPAT = false
		elseif updateType == "PAT" then --must be manually called
			local text = "**PAT GOOD**"
			if GameService.Values["AwayScore"] ~= oldAwayScore then
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._AwayTeam.Name))

				oldAwayScore = GameService.Values["AwayScore"]
			elseif GameService.Values["HomeScore"] ~= oldHomeScore then
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._HomeTeam.Name))

				oldHomeScore = GameService.Values["HomeScore"]
			end
			if _G.fdnum == 1 then
				workspace.down.P.CFrame = CFrame.new(
					-150 + 90,
					workspace.down.P.Position.Y,
					workspace.down.P.Position.Z
				) * CFrame.Angles(0, math.rad(-90), 0)
				workspace.F.P.CFrame = CFrame.new(0, workspace.F.P.Position.Y, workspace.F.P.Position.Z)
					* CFrame.Angles(0, math.rad(-90), 0)
			elseif _G.fdnum == -1 then
				workspace.down.P.CFrame = CFrame.new(150 - 90, workspace.down.P.Position.Y, workspace.down.P.Position.Z)
					* CFrame.Angles(0, math.rad(-90), 0)
				workspace.F.P.CFrame = CFrame.new(0, workspace.F.P.Position.Y, workspace.F.P.Position.Z)
					* CFrame.Angles(0, math.rad(-90), 0)
			end
			_G.fdnum *= -1
			shared.isPAT = false
		elseif updateType == "2PC" then
			local text = "**2-POINT CONVERSION**"
			if GameService.Values["AwayScore"] ~= oldAwayScore then
				if lastScore == TeamService._HomeTeam.Name then
					--if last score was home team but now away team got 2pc
					shared:scoreUpdate("2PCRET")
					return
				end

				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._AwayTeam.Name))

				oldAwayScore = GameService.Values["AwayScore"]
			elseif GameService.Values["HomeScore"] ~= oldHomeScore then
				if lastScore == TeamService._AwayTeam.Name then
					shared:scoreUpdate("2PCRET")
					return
				end

				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._HomeTeam.Name))

				oldHomeScore = GameService.Values["HomeScore"]
			end
			shared.isPAT = false
		elseif updateType == "2PCNG" then
			local text = "**2-POINT CONVERSION FAILED**"
			if lastScore == TeamService._AwayTeam.Name then
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._AwayTeam.Name))

				oldAwayScore = GameService.Values["AwayScore"]
			elseif lastScore == TeamService._HomeTeam.Name then
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._HomeTeam.Name))

				oldHomeScore = GameService.Values["HomeScore"]
			end
			shared.isPAT = false
		elseif updateType == "2PCRET" then
			local text = "**2-POINT CONVERSION INTERCEPTED AND RETURNED FOR 2**"
			if GameService.Values["AwayScore"] ~= oldAwayScore then
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._AwayTeam.Name))

				oldAwayScore = GameService.Values["AwayScore"]
			elseif GameService.Values["HomeScore"] ~= oldHomeScore then
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._HomeTeam.Name))

				oldHomeScore = GameService.Values["HomeScore"]
			end
			shared.isPAT = false
		elseif updateType == "SAFETY" then
			local text = "**SAFETY**"
			if GameService.Values["AwayScore"] ~= oldAwayScore then
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._AwayTeam.Name))

				oldAwayScore = GameService.Values["AwayScore"]
			elseif GameService.Values["HomeScore"] ~= oldHomeScore then
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._HomeTeam.Name))

				oldHomeScore = GameService.Values["HomeScore"]
			end
			shared.isPAT = false
		elseif updateType == "FIELD GOAL" then
			local text = "**FIELD GOAL**"
			if GameService.Values["AwayScore"] ~= oldAwayScore then
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._AwayTeam.Name))
				oldAwayScore = GameService.Values["AwayScore"]
			elseif GameService.Values["HomeScore"] ~= oldHomeScore then
				local message = string.format(
					formatting,
					text,
					winningTeamEmoji,
					winningScore,
					losingTeamEmoji,
					losingScore,
					quarterMessage,
					clockMessage,
					"Kickoff"
				)
				sendMessage(message, TeamInformation:GetTeamData(TeamService._HomeTeam.Name))
				oldHomeScore = GameService.Values["HomeScore"]
			end
			shared.isPAT = false
			--does not take priority!
		else
			--	local text = "**SCORE UPDATE**"
			--	local message = string.format(formatting, text, winningTeamEmoji, winningScore, losingTeamEmoji, losingScore, quarterMessage, clockMessage, downMessage)
			--	sendMessage(message)
		end
		updating = false
	end
end

while task.wait(5) do
	shared:scoreUpdate()
end
