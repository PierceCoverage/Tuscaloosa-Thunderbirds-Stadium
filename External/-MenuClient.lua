-- Services --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Teams = game:GetService("Teams")
local TextChatService = game:GetService("TextChatService")
local MarketPlaceService = game:GetService("MarketplaceService")

local Knit = require(ReplicatedStorage.Packages.Knit)
-- Variables --
local Player = Players.LocalPlayer
local Character = Player.Character
local Menu = script.Parent.Main:WaitForChild("Menu")
local Scoreboard = script.Parent.Main:WaitForChild("Scoreboard")
local Messages = script.Parent.Main:WaitForChild("Message")
local Info = script.Parent.Main:WaitForChild("Info")
local Referee = script.Parent:WaitForChild("Referee")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("UIEvent")
-- Values --
local IsOpen = false
local IsUsed = false
---

local CoachesAllowed = { 1588035760, 39046109 }
Player:GetPropertyChangedSignal("Team"):Connect(function()
	if Player.Team.Name == "Fans" or Player.Team.Name == "HSFL Media" then
		Menu.TxtBox.BindBox2.Visible = false
		return
	else
		if Player.UserId == table.find(CoachesAllowed, Player.UserId) then
			if Menu.TxtBox.BindBox2.Visible == false then
				Menu.TxtBox.BindBox2.Visible = true
			elseif Menu.TxtBox.BindBox2.Visible == true then
				Menu.TxtBox.BindBox2.Visible = false
			end
		end
	end
end)

-- Functions --
function MenuPos(Status, Frame, Pos)
	if Status == true then
		local FrameInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
		local FrameGoal = { ["Position"] = Pos }
		local FrameTween = TweenService:Create(Frame, FrameInfo, FrameGoal):Play()
	elseif Status == false then
		local FrameInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
		local FrameGoal = { ["Position"] = Pos }
		local FrameTween = TweenService:Create(Frame, FrameInfo, FrameGoal):Play()
	end
end
--
function MessagePos(Txt)
	-- Add UI --
	local FrameInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	Menu.Parent.TopMessage.Transparency = 0.6
	Menu.Parent.TopMessage.TextLabel.TextTransparency = 0
	Menu.Parent.TopMessage.TextLabel.Text = Txt
	MenuPos(true, Menu.Parent.TopMessage, UDim2.new(0, 0, 0, -36))
	-- Remove UI --
	wait(5)
	if Menu.Parent.TopMessage.TextLabel.Text == Txt then
		local FrameGoal = { Transparency = 1 }
		local TxtGoal = { TextTransparency = 1 }
		local FrameTween = TweenService:Create(Menu.Parent.TopMessage, FrameInfo, FrameGoal)
		local TxtTween = TweenService:Create(Menu.Parent.TopMessage.TextLabel, FrameInfo, TxtGoal)
		FrameTween:Play()
		TxtTween:Play()
		-- Replace UI --
		FrameTween.Completed:Connect(function()
			Menu.Parent.TopMessage.Position = UDim2.new(0, 0, -0.05, -36)
			Menu.Parent.TopMessage.TextLabel.Text = ""
		end)
	end
