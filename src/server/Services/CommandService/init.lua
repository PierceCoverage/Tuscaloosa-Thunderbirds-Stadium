local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local CommandService = Knit.CreateService({
	Name = "CommandService",
	Commands = {},
	Prefix = "/",
})

local function startswith(message: string, start: string)
	if not message or not start then
		return
	end

	local length = start:len()
	message = message:lower()
	start = start:lower()

	if message:sub(1, length) == start then
		return true
	end

	return false
end

function CommandService:GetCommand(name)
	for i, v in pairs(self.Commands) do
		if v.name == name then
			return v
		else
			for a, b in pairs(v.aliases) do
				if name == b then
					return v
				end
			end
		end
	end
end

function CommandService:KnitStart()
	print("CommandService Started")
end

function CommandService:KnitInit()
	for i, v in pairs(script.Commands:GetChildren()) do
		table.insert(self.Commands, require(v))
	end

	Players.PlayerAdded:Connect(function(player)
		player.Chatted:Connect(function(message)
			if startswith(message, self.Prefix) then --If message starts with the prefix
				message = message:sub(self.Prefix:len() + 1)
				local arguments = message:split(" ")

				if not arguments then
					arguments[1] = message
				end

				local command = self:GetCommand(arguments[1])

				if command then --If command is found
					table.remove(arguments, 1)
					command.callback(player, arguments)
				else
					--No command found!
				end
			end
		end)
	end)

	for i, v in pairs(TextChatService:GetChildren()) do
		if v:IsA("TextChatCommand") then
			v.Triggered:Connect(function(a, b)
				print(a, b)
			end)
		end
	end
	print("CommandService Initialized")
end

return CommandService
