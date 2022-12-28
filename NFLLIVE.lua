local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local TeamInformation = require(ReplicatedStorage.Assets.Modules.TeamInformation)
local League = TeamInformation:GetHomeTeam().LeagueData.League

local GameValues = ReplicatedStorage:WaitForChild("GameValues")
local AwayScore = GameValues.AwayScore
local HomeScore = GameValues.HomeScore

local oldAwayScore = AwayScore.Value
local oldHomeScore = HomeScore.Value

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
			if HomeScore.Value > oldHomeScore then
				local scoreDif = HomeScore.Value - oldHomeScore
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
			elseif AwayScore.Value > oldAwayScore then
				local scoreDif = AwayScore.Value - oldAwayScore
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

		local quarterMessage = string.format(quarterFormat, GameValues.Quarter.Value)

		local Value = GameValues.Clock.Value
		local Minutes = math.floor(Value / 60)
		local Seconds = Value % 60

		local clockMessage = tostring(Minutes) .. ":" .. (Seconds > 9 and tostring(Seconds) or "0" .. tostring(Seconds))

		local Value = GameValues.Down.Value
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

		if HomeScore.Value > AwayScore.Value then
			winningTeamEmoji = GameValues.Home.Value.Name
			winningScore = GameValues.HomeScore.Value
			losingTeamEmoji = GameValues.Away.Value.Name
			losingScore = GameValues.AwayScore.Value
		else
			winningTeamEmoji = GameValues.Away.Value.Name
			winningScore = GameValues.AwayScore.Value
			losingTeamEmoji = GameValues.Home.Value.Name
			losingScore = GameValues.HomeScore.Value
		end

		if updateType == "TOUCHDOWN" then
			local text = "**TOUCHDOWN**"

			if AwayScore.Value ~= oldAwayScore then
				text = string.upper(text:format(GameValues.Home.Value.Name))
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Away.Value.Name))
				oldAwayScore = AwayScore.Value
			elseif HomeScore.Value ~= oldHomeScore then
				text = string.upper(text:format(GameValues.Home.Value.Name))
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Home.Value.Name))

				oldHomeScore = HomeScore.Value
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

			if GameValues.AwayScore.Value > GameValues.HomeScore.Value then
				id = TeamInformation:GetTeamData(GameValues.Away.Value.Name)
			else
				id = TeamInformation:GetTeamData(GameValues.Home.Value.Name)
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Home.Value.Name))
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Away.Value.Name))
			end
			shared.isPAT = false
		elseif updateType == "PAT" then --must be manually called
			local text = "**PAT GOOD**"
			if AwayScore.Value ~= oldAwayScore then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Away.Value.Name))

				oldAwayScore = AwayScore.Value
			elseif HomeScore.Value ~= oldHomeScore then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Home.Value.Name))

				oldHomeScore = HomeScore.Value
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
			if AwayScore.Value ~= oldAwayScore then
				if lastScore == GameValues.Home.Value.Name then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Away.Value.Name))

				oldAwayScore = AwayScore.Value
			elseif HomeScore.Value ~= oldHomeScore then
				if lastScore == GameValues.Away.Value.Name then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Home.Value.Name))

				oldHomeScore = HomeScore.Value
			end
			shared.isPAT = false
		elseif updateType == "2PCNG" then
			local text = "**2-POINT CONVERSION FAILED**"
			if lastScore == GameValues.Away.Value.Name then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Away.Value.Name))

				oldAwayScore = AwayScore.Value
			elseif lastScore == GameValues.Home.Value.Name then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Home.Value.Name))

				oldHomeScore = HomeScore.Value
			end
			shared.isPAT = false
		elseif updateType == "2PCRET" then
			local text = "**2-POINT CONVERSION INTERCEPTED AND RETURNED FOR 2**"
			if AwayScore.Value ~= oldAwayScore then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Away.Value.Name))

				oldAwayScore = AwayScore.Value
			elseif HomeScore.Value ~= oldHomeScore then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Home.Value.Name))

				oldHomeScore = HomeScore.Value
			end
			shared.isPAT = false
		elseif updateType == "SAFETY" then
			local text = "**SAFETY**"
			if AwayScore.Value ~= oldAwayScore then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Away.Value.Name))

				oldAwayScore = AwayScore.Value
			elseif HomeScore.Value ~= oldHomeScore then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Home.Value.Name))

				oldHomeScore = HomeScore.Value
			end
			shared.isPAT = false
		elseif updateType == "FIELD GOAL" then
			local text = "**FIELD GOAL**"
			if AwayScore.Value ~= oldAwayScore then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Away.Value.Name))
				oldAwayScore = AwayScore.Value
			elseif HomeScore.Value ~= oldHomeScore then
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
				sendMessage(message, TeamInformation:GetTeamData(GameValues.Home.Value.Name))
				oldHomeScore = HomeScore.Value
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
