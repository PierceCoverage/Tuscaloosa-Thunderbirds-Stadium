local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local LeaderstatsService = Knit.CreateService({
	Name = "LeaderstatsService",
	Client = {},
	url = "", --ADD YOUR URL HERE
})

function LeaderstatsService:KnitStart() --Can yield
	print("LeaderstatsService Started")
end

function LeaderstatsService:KnitInit() --No yield
	local function fire_url(user_id)
		return HttpService:RequestAsync({
			Url = (self.url .. "/roblox/%s"):format(user_id),
			Method = "GET",
			Headers = {
				["Content-Type"] = "application/json",
			},
		})
	end

	local function get_data(user_id)
		local success, response

		repeat
			success, response = pcall(fire_url, user_id)
			task.wait()
		until success

		if response.Success then
			return HttpService:JSONDecode(response.Body)
		end

		return nil
	end

	local function create_leaderstats(player: Player): Model
		local leaderstats = Instance.new("Model")
		local team = Instance.new("StringValue", leaderstats)
		local verified = Instance.new("StringValue", leaderstats)

		leaderstats.Name = "leaderstats"
		team.Name = "Team"
		verified.Name = "Verified"

		team.Value = "F/A"
		verified.Value = "No"

		leaderstats.Parent = player

		return leaderstats
	end

	Players.PlayerAdded:Connect(function(player)
		local player_data = get_data(player.UserId)
		local leaderstats = create_leaderstats(player)
		if player_data then
			if player_data.discord and player_data.discord.id then
				leaderstats.Verified.Value = "Yes"
				local TeamInformation = Knit.GetService("TeamService")
                local team
                for i, v in pairs(player_data.discord.roles) do
                    local check = TeamInformation:GetTeamFromRole(v)
                    if check then
                        team = check
                    end
                end
				if team then
					leaderstats.Team.Value = team
				else
					leaderstats.Team.Value = "F/A"
				end
				return
			end
		end
	end)

    print("LeaderstatsService Initialized")
end

return LeaderstatsService
