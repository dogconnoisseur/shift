local Entity = require("src.entity")
local Constants = require("src.utils.constants")

local Monster = {}
Monster.__index = Monster

setmetatable(Monster, getmetatable(Entity))

function Monster:new()
	local instance = Entity.new(self, Constants.ENTITIES.MONSTER)

	setmetatable(instance, self)

	return instance
end

return Monster
