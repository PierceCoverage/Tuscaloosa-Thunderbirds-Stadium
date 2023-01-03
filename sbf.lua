local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TeamInformation = require(ReplicatedStorage:WaitForChild("Assets").Modules.TeamInformation)

local League = TeamInformation:GetHomeTeam().LeagueData.League

local CountTime = 0
local Counting = false
function ClearMsg()
	if Counting then
		return
	end
	Counting = true
	repeat
		task.wait(1)
		CountTime = CountTime > 0 and CountTime - 1 or 0
	until CountTime == 0
	Counting = false
	script.Parent.Parent.Parent.Message.Text = ""
end

if League == "OCFA" then
	script.Parent.Main.Base.Image = "rbxassetid://7573931291"
end
game.ReplicatedStorage:WaitForChild("RemoteEvent").OnClientEvent:Connect(function(...)
	local tuple = { ... }
	if tuple[1] == "Message" then
		script.Parent.Parent.Parent.Message.Text = tuple[2]
		if tuple[3] then
			CountTime = 3
			spawn(ClearMsg)
		end
	elseif tuple[1] == "Review" then
		script.Parent.Extras.Review.Visible = true
		script.Parent.Main.Frame.Down.Visible = false
	elseif tuple[1] == "Flag" then
		script.Parent.Extras.Flag.Visible = true
		script.Parent.Main.Frame.Down.Visible = false
	elseif tuple[1] == "Pos" then
		script.Parent.Possession.AP.Visible = not script.Parent.Possession.AP.Visible
		script.Parent.Possession.HP.Visible = not script.Parent.Possession.HP.Visible
	elseif tuple[1] == "Blown" then
		script.Parent.Extras.Flag.Visible = false
		script.Parent.Extras.Review.Visible = false
		script.Parent.Main.Frame.Down.Visible = true
	elseif tuple[1] == "Reset" then
		script.Parent.Main.Frame.Down.Visible = true
		script.Parent.Extras.Flag.Visible = false
		script.Parent.Extras.Review.Visible = false
	elseif tuple[1] == "Hats" then
		local msg = "Due to exceeding 3 hats, all of your hats have been removed."
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = msg,
			Color = Color3.new(1, 0, 0),
			Font = Enum.Font.SourceSans,
			FontSize = Enum.FontSize.Size24,
		})
	end
end)
for i, v in pairs(game.ReplicatedStorage.GameValues:GetChildren()) do
	if v.Name == "AwayScore" then
		script.Parent.Main.Frame["Away Score"].Text = tostring(v.Value)
	elseif v.Name == "HomeScore" then
		script.Parent.Main.Frame["Home Score"].Text = tostring(v.Value)
	elseif v.Name == "AwayTimeouts" then
		local num = v.Value
		for i = 1, 3 do
			if i == num then
				script.Parent.Timeouts["ATO" .. i].Visible = true
			else
				script.Parent.Timeouts["ATO" .. i].Visible = false
			end
		end
	elseif v.Name == "HomeTimeouts" then
		local num = v.Value
		for i = 1, 3 do
			if i == num then
				script.Parent.Timeouts["HTO" .. i].Visible = true
			else
				script.Parent.Timeouts["HTO" .. i].Visible = false
			end
		end
	elseif v.Name == "Clock" then
		local Value = v.Value
		local Minutes = math.floor(Value / 60)
		local Seconds = Value % 60
		local Format = tostring(Minutes) .. ":" .. (Seconds > 9 and tostring(Seconds) or "0" .. tostring(Seconds))
		script.Parent.Main.Frame.Time.Text = Format
	elseif v.Name == "PlayClock" then
		local Value = v.Value
		local Seconds = Value % 60
		local Format = ":" .. (Seconds > 9 and tostring(Seconds) or "0" .. tostring(Seconds))
		script.Parent.Main.Frame.PC.Text = Format
	elseif v.Name == "Quarter" then
		local Value = v.Value
		local Format = ""
		if Value == 1 then
			Format = "1st"
		elseif Value == 2 then
			Format = "2nd"
		elseif Value == 3 then
			Format = "3rd"
		elseif Value == 4 then
			Format = "4th"
		else
			Format = tostring("OT" .. Value - 4)
		end
		script.Parent.Main.Frame.Quarter.Text = Format
	elseif v.Name == "Down" then
		local Value = v.Value
		local Format = ""
		if Value == 1 then
			Format = "1st"
		elseif Value == 2 then
			Format = "2nd"
		elseif Value == 3 then
			Format = "3rd"
		elseif Value == 4 then
			Format = "4th"
		else
			Format = tostring("Kickoff")
		end
		script.Parent.Main.Frame.Down.Text = Format
	elseif v.Name == "Possession" then
		if v.Value then
			script.Parent.Possession.AP.Visible = false
			script.Parent.Possession.HP.Visible = true
		else
			script.Parent.Possession.AP.Visible = true
			script.Parent.Possession.HP.Visible = false
		end
	elseif v.Name == "Review" then
		if v.Value then
			script.Parent.Extras.Review.Visible = true
		else
			script.Parent.Extras.Review.Visible = false
		end
	elseif v.Name == "Flag" then
		if v.Value then
			script.Parent.Extras.Flag.Visible = true
		else
			script.Parent.Extras.Flag.Visible = false
		end
	elseif v.Name == "Away" then
		if v.Value then
			for i, v in pairs(script.Parent.Away:GetChildren()) do
				v.Visible = false
			end
			pcall(function()
				script.Parent.Away:FindFirstChild(v.Value.Name).Visible = true
			end)
		end
	elseif v.Name == "Home" then
		if v.Value then
			for i, v in pairs(script.Parent.Home:GetChildren()) do
				v.Visible = false
			end
			pcall(function()
				script.Parent.Home:FindFirstChild(v.Value.Name).Visible = true
			end)
		end
	end
