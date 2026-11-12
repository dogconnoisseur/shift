local Entity = require("src.entity")
local Constants = require("src.utils.constants")

local Monster = {}
Monster.__index = Monster

setmetatable(Monster, Entity)

function Monster:new()
	local instance = Entity.new(self, Constants.ENTITIES.MONSTER, nil)

	setmetatable(instance, self)

	return instance
end

function Monster:draw(x, y)
	love.graphics.circle("fill", x, y, 5)
end

return Monster
