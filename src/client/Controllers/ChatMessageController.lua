local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local ChatMessageController = Knit.CreateController({ Name = "ChatMessageController" })

function ChatMessageController:KnitStart()
	local ChatMessageService = Knit.GetService("ChatMessageService")

	ChatMessageService.SendMessage:Connect(function(message: string)
		TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage("[SYSTEM]: " .. message)
	end)

	print("ChatMessageController Started")
end

function ChatMessageController:KnitInit()
	print("ChatMessageController Initialized")
end

return ChatMessageController