end
---
local function CurrentPos()
	local TeamService = Knit.GetService("TeamService")
	for I, Players in pairs(game:GetService("Players"):GetChildren()) do
		if ReplicatedStorage.Values.ServerPossession.Value == true then
			if Players.Team.Name == TeamService:GetHomeTeam().Name then
				Players.PlayerInformation.CPOS.Value = Players.PlayerInformation.OPOS.Value
				-- Tweens --
				local Info = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
				local BigGoal = { Size = UDim2.new(1, 0, 0.437, 0) }
				local BigTween = TweenService:Create(Menu.Parent.Info.Poss.Offense, Info, BigGoal):Play()
				--
				local LessGoal = { Size = UDim2.new(1, 0, 0.214, 0) }
				local LessTween = TweenService:Create(Menu.Parent.Info.Poss.Defense, Info, LessGoal):Play()
				---
			elseif Players.Team.Name == TeamService:GetAwayTeam().Name then
				Players.PlayerInformation.CPOS.Value = Players.PlayerInformation.DPOS.Value
				-- Tweens --
				local Info = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
				local BigGoal = { Size = UDim2.new(1, 0, 0.437, 0) }
				local BigTween = TweenService:Create(Menu.Parent.Info.Poss.Defense, Info, BigGoal):Play()
				--
				local LessGoal = { Size = UDim2.new(1, 0, 0.214, 0) }
				local LessTween = TweenService:Create(Menu.Parent.Info.Poss.Offense, Info, LessGoal):Play()
				---
			end
		elseif ReplicatedStorage.Values.ServerPossession.Value == false then
			if Players.Team.Name == TeamService:GetHomeTeam().Name then
				Players.PlayerInformation.CPOS.Value = Players.PlayerInformation.DPOS.Value
				-- Tweens --
				local Info = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
				local BigGoal = { Size = UDim2.new(1, 0, 0.437, 0) }
				local BigTween = TweenService:Create(Menu.Parent.Info.Poss.Defense, Info, BigGoal):Play()
				--
				local LessGoal = { Size = UDim2.new(1, 0, 0.214, 0) }
				local LessTween = TweenService:Create(Menu.Parent.Info.Poss.Offense, Info, LessGoal):Play()
				---
			elseif Players.Team.Name == TeamService:GetAwayTeam().Name then
				Players.PlayerInformation.CPOS.Value = Players.PlayerInformation.OPOS.Value
				-- Tweens --
				local Info = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
				local BigGoal = { Size = UDim2.new(1, 0, 0.437, 0) }
				local BigTween = TweenService:Create(Menu.Parent.Info.Poss.Offense, Info, BigGoal):Play()
				--
				local LessGoal = { Size = UDim2.new(1, 0, 0.214, 0) }
				local LessTween = TweenService:Create(Menu.Parent.Info.Poss.Defense, Info, LessGoal):Play()
				---
			end
		end
	end
end
---

