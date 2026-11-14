local Entity = require("src.entity")
local Constants = require("src.utils.constants")
local AStar = require("lib.a-star")
local Helpers = require("src.utils.helpers")

local Monster = {}
Monster.__index = Monster

setmetatable(Monster, Entity)

function Monster:new(sprite)
	local instance = Entity.new(self, Constants.ENTITIES.MONSTER, sprite, Constants.MONSTER_STATES.IDLE)
	instance.grid = {}
	return instance
end

function Monster:init(grid, width, height)
	self.grid = grid
	self.aStar = AStar.new(grid, width, height)
end

function Monster:move(target) end

function Monster:getPosition() end

return Monster
