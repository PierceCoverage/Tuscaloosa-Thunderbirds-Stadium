local ContextActionService = game:GetService("ContextActionService")
local HighlightClass = {}
HighlightClass.__index = HighlightClass

local Colors = {
	lag = Color3.fromRGB(255, 0, 0),
	dblos = Color3.fromRGB(9, 79, 184),
	fs = Color3.fromRGB(230, 215, 17),
}

function HighlightClass.new(Parent: Model, Type: string): table
	local self = setmetatable({}, HighlightClass)

	local Highlight = Instance.new("Highlight")
	Highlight.FillColor = Colors[Type]
	Highlight.FillTransparency = 0.1
	Highlight.OutlineTransparency = 0.35
	Highlight.Parent = Parent
	Highlight.Enabled = true

	self.Object = Highlight

	return self
end

function HighlightClass:Destroy()
	self.Object:Destroy()
	self = nil
end

return HighlightClass