-- Main --
UserInputService.InputBegan:Connect(function(Input, GPE)
	if GPE then
		return
	end
	if Input.KeyCode == Enum.KeyCode.M then
		if not IsOpen then
			IsOpen = true
			MenuPos(true, Menu.Menu.ArchPicker, UDim2.new(0, 0, 0.057, 0))
			MenuPos(true, Menu.Menu.Helmets, UDim2.new(0, 0, 0.294, 0))
			MenuPos(true, Menu.Menu.Accessories, UDim2.new(0, 0, 0.53, 0))
			MenuPos(true, Menu.Menu.Settings, UDim2.new(0, 0, 0.77, 0))
			MenuPos(true, Menu.Menu.Teleport, UDim2.new(1.05, 0, 0.057, 0))
			MenuPos(true, Scoreboard, UDim2.new(0.5, 0, 1.2, 0))
			MenuPos(true, Messages, UDim2.new(0.5, 0, 1.2, 0))
			-- Header --
			local HeaderInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local HeaderGoal = { TextTransparency = 0 }
			local HeaderTween = TweenService:Create(Menu.Title, HeaderInfo, HeaderGoal):Play()
			-- Fade --
			local FadeInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local FadeGoal = { ImageTransparency = 0.3 }
			local FadeTween = TweenService:Create(Menu.Fade, FadeInfo, FadeGoal):Play()
			-- Blur --
			local Blur = Instance.new("BlurEffect", game.Lighting)
			Blur.Size = 0
			local BlurInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local BlurGoal = { Size = 20 }
			local BlurTween = TweenService:Create(Blur, BlurInfo, BlurGoal):Play()
			-- TextChat --
			TextChatService.ChatWindowConfiguration.Enabled = false
			TextChatService.ChatInputBarConfiguration.Enabled = false
			-- Menu Label --
			Menu.TxtBox.Visible = false
			Info.Visible = false
		else
			IsOpen = false
			MenuPos(false, Menu.Menu.ArchPicker, UDim2.new(-1.6, 0, 0.057, 0))
			MenuPos(false, Menu.Menu.Helmets, UDim2.new(-1.8, 0, 0.294, 0))
			MenuPos(false, Menu.Menu.Accessories, UDim2.new(-2, 0, 0.53, 0))
			MenuPos(false, Menu.Menu.Settings, UDim2.new(-2.2, 0, 0.77, 0))
			MenuPos(false, Menu.Menu.Teleport, UDim2.new(-2.4, 0, 0.057, 0))
			MenuPos(true, Scoreboard, UDim2.new(0.5, 0, 0.891, 0))
			MenuPos(true, Messages, UDim2.new(0.5, 0, 0.891, 0))
			-- Header --
			local HeaderInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local HeaderGoal = { TextTransparency = 1 }
			local HeaderTween = TweenService:Create(Menu.Title, HeaderInfo, HeaderGoal):Play()
			-- Fade --
			local FadeInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local FadeGoal = { ImageTransparency = 1 }
			local FadeTween = TweenService:Create(Menu.Fade, FadeInfo, FadeGoal):Play()
			-- Blur --
			local Blur = game.Lighting:FindFirstChild("Blur")
			local BlurInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local BlurGoal = { Size = 0 }
			local BlurTween = TweenService:Create(Blur, BlurInfo, BlurGoal):Play()
			Blur:Destroy()
			-- TextChat --
			TextChatService.ChatWindowConfiguration.Enabled = true
			TextChatService.ChatInputBarConfiguration.Enabled = true
			-- Menu Label --
			Menu.TxtBox.Visible = true
			Info.Visible = true
		end
	elseif Input.KeyCode == Enum.KeyCode.B then
		Player:GetPropertyChangedSignal("Team"):Connect(function()
			if Player.Team.Name == "Fans" or Player.Team.Name == "HSFL Media" then
				MenuPos(false, Menu.Parent.Coach, UDim2.new(-1.6, 0, 0.31, 0))
				return
			end
			if Player.UserId == table.find(CoachesAllowed, Player.UserId) then
				if not IsUsed then
					IsUsed = true
					MenuPos(true, Menu.Parent.Coach, UDim2.new(0.1, 0, 0.31, 0))
				else
					IsUsed = false
					MenuPos(false, Menu.Parent.Coach, UDim2.new(-1.6, 0, 0.31, 0))
				end
			end
		end)
	end
end)
--
for I, V in pairs(script.Parent:GetDescendants()) do
	if V:IsA("TextButton") then
		V.MouseEnter:Connect(function()
			-- BackGround --
			local BackGroundColorInfo =
				TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local BackGroundColorGoal = { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }
			local BackGroundColorTween = TweenService:Create(V, BackGroundColorInfo, BackGroundColorGoal):Play()
			-- Font/Text --
			local TextColorInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local TextColorGoal = { TextColor3 = Color3.fromRGB(0, 0, 0) }
			local TextColorTween = TweenService:Create(V, TextColorInfo, TextColorGoal):Play()
			-- Outline --
			local Outline = V.UIStroke
			local OutlineColorInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local OutlineColorGoal = { Color = Color3.fromRGB(255, 255, 255) }
			local OutlineColorTween = TweenService:Create(Outline, OutlineColorInfo, OutlineColorGoal):Play()
		end)
		V.MouseLeave:Connect(function()
			-- BackGround --
			local BackGroundColorInfo =
				TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local BackGroundColorGoal = { BackgroundColor3 = Color3.fromRGB(33, 33, 33) }
			local BackGroundColorTween = TweenService:Create(V, BackGroundColorInfo, BackGroundColorGoal):Play()
			-- Font/Text --
			local TextColorInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local TextColorGoal = { TextColor3 = Color3.fromRGB(255, 255, 255) }
			local TextColorTween = TweenService:Create(V, TextColorInfo, TextColorGoal):Play()
			-- Outline --
			local Outline = V.UIStroke
			local OutlineColorInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local OutlineColorGoal = { Color = Color3.fromRGB(16, 16, 16) }
			local OutlineColorTween = TweenService:Create(Outline, OutlineColorInfo, OutlineColorGoal):Play()
		end)
		V.MouseButton1Click:Connect(function()
			-- BackGround --
			local BackGroundColorInfo =
				TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local BackGroundColorGoal = { BackgroundColor3 = Color3.fromRGB(57, 126, 255) }
			local BackGroundColorTween = TweenService:Create(V, BackGroundColorInfo, BackGroundColorGoal):Play()
			-- Font/Text --
			local TextColorInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local TextColorGoal = { TextColor3 = Color3.fromRGB(255, 255, 255) }
			local TextColorTween = TweenService:Create(V, TextColorInfo, TextColorGoal):Play()
			-- Outline --
			local Outline = V.UIStroke
			local OutlineColorInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local OutlineColorGoal = { Color = Color3.fromRGB(40, 89, 179) }
			local OutlineColorTween = TweenService:Create(Outline, OutlineColorInfo, OutlineColorGoal):Play()
		end)
	end
