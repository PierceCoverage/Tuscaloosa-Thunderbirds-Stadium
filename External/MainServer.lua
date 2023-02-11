-- Services --
local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")
local PhysicsService = game:GetService("PhysicsService")

-- Variables --
local Core = ServerStorage:WaitForChild("Core")
local ChainCrew = workspace.Worksapce:FindFirstChild("Chains")
local Stadium = workspace.Worksapce:FindFirstChild("Stadium")
---

-- Events --
local event = game.ReplicatedStorage.RemoteEvents.Ping

-- Webhook --
local hook =
	"https://hooks.hyra.io/api/webhooks/1069173379426426910/i67-c4gI2M-JhgN9pvGag2ivet78-_-t-tk8DGrCnJh60nRg-YhjwSuZNjMO4909VNJI"

-- Functions --
function M6D(Parent, Name, Part0, Part1, C0, C0Or, C1, C1Or)
	local Motor = Instance.new("Weld", Parent)
	Motor.Name = Name
	Motor.Part0 = Part0
	Motor.Part1 = Part1
	local C0OrRad = C0Or * math.pi / 180
	Motor.C0 = CFrame.fromOrientation(C0OrRad.X, C0OrRad.Y, C0OrRad.Z) + C0.Position

	local C1OrRad = C1Or * math.pi / 180
	Motor.C1 = CFrame.fromOrientation(C1OrRad.X, C1OrRad.Y, C1OrRad.Z) + C1.Position
end

-- Main --
game.Players.PlayerAdded:Connect(function(Player)
	-- Add Player Information --
	local PlayerInformation = Core.PlayerInformation:Clone()
	PlayerInformation.Parent = Player
	--
	Player.CharacterAdded:Connect(function(Character)
		local CharacterInformation = Core.CharacterInformation:Clone()
		CharacterInformation.Parent = Character
		--
		local Torso = Character:WaitForChild("Torso")
		local RightArm = Character:WaitForChild("Right Arm")
		local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
		local Folder = Instance.new("Folder", Character)
		Folder.Name = "Hitboxes"

		local function onTeamChange()
			if
				Player.Team.Name == "Fans"
				or Player.Team.Name == "HSFL Media"
				or Player.Team.Name == "Game Officials" and Folder:FindFirstChild("Jersey")
			then
				-- Check --
				if not Character:FindFirstChild("NegativeHighlight") then
					if Character:FindFirstChild("PositiveHighlight") then
						Character:FindFirstChild("PositiveHighlight"):Destroy()
					end
					-- Make Highlight --
					local Highlight = Instance.new("Highlight", Character)
					Highlight.Name = "NegativeHighlight"
					Highlight.OutlineColor = Color3.fromRGB(255, 41, 41)
					Highlight.OutlineTransparency = 1
					Highlight.FillTransparency = 1
					-- Tween Highlight --
					local PlayInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
					local PlayGoal = { OutlineTransparency = 0 }
					local PlayTween = TweenService:Create(Highlight, PlayInfo, PlayGoal):Play()
					wait(1)
					local EndInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
					local EndGoal = { OutlineTransparency = 1 }
					local EndTween = TweenService:Create(Highlight, EndInfo, EndGoal):Play()
					-- Remove Addons --
					Folder:ClearAllChildren()
					if RightArm:FindFirstChild("Connect") then
						RightArm.Connect:Destroy()
					end
					if HumanoidRootPart:FindFirstChild("BodyGyro") then
						HumanoidRootPart.BodyGyro:Destroy()
					end
				end
			else
				if not Character:FindFirstChild("PositiveHighlight") then
					if Character:FindFirstChild("NegativeHighlight") then
						Character:FindFirstChild("NegativeHighlight"):Destroy()
					end
					-- Make Highlight --
					local Highlight = Instance.new("Highlight", Character)
					Highlight.Name = "PositiveHighlight"
					Highlight.OutlineColor = Color3.fromRGB(24, 255, 24)
					Highlight.OutlineTransparency = 1
					Highlight.FillTransparency = 1
					-- Tween Highlight --
					local PlayInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
					local PlayGoal = { OutlineTransparency = 0 }
					local PlayTween = TweenService:Create(Highlight, PlayInfo, PlayGoal):Play()
					wait(1)
					local EndInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
					local EndGoal = { OutlineTransparency = 1 }
					local EndTween = TweenService:Create(Highlight, EndInfo, EndGoal):Play()
					-- Add Addons --
					local Jersey = Core.Hitbox:FindFirstChild("Jersey"):Clone()
					Jersey.Parent = Folder
					wait(0.5)
					M6D(
						Jersey,
						"JerseyWeld",
						Torso,
						Jersey,
						CFrame.new(0, 0, 0),
						Vector3.new(0, 0, 0),
						CFrame.new(0, 0, 0),
						Vector3.new(0, 0, 0)
					)
					M6D(
						RightArm,
						"Connect",
						RightArm,
						nil,
						CFrame.new(0, -1, 0),
						Vector3.new(-90, 0, 0),
						CFrame.new(0.2, 0.2, 0.3),
						Vector3.new(26.881, -59.502, 25.246)
					)
				end
			end
		end
		-- Add Character Information --

		-- Look At Team --
		Player:GetPropertyChangedSignal("Team"):Connect(onTeamChange)
		--		event.OnServerEvent:Connect(function()
		--			local Data = {
		--				["content"] = "",
		--				["username"] = Player.Name,
		--				["avatar_url"] = "https://www.roblox.com/bust-thumbnail/image?userId="..Player.UserId.."&width=420&height=420&format=png",
		--				["embeds"] = {{
		--					["title"] = Player.Name .. " has been caught cheating",
		--					["description"] = "Memory Spike",
		--					["color"] = tonumber(0xFFFAFA),
		--					["author"] = {
		--						["name"] = "HSFL Anti-Cheat"
		--						--  ["url"] = avatar
		--					},
		--					["thumbnail"] = {
		--						["url"] = "https://cdn.discordapp.com/attachments/1067979967301959681/1069188929363918938/HSFL.png"
		--					}
		--				}}
		--			}
		--			Data = http:JSONEncode(Data)
		--			http:PostAsync(hook, Data)
		--		end)
	end)
end)
--
for _, Ref in pairs(ChainCrew:GetChildren()) do
	for _, Parts in pairs(ChainCrew:GetDescendants()) do
		if Parts:IsA("BasePart") then
            Parts.CollisionGroup = "WorkspaceGroup"
		end
	end
end
--
for _, Ref in pairs(Stadium:GetChildren()) do
	for _, Parts in pairs(Stadium:GetDescendants()) do
		if Parts:IsA("BasePart") then
			Parts.CollisionGroup = "WorkspaceGroup"
		end
	end
end
--
game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAppearanceLoaded:Connect(function(Character)
		for _, Parts in pairs(Character:GetChildren()) do
			if Parts:IsA("BasePart") then
				Parts.CollisionGroup = "WorkspaceGroup"
			end
		end
	end)
end)
---

-- Finalize --
print(script.Name .. " Has Loaded.")

wait(2)
