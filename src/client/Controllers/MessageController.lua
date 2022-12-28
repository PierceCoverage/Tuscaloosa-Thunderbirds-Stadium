local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local MessageController = Knit.CreateController { Name = "MessageController" }

function MessageController:KnitStart()
    local Messages = Players.LocalPlayer.PlayerGui:WaitForChild("Messages")
    local Playcall = Messages.Frame.PlaycallMsg
    local Notif = Messages.Frame.NotificationMsg

    local function on_message(Message: string, Type: string)
        if Type == "Tackle" then
            Notif.Text = Message

            task.delay(5, function()
                Notif.Text = ""
            end)
        elseif Type == "FG" then
            Playcall.Text = Message

            task.delay(5, function()
                Playcall.Text = ""
            end)
        else

        end
    end

    local MessageService = Knit.GetService("MessageService")
    MessageService.MessageSignal:Connect(on_message)


    print('MessageController Started')
end

function MessageController:KnitInit()

    print('MessageController Initialized')
end

return MessageController