end
---

-- Scoreboard Visibility --
--Player:GetPropertyChangedSignal('Team'):Connect(function()
--	if Player.Team.Name == 'Home' or 'Away' then
--		-- Scoreboard --
--		local SBInfo = TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0)
--		local SBGoal = {Position = UDim2.new(0.5,0,0.891,0)}
--		local SBTween = TweenService:Create(Scoreboard,SBInfo,SBGoal):Play()
--		-- Messages --
--		local MsgInfo = TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0)
--		local MsgGoal = {Position = UDim2.new(0.5,0,0.891,0)}
--		local MsgTween = TweenService:Create(Messages,SBInfo,MsgGoal):Play()
--		-- Small SB --
--		local SBSInfo = TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0)
--		local SBSGoal = {Position = UDim2.new(0.5,0,0,0)}
--		local SBSTween = TweenService:Create(Menu.Fade,SBSInfo,SBSGoal):Play()
--	end
--end)
---

-- Buttons --
Menu.Menu.Settings.Option1.MouseButton1Click:Connect(function()
	if Menu.Menu.Settings.Option1.Text == "BUBBLES: OFF" then
		Menu.Menu.Settings.Option1.Text = "BUBBLES: ON"
	elseif Menu.Menu.Settings.Option1.Text == "BUBBLES: ON" then
		Menu.Menu.Settings.Option1.Text = "BUBBLES: OFF"
	end
	if Menu.Menu.Settings.Option1.Text == "BUBBLES: OFF" then
		TextChatService.BubbleChatConfiguration.Enabled = false
	elseif Menu.Menu.Settings.Option1.Text == "BUBBLES: ON" then
		TextChatService.BubbleChatConfiguration.Enabled = true
	end
end)
--
Menu.Menu.Settings.Option2.MouseButton1Click:Connect(function()
	if workspace.Worksapce:FindFirstChild("Stadium") then
		workspace.Worksapce.Stadium.Parent = ReplicatedStorage
		Menu.Menu.Settings.Option2.Text = "STADIUM: OFF"
	elseif ReplicatedStorage:FindFirstChild("Stadium") then
		ReplicatedStorage.Stadium.Parent = workspace.Worksapce
		Menu.Menu.Settings.Option2.Text = "STADIUM: ON"
	end
end)
-- Accessories --

if MarketPlaceService:UserOwnsGamePassAsync(Player.UserId, 129940619) then
	local BlockInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
	local BlockGoal = { BackgroundTransparency = 1 }
	local BlockTween = TweenService:Create(Menu.Menu.Accessories.Block, BlockInfo, BlockGoal):Play()
	--
	local DescInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
	local DescGoal = { TextTransparency = 1 }
	local DescTween = TweenService:Create(Menu.Menu.Accessories.Block.Text, DescInfo, DescGoal):Play()
end
--
Menu.Menu.Accessories.Block.Option.MouseButton1Click:Connect(function()
	MarketPlaceService:PromptGamePassPurchase(Player, 129940619)
	MarketPlaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
		if gamePassId == 129940619 and wasPurchased then
			MenuPos(true, Menu.Menu.Accessories.Block.Option, UDim2.new(0.497, 0, 1.2, 0))
			--
			local BlockInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local BlockGoal = { BackgroundTransparency = 1 }
			local BlockTween = TweenService:Create(Menu.Menu.Accessories.Block, BlockInfo, BlockGoal):Play()
			--
			local DescInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
			local DescGoal = { TextTransparency = 1 }
			local DescTween = TweenService:Create(Menu.Menu.Accessories.Block.Text, DescInfo, DescGoal):Play()
		end
	end)
end)

