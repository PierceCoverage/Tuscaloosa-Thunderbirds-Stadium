--[[
	Author : nurokoi
	Anti-Exploit for accessory client abuse
]]

local CleanUp = function(entityInstance, directoryPath)	
	local startTime = tick()
	directoryPath = directoryPath or workspace
	entityInstance:Destroy()
	
	repeat
		local Accessory = directoryPath:FindFirstChildOfClass("Accessory")
		if Accessory then
			Accessory:Destroy()
		elseif (tick() - startTime >= 2) then
			break
		end
		wait()
	until not directoryPath:FindFirstChildOfClass("Accessory")
end

local CleanCheck = function(entityAdded)
	if entityAdded:IsA("Accessory") then
		CleanUp(entityAdded)
	end
end

workspace.ChildAdded:Connect(CleanCheck)