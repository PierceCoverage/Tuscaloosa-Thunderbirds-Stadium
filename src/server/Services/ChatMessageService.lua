local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ChatMessageService = Knit.CreateService({
	Name = "ChatMessageService",
	Client = {
		SendMessage = Knit.CreateSignal(),
	},
})

function ChatMessageService:Send(player: Player, message: string)
	task.spawn(function()
		self.Client.SendMessage:Fire(player, message)
	end)
end

function ChatMessageService:KnitStart()
	print("ChatMessageService Started")
end

function ChatMessageService:KnitInit()
	print("ChatMessageService Initialized")
end

return ChatMessageService