-- Archs --
Menu.Menu.ArchPicker.Switch.MouseButton1Click:Connect(function()
	if Menu.Menu.ArchPicker.Archs.Defense.Position == UDim2.new(0, 0, 0, 0) then
		-- Tween --
		MenuPos(true, Menu.Menu.ArchPicker.Archs.Offense, UDim2.new(0, 0, 0, 0))
		MenuPos(false, Menu.Menu.ArchPicker.Archs.Defense, UDim2.new(-1.2, 0, 0, 0))
	elseif Menu.Menu.ArchPicker.Archs.Offense.Position == UDim2.new(0, 0, 0, 0) then
		MenuPos(true, Menu.Menu.ArchPicker.Archs.Defense, UDim2.new(0, 0, 0, 0))
		MenuPos(false, Menu.Menu.ArchPicker.Archs.Offense, UDim2.new(1.2, 0, 0, 0))
	end
end)
-- Arch UI --
Menu.Menu.ArchPicker.Archs.Defense.Button1.MouseButton1Click:Connect(function()
	-- Defense --
	MenuPos(true, Menu.Menu.ArchPicker.ArchType.Defense.DL, UDim2.new(0, 0, 0, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.LB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.CB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.S, UDim2.new(0, 0, 1.5, 0))
	-- Offense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.QB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.RB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.WR, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.TE, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.C, UDim2.new(0, 0, 1.5, 0))
end)
--
Menu.Menu.ArchPicker.Archs.Defense.Button2.MouseButton1Click:Connect(function()
	-- Defense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.DL, UDim2.new(0, 0, 1.5, 0))
	MenuPos(true, Menu.Menu.ArchPicker.ArchType.Defense.LB, UDim2.new(0, 0, 0, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.CB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.S, UDim2.new(0, 0, 1.5, 0))
	-- Offense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.QB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.RB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.WR, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.TE, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.C, UDim2.new(0, 0, 1.5, 0))
end)
--
Menu.Menu.ArchPicker.Archs.Defense.Button3.MouseButton1Click:Connect(function()
	-- Defense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.DL, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.LB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(true, Menu.Menu.ArchPicker.ArchType.Defense.CB, UDim2.new(0, 0, 0, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.S, UDim2.new(0, 0, 1.5, 0))
	-- Offense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.QB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.RB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.WR, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.TE, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.C, UDim2.new(0, 0, 1.5, 0))
end)
--
Menu.Menu.ArchPicker.Archs.Defense.Button4.MouseButton1Click:Connect(function()
	-- Defense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.DL, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.LB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.CB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(true, Menu.Menu.ArchPicker.ArchType.Defense.S, UDim2.new(0, 0, 0, 0))
	-- Offense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.QB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.RB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.WR, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.TE, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.C, UDim2.new(0, 0, 1.5, 0))
end)
---
-- Slide UI / Offense --
Menu.Menu.ArchPicker.Archs.Offense.Button1.MouseButton1Click:Connect(function()
	-- Defense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.DL, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.LB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.CB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.S, UDim2.new(0, 0, 1.5, 0))
	-- Offense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.QB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.RB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.WR, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.TE, UDim2.new(0, 0, 1.5, 0))
	MenuPos(true, Menu.Menu.ArchPicker.ArchType.Offense.C, UDim2.new(0, 0, 0, 0))
end)
--
Menu.Menu.ArchPicker.Archs.Offense.Button2.MouseButton1Click:Connect(function()
	-- Defense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.DL, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.LB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.CB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.S, UDim2.new(0, 0, 1.5, 0))
	-- Offense --
	MenuPos(true, Menu.Menu.ArchPicker.ArchType.Offense.QB, UDim2.new(0, 0, 0, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.RB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.WR, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.TE, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.C, UDim2.new(0, 0, 1.5, 0))
end)
--
Menu.Menu.ArchPicker.Archs.Offense.Button3.MouseButton1Click:Connect(function()
	-- Defense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.DL, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.LB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.CB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.S, UDim2.new(0, 0, 1.5, 0))
	-- Offense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.QB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(true, Menu.Menu.ArchPicker.ArchType.Offense.RB, UDim2.new(0, 0, 0, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.WR, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.TE, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.C, UDim2.new(0, 0, 1.5, 0))
end)
--
Menu.Menu.ArchPicker.Archs.Offense.Button4.MouseButton1Click:Connect(function()
	-- Defense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.DL, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.LB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.CB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.S, UDim2.new(0, 0, 1.5, 0))
	-- Offense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.QB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.RB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(true, Menu.Menu.ArchPicker.ArchType.Offense.WR, UDim2.new(0, 0, 0, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.TE, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.C, UDim2.new(0, 0, 1.5, 0))
end)
--
Menu.Menu.ArchPicker.Archs.Offense.Button5.MouseButton1Click:Connect(function()
	-- Defense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.DL, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.LB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.CB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Defense.S, UDim2.new(0, 0, 1.5, 0))
	-- Offense --
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.QB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.RB, UDim2.new(0, 0, 1.5, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.WR, UDim2.new(0, 0, 1.5, 0))
	MenuPos(true, Menu.Menu.ArchPicker.ArchType.Offense.TE, UDim2.new(0, 0, 0, 0))
	MenuPos(false, Menu.Menu.ArchPicker.ArchType.Offense.C, UDim2.new(0, 0, 1.5, 0))
