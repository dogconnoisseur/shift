local Entity = require("src.entity")
local Constants = require("src.utils.constants")

local Monster = {}
Monster.__index = Monster

setmetatable(Monster, Entity)

function Monster:new(sprite)
	local instance = Entity.new(self, Constants.ENTITIES.MONSTER, sprite, Constants.MONSTER_STATES.IDLE)
	instance.grid = {}

	return instance
end

function Monster:init(grid)
	self.grid = grid
end

return Monster
