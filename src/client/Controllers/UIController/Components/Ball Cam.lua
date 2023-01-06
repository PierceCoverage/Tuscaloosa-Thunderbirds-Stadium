local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.roact)
local Knit = require(ReplicatedStorage.Packages.Knit)

local Button = Roact.Component:extend("Button")

function Button:init()
	print("initing")
	self.state = {
		enabled = false,
	}
end

function Button:render()
	return Roact.createElement("TextButton", {
		Size = UDim2.new(0, 100, 0, 30),
		Position = UDim2.new(0, 0, 0.5, 20),
		BackgroundColor3 = Color3.fromRGB(46, 46, 46),
		BorderSizePixel = 0,
		Text = self.state.enabled and "Ball Cam: On" or "Ball Cam: Off",
		TextSize = 18,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		[Roact.Event.MouseButton1Click] = function(object, inputObject, clickCount)
			self:setState({ enabled = not self.state.enabled })

			local GameController = Knit.GetController("GameController")

			local CurrentCamera = workspace.CurrentCamera
			if self.state.enabled then
				while self.state.enabled do
					CurrentCamera.CameraSubject = GameController.Values.Ball
					task.wait(1 / 10)
				end
			else
				CurrentCamera.CameraSubject = Players.LocalPlayer.Character.Humanoid
				CurrentCamera.FieldOfView = 70
			end
		end,
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
	})
end

return Button