end)
-- Make Work --
for I, Button in pairs(Menu.Menu.ArchPicker.ArchType.Defense:GetDescendants()) do
	if Button:IsA("TextButton") then
		Button.MouseButton1Click:Connect(function()
			Character:FindFirstChild("Hitboxes")
				:FindFirstChild("Jersey")
				:FindFirstChild("RemoteEvent")
				:FireServer({ "Arch", Button.Text .. "-" .. Button.Parent.Name })
			Menu.Parent.Info.Poss.Defense.Text = Button.Parent.Name
		end)
	end
end
--
for I, Button in pairs(Menu.Menu.ArchPicker.ArchType.Offense:GetDescendants()) do
	if Button:IsA("TextButton") then
		Button.MouseButton1Click:Connect(function()
			Character:FindFirstChild("Hitboxes")
				:FindFirstChild("Jersey")
				:FindFirstChild("RemoteEvent")
				:FireServer({ "Arch", Button.Text .. "-" .. Button.Parent.Name })
			Menu.Parent.Info.Poss.Offense.Text = Button.Parent.Name
		end)
	end
end
---

for I, Players in pairs(game:GetService("Players"):GetChildren()) do
	Players.PlayerInformation.OPOS:GetPropertyChangedSignal("Value"):Connect(function()
		if Players.PlayerInformation.OPOS.Value ~= "Nil" then
			CurrentPos()
		end
	end)
	Players.PlayerInformation.DPOS:GetPropertyChangedSignal("Value"):Connect(function()
		if Players.PlayerInformation.DPOS.Value ~= "Nil" then
			CurrentPos()
		end
	end)
end
--
ReplicatedStorage.Values.ServerPossession:GetPropertyChangedSignal("Value"):Connect(CurrentPos)
---

-- Referee UI --
Player:GetPropertyChangedSignal("Team"):Connect(function()
	if Player.Team.Name == "Game Officials" then
		MenuPos(true, Referee.RefHub, UDim2.new(0.824, 0, 0.787, 0))
		Info.Visible = false
	else
		MenuPos(false, Referee.RefHub, UDim2.new(0.824, 0, 1.2, 0))
		Info.Visible = true
	end
end)
--
Player:GetPropertyChangedSignal("Team"):Connect(function()
	if Player.UserId == table.find(CoachesAllowed, Player.UserId) then
	end
	if Player.Team.Name == "Game Officials" then
		MenuPos(true, Referee.RefHub, UDim2.new(0.824, 0, 0.787, 0))
		Info.Visible = false
	else
		MenuPos(false, Referee.RefHub, UDim2.new(0.824, 0, 1.2, 0))
		Info.Visible = true
	end
end)
-- Chains --
Referee.RefHub.Option3.MouseButton1Click:Connect(function()
	if Referee.Chains.Position == UDim2.new(0.108, 0, -1, 0) then
		MenuPos(true, Referee.Chains, UDim2.new(0.108, 0, 0.066, 0))
	else
		MenuPos(false, Referee.Chains, UDim2.new(0.108, 0, -1, 0))
	end
end)
-- Scoreboard --
Referee.RefHub.Option5.MouseButton1Click:Connect(function()
	if Referee.Scoreboard.Position == UDim2.new(1, 0, 0.461, 0) then
		MenuPos(true, Referee.Scoreboard, UDim2.new(0.824, 0, 0.461, 0))
	else
		MenuPos(false, Referee.Scoreboard, UDim2.new(1, 0, 0.461, 0))
	end
end)
-- Calls --
Referee.RefHub.Option2.MouseButton1Click:Connect(function()
	if Referee.Calls.Position == UDim2.new(0.571, 0, -1, 0) then
		MenuPos(true, Referee.Calls, UDim2.new(0.571, 0, 0.66, 0))
	else
		MenuPos(false, Referee.Calls, UDim2.new(0.571, 0, -1, 0))
	end
end)
-- Clock --
Referee.RefHub.Option1.MouseButton1Click:Connect(function()
	if Referee.Clock.Position == UDim2.new(0.266, 0, -1, 0) then
		MenuPos(true, Referee.Clock, UDim2.new(0.266, 0, 0.066, 0))
	else
		MenuPos(false, Referee.Clock, UDim2.new(0.266, 0, -1, 0))
	end
end)
-- Teams --
Referee.RefHub.Option4.MouseButton1Click:Connect(function()
	if Referee.Teams.Position == UDim2.new(1, 0, 0.532, 0) then
		MenuPos(true, Referee.Teams, UDim2.new(0.824, 0, 0.532, 0))
	else
		MenuPos(false, Referee.Teams, UDim2.new(1, 0, 0.532, 0))
	end
end)
---

