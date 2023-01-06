local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local HitboxClass = require(script.HitboxClass)

local HitboxService = Knit.CreateService({
	Name = "HitboxService",
	Client = {
		Block = Knit.CreateSignal(),
	},
})

function HitboxService:KnitStart()
	print("HitboxService Started")
end

function HitboxService:KnitInit()
	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			local Hitbox = HitboxClass.new(character)

			character.Destroying:Connect(function()
				Hitbox:Destroy()
			end)
		end)
	end)

	print("HitboxService Initialized")
end

--[[ multiple football warnings

coroutine.wrap(function()
	while task.wait(1) do
		local NumOfFootballs = 0
		for i, v in pairs(workspace:GetChildren()) do
			if v.Name == 'Football' then
				NumOfFootballs = NumOfFootballs+1
			end
		end
		for i, v in pairs(game.Players:GetChildren()) do
			if v.Character and v.Character:FindFirstChild('Football') and v.Character.Football:IsA('Tool') and v.Character.Football:FindFirstChild('Handle') then
				NumOfFootballs = NumOfFootballs+1
				game.ReplicatedStorage.GameValues.Ball.Value = v.Character.Football.Handle
			end
		end
		if NumOfFootballs > 1 then
			game.ReplicatedStorage:WaitForChild('MsgEvent'):FireAllClients('Warning',true)	
		else
			game.ReplicatedStorage:WaitForChild('MsgEvent'):FireAllClients('Warning',false)	
		end
	end
end)()

]]
return HitboxService
