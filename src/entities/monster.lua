local Entity = require("src.entity")
local Constants = require("src.utils.constants")

local Monster = {}
Monster.__index = Monster

setmetatable(Monster, Entity)

function Monster:new(sprite)
	local instance = Entity.new(self, Constants.ENTITIES.MONSTER, sprite)
	instance.grid = {}

	instance.state = Constants.MONSTER_STATES.IDLE
	setmetatable(instance, self)

	return instance
end

function Monster:init(grid)
	self.grid = grid
end

return Monster