-- Helmet Ui --
Menu.Menu.Helmets.Option1.MouseButton1Click:Connect(function()
	if Menu.Menu.Helmets.Option1.Text == "RIDDELL SPEED FLEX 808" then
		Menu.Menu.Helmets.Option1.Text = "SCHUTT F7 ROBOT"
		MenuPos(false, Menu.Menu.Helmets.SpeedFlex, UDim2.new(1, 0, 0, 0))
		MenuPos(true, Menu.Menu.Helmets.F7, UDim2.new(0, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Revolution, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Vicis, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Xenith, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Axiom, UDim2.new(1, 0, 0, 0))
	elseif Menu.Menu.Helmets.Option1.Text == "SCHUTT F7 ROBOT" then
		Menu.Menu.Helmets.Option1.Text = "RIDDELL REVOLUTION"
		MenuPos(false, Menu.Menu.Helmets.SpeedFlex, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.F7, UDim2.new(1, 0, 0, 0))
		MenuPos(true, Menu.Menu.Helmets.Revolution, UDim2.new(0, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Vicis, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Xenith, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Axiom, UDim2.new(1, 0, 0, 0))
	elseif Menu.Menu.Helmets.Option1.Text == "RIDDELL REVOLUTION" then
		Menu.Menu.Helmets.Option1.Text = "VICIS"
		MenuPos(false, Menu.Menu.Helmets.SpeedFlex, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.F7, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Revolution, UDim2.new(1, 0, 0, 0))
		MenuPos(true, Menu.Menu.Helmets.Vicis, UDim2.new(0, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Xenith, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Axiom, UDim2.new(1, 0, 0, 0))
	elseif Menu.Menu.Helmets.Option1.Text == "VICIS" then
		Menu.Menu.Helmets.Option1.Text = "XENITH"
		MenuPos(false, Menu.Menu.Helmets.SpeedFlex, UDim2.new(1, 0, 0, 0))
		MenuPos(true, Menu.Menu.Helmets.F7, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Revolution, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Vicis, UDim2.new(1, 0, 0, 0))
		MenuPos(true, Menu.Menu.Helmets.Xenith, UDim2.new(0, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Axiom, UDim2.new(1, 0, 0, 0))
	elseif Menu.Menu.Helmets.Option1.Text == "XENITH" then
		Menu.Menu.Helmets.Option1.Text = "AXIOM"
		MenuPos(false, Menu.Menu.Helmets.SpeedFlex, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.F7, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Revolution, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Vicis, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Xenith, UDim2.new(1, 0, 0, 0))
		MenuPos(true, Menu.Menu.Helmets.Axiom, UDim2.new(0, 0, 0, 0))
	elseif Menu.Menu.Helmets.Option1.Text == "AXIOM" then
		Menu.Menu.Helmets.Option1.Text = "RIDDELL SPEED FLEX 808"
		MenuPos(true, Menu.Menu.Helmets.SpeedFlex, UDim2.new(0, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.F7, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Revolution, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Vicis, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Xenith, UDim2.new(1, 0, 0, 0))
		MenuPos(false, Menu.Menu.Helmets.Axiom, UDim2.new(1, 0, 0, 0))
	end
end)
---

-- Main --
RemoteEvent.OnClientEvent:Connect(function(Txt)
	MessagePos(Txt)
end)
---
