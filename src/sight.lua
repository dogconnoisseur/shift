local Sight = {}
Sight.__index = Sight

function Sight:new(color, radius)
	local instance = {}
	instance.color = color
	instance.radius = radius

	setmetatable(instance, self)
	return instance
end

return Sight
