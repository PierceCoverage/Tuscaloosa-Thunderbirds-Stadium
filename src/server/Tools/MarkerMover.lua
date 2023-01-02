local RunService = game:GetService("RunService")
local MarkerMover = {}
MarkerMover.__index = MarkerMover


function MarkerMover.new()
    local self = setmetatable({}, MarkerMover)

    self.connections = {}

    local Heartbeat = RunService.Heartbeat:Connect(function(deltaTime)
        
    end)

    table.insert(self.connections, Heartbeat)

    return self
end

function MarkerMover:Destroy()
    for i, v in pairs(self.connections) do
        v:Disconnect()
    end
end

return MarkerMover
