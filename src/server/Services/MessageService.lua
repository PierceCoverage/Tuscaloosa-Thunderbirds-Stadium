local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local MessageService = Knit.CreateService({
	Name = "MessageService",
	Client = {
		MessageSignal = Knit.CreateSignal(),
	},
})

function MessageService:Send(Players: table, Message: string, Type: string)
	for i, v in pairs(Players) do
		self.Client.MessageSignal:Fire(v, Message, Type)
	end
end

function MessageService:KnitStart()
	print("MessageService Started")
end

function MessageService:KnitInit()
	print("MessageService Initialized")
end

return MessageService
