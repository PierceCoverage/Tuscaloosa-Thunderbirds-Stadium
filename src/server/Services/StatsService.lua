local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local StatsService = Knit.CreateService({
	Name = "StatsService",
	Presnap = false,
})

function StatsService:KnitStart()
	local GameService = Knit.GetService("GameService")
	local ScoreboardService = Knit.GetService("ScoreboardService")

	ScoreboardService.Blown:Connect(function() -- If it's not yet snapped, check for NZI or FS.
		self.Presnap = true
		local Ball: Part = GameService.Values.Ball

		while GameService.Values.PlayClock.Running and not Ball do -- No ball has been spawned in. Wait for one or wait until PlayClock is stopped.
			task.wait()
			Ball = GameService.Values.Ball
		end

		if not Ball then -- No ball found, play must have been called dead.
			self.Presnap = false
			return
		end

		if Ball:IsDescendantOf(workspace) then --If ball is in workspace
			if Ball.Parent == workspace then
				-- Already in the air. Not sure what to do....
			else
				-- Not in the air! Yay.
				while Ball.Parent ~= workspace do -- Wait for ball to be thrown
					task.wait()
				end
				GameService:Update({ ClockRunning = true })
				self.Presnap = false
			end
		elseif Ball:IsDescendantOf(Players) then -- If ball is in the BackPack
			while Ball.Parent ~= workspace do -- Wait for ball to be thrown
				task.wait()
			end
			GameService:Update({ ClockRunning = true })
			self.Presnap = false
		else -- Ball has disappeared
			self.Presnap = false
		end
	end)

	print("StatsService Started")
end

function StatsService:KnitInit()
	print("StatsService Initialized")
end

return StatsService
