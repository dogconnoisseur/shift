local Entity = require("src.entity")
local Constants = require("src.utils.constants")

local Monster = {}
Monster.__index = Monster

setmetatable(Monster, Entity)

function Monster:new(sprite)
	local instance = Entity.new(self, Constants.ENTITIES.MONSTER, sprite)

	setmetatable(instance, self)

	return instance
end

return Monster
