local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local HighlightClass = require(script.Parent.Parent.Classes.HighlightClass)

local DBLOSService = Knit.CreateService({
	Name = "DBLOSService",
	Client = {},
	Diving = {},
	Highlight = {},
})

function DBLOSService.Client:Fire(player: Player)
	return self.Server:Fire(player)
end

function DBLOSService:Fire(player: Player)
	local ChainsService = Knit.GetService("ChainsService")
	local GameService = Knit.GetService("GameService")
	local ChatMessageService = Knit.GetService("ChatMessageService")

	if not GameService.Values.Ball then
		return
	end

	local ball_crossed = false

	if
		ChainsService.fdown.Position.X - ChainsService.scrimmage.Position.X < 0
		and GameService.Values.Ball.Position.X - ChainsService.scrimmage.Position.X < 0
	then
		ball_crossed = true
	elseif
		ChainsService.fdown.Position.X - ChainsService.scrimmage.Position.X > 0
		and GameService.Values.Ball.Position.X - ChainsService.scrimmage.Position.X > 0
	then
		ball_crossed = true
	end

	if GameService.Values.Ball.Parent == workspace then
		ball_crossed = true
	end

	if ball_crossed then
		return
	end

	if player.Team == GameService.Values.Home.Team or player.Team == GameService.Values.Away.Team then
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			self.Diving[player.Name] = true
			task.delay(1, function()
				self.Diving[player.Name] = false
			end)
			if
				ChainsService.fdown.Position.X - ChainsService.scrimmage.Position.X < 0
				and player.Character.HumanoidRootPart.Position.X > ChainsService.scrimmage.Position.X
			then
				if self.Highlight[player.Name] then
					return
				end
				for i, v in pairs(Players:GetPlayers()) do
					task.spawn(function()
						ChatMessageService:Send(v, player.Name .. " dove behind the LOS!")
					end)
				end
				self.Highlight[player.Name] = HighlightClass.new(workspace:FindFirstChild(player.Name), "dblos")

				task.delay(5, function()
					self.Highlight[player.Name]:Destroy()
					self.Highlight[player.Name] = nil
				end)
			elseif
				ChainsService.fdown.Position.X - ChainsService.scrimmage.Position.X > 0
				and player.Character.HumanoidRootPart.Position.X < ChainsService.scrimmage.Position.X
			then
				if self.Highlight[player.Name] then
					return
				end
				for i, v in pairs(Players:GetPlayers()) do
					task.spawn(function()
						ChatMessageService:Send(v, player.Name .. " dove behind the LOS!")
					end)
				end
				self.Highlight[player.Name] = HighlightClass.new(workspace:FindFirstChild(player.Name), "dblos")
				task.delay(5, function()
					self.Highlight[player.Name]:Destroy()
					self.Highlight[player.Name] = nil
				end)
			end
		end
	end
end

function DBLOSService:KnitStart()
	print("DBLOSService Started")
end

function DBLOSService:KnitInit()
	print("DBLOSService Initialized")
end

return DBLOSService
