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
	self.gridWidth = width
	self.gridHeight = height
	self.aStar = AStar:new(grid, width, height)
	self.positon = self.grid:getPosition(Constants.ENTITY_IDS.MONSTER)
end

function Monster:move(target) end

function Monster:track()
	local playerPos = self.grid:getPosition(Constants.ENTITY_IDS.PLAYER)
	local playerNode = self:getNodeFromGrid(playerPos)

	local monsterNode = self:getNodeFromGrid(self.positon)

	print(self.aStar)
	local path = self.aStar:a_star(monsterNode, playerNode, self.aStar.nodes)
	if path then
		Helpers.printTableOfTables(path)
	end
end

function Monster:getNodeFromGrid(i)
	local x = i % self.gridWidth + 1
	local y = math.floor(i / self.gridWidth)
	return self.aStar.nodes[x][y]
end

return Monster
