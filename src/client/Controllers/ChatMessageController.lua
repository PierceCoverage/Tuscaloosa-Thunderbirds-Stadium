local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ChatMessageController = Knit.CreateController({ Name = "ChatMessageController" })

function ChatMessageController:KnitStart()
	local ChatMessageService = Knit.GetService("ChatMessageService")

	ChatMessageService.SendMessage:Connect(function(message: string)
		StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "[SYSTEM] " .. message,
			Color = Color3.fromRGB(255, 0, 0),
			Font = Enum.Font.Arial,
			FontSize = Enum.FontSize.Size24,
		})
	end)

	print("ChatMessageController Started")
end

function ChatMessageController:KnitInit()
	print("ChatMessageController Initialized")
end

return ChatMessageController
