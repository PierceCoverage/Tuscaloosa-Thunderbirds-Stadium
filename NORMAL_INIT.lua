local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local sha1 = require(script.sha1)

local ScoreboardController = Knit.CreateController({ Name = "Scoreboard" })

local function round(x, y)
    return math.round(x / y) * y
end

function ScoreboardController:KnitStart()
	local GameService = Knit.GetService("GameService")
	local ScoreboardService = Knit.GetService("ScoreboardService")
	local Scoreboard = Players.LocalPlayer.PlayerGui:WaitForChild("Scoreboard")
	local Frame = Scoreboard.Frame.SBF
	local Values = GameService:Get()

	local function set_values()
		Frame.Main.Frame["Away Score"].Text = tostring(Values.Away.Score)
		Frame.Main.Frame["Home Score"].Text = tostring(Values.Home.Score)
		local num = Values.Away.Timeouts
		for i = 1, 3 do
			if i == num then
				Frame.Timeouts["ATO" .. i].Visible = true
			else
				Frame.Timeouts["ATO" .. i].Visible = false
			end
		end

		local num = Values.Home.Timeouts
		for i = 1, 3 do
			if i == num then
				Frame.Timeouts["HTO" .. i].Visible = true
			else
				Frame.Timeouts["HTO" .. i].Visible = false
			end
		end
		--Clock
		local ClockValue = Values.Clock.Value
		local ClockMinutes = math.floor(ClockValue / 60)
		local ClockSeconds = ClockValue % 60
		local ClockFormat = tostring(ClockMinutes)
			.. ":"
			.. (ClockSeconds > 9 and tostring(ClockSeconds) or "0" .. tostring(ClockSeconds))
		Frame.Main.Frame.Time.Text = ClockFormat
		--PlayClock
		local PlayClockValue = Values.PlayClock.Value
		local PlayClockSeconds = PlayClockValue % 60
		local PlayClockFormat = ":"
			.. (PlayClockSeconds > 9 and tostring(PlayClockSeconds) or "0" .. tostring(PlayClockSeconds))
		Frame.Main.Frame.PC.Text = PlayClockFormat

		local QuarterValue = Values.Quarter

		local QuarterFormat
		if QuarterValue == 1 then
			QuarterFormat = "1st"
		elseif QuarterValue == 2 then
			QuarterFormat = "2nd"
		elseif QuarterValue == 3 then
			QuarterFormat = "3rd"
		elseif QuarterValue == 4 then
			QuarterFormat = "4th"
		else
			QuarterFormat = tostring("OT" .. QuarterValue - 4)
		end
		Frame.Main.Frame.Quarter.Text = QuarterFormat
		local DownValue = Values.Down
		local DownFormat = ""
		local distance = math.abs((Values.Position - workspace.Fdown.Position.X) / 3)
		local distance_display = if distance < 0.5 then "Inches" else tostring(math.floor(distance + 0.5))
		if DownValue == 1 then
			DownFormat = ("1st & %s"):format(distance_display)
		elseif DownValue == 2 then
			DownFormat = ("2nd & %s"):format(distance_display)
		elseif DownValue == 3 then
			DownFormat = ("3rd & %s"):format(distance_display)
		elseif DownValue == 4 then
			DownFormat = ("4th & %s"):format(distance_display)
		else
			DownFormat = tostring("Kickoff")
		end
		Frame.Main.Frame.Down.Text = DownFormat

		if Values.Possession then
			Frame.Possession.AP.Visible = false
			Frame.Possession.HP.Visible = true
		else
			Frame.Possession.AP.Visible = true
			Frame.Possession.HP.Visible = false
		end

		Frame.Extras.Review.Visible = false
		Frame.Extras.Flag.Visible = false

		for i, v in pairs(Frame.Away:GetChildren()) do
			if v.Name ~= Values.Away.Team.Name then
				v.Visible = false
			else
				v.Visible = true
			end
		end

		for i, v in pairs(Frame.Home:GetChildren()) do
			if v.Name ~= Values.Home.Team.Name then
				v.Visible = false
			else
				v.Visible = true
			end
		end
	end

	set_values()

	GameService.SendValues:Connect(function(v)
		Values = v
		set_values()
	end)

	ScoreboardService.Event:Connect(function(v)
		if v.Name == "Review" then
			if v.Value then
				Frame.Extras.Review.Visible = true
			else
				Frame.Extras.Review.Visible = false
			end
		elseif v.Name == "Flag" then
			if v.Value then
				Frame.Extras.Flag.Visible = true
			else
				Frame.Extras.Flag.Visible = false
			end
		end
	end)

	ScoreboardService:Start(sha1.sha1(HttpService:JSONEncode({
		-- Any number of data points can be added here
		time = {
			-- CPU start is the main data point used
			cpuStart = round(tick() - os.clock(), 5),
			timezone = os.date("%Z"),
			isDST = os.date("*t").isdst,
		},
		device = {
			accelerometerEnabled = UserInputService.AccelerometerEnabled,
			touchEnabled = UserInputService.TouchEnabled,
		},
	})))

	print("ScoreboardController Started")
end

function ScoreboardController:KnitInit()
	print("ScoreboardController Initialized")
end

return ScoreboardController