end
for i, v in pairs(game.ReplicatedStorage:WaitForChild("GameValues"):GetChildren()) do
	v.Changed:Connect(function()
		if v.Name == "AwayScore" then
			script.Parent.Main.Frame["Away Score"].Text = tostring(v.Value)
		elseif v.Name == "HomeScore" then
			script.Parent.Main.Frame["Home Score"].Text = tostring(v.Value)
		elseif v.Name == "AwayTimeouts" then
			local num = v.Value
			for i = 1, 3 do
				if i == num then
					script.Parent.Timeouts["ATO" .. i].Visible = true
				else
					script.Parent.Timeouts["ATO" .. i].Visible = false
				end
			end
		elseif v.Name == "HomeTimeouts" then
			local num = v.Value
			for i = 1, 3 do
				if i == num then
					script.Parent.Timeouts["HTO" .. i].Visible = true
				else
					script.Parent.Timeouts["HTO" .. i].Visible = false
				end
			end
		elseif v.Name == "Clock" then
			local Value = v.Value
			local Minutes = math.floor(Value / 60)
			local Seconds = Value % 60
			local Format = tostring(Minutes) .. ":" .. (Seconds > 9 and tostring(Seconds) or "0" .. tostring(Seconds))
			script.Parent.Main.Frame.Time.Text = Format
		elseif v.Name == "PlayClock" then
			local Value = v.Value
			local Seconds = Value % 60
			local Format = ":" .. (Seconds > 9 and tostring(Seconds) or "0" .. tostring(Seconds))
			script.Parent.Main.Frame.PC.Text = Format
		elseif v.Name == "Quarter" then
			local Value = v.Value
			local Format = ""
			if Value == 1 then
				Format = "1st"
			elseif Value == 2 then
				Format = "2nd"
			elseif Value == 3 then
				Format = "3rd"
			elseif Value == 4 then
				Format = "4th"
			else
				Format = tostring("OT" .. Value - 4)
			end
			script.Parent.Main.Frame.Quarter.Text = Format
		elseif v.Name == "Down" then
			local Value = v.Value
			local Format = ""
			if Value == 1 then
				Format = "1st"
			elseif Value == 2 then
				Format = "2nd"
			elseif Value == 3 then
				Format = "3rd"
			elseif Value == 4 then
				Format = "4th"
			else
				Format = tostring("Kickoff")
			end
			script.Parent.Main.Frame.Down.Text = Format
		elseif v.Name == "Possession" then
			if v.Value then
				script.Parent.Possession.AP.Visible = false
				script.Parent.Possession.HP.Visible = true
			else
				script.Parent.Possession.AP.Visible = true
				script.Parent.Possession.HP.Visible = false
			end
		elseif v.Name == "Review" then
			if v.Value then
				script.Parent.Extras.Review.Visible = true
			else
				script.Parent.Extras.Review.Visible = false
			end
		elseif v.Name == "Flag" then
			if v.Value then
				script.Parent.Extras.Flag.Visible = true
			else
				script.Parent.Extras.Flag.Visible = false
			end
		elseif v.Name == "Away" then
			if v.Value then
				for i, v in pairs(script.Parent.Away:GetChildren()) do
					v.Visible = false
				end
				pcall(function()
					script.Parent.Away:FindFirstChild(v.Value.Name).Visible = true
				end)
			end
		elseif v.Name == "Home" then
			if v.Value then
				for i, v in pairs(script.Parent.Home:GetChildren()) do
					v.Visible = false
				end
				pcall(function()
					script.Parent.Home:FindFirstChild(v.Value.Name).Visible = true
				end)
			end
		end
	end)
end

while task.wait() do
	if script.Parent:WaitForChild("Main").Frame.Down.Text ~= "Kickoff" then
		local distance = (workspace.scrimmage.Position.X - workspace.Fdown.Position.X) / 3
		local abs = math.abs(distance)
		local floored = math.floor(abs + 0.5)

		if floored == 0 then
			text = "Inches"
		else
			text = tostring(floored)
		end

		local Value = game.ReplicatedStorage.GameValues.Down.Value
		local Format = ""
		if Value == 1 then
			Format = "1st"
		elseif Value == 2 then
			Format = "2nd"
		elseif Value == 3 then
			Format = "3rd"
		elseif Value == 4 then
			Format = "4th"
		else
			Format = tostring("OT" .. Value - 4)
		end
		script.Parent.Main.Frame.Down.Text = Format .. " & " .. text
	end
end
