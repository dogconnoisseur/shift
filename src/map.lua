local Grid = require("src.grid")

local Map = {}
Map.__index = Map

local scale
local offsetX
local offsetY

function Map:new()
	local instance = {}

	instance.grid = nil

	setmetatable(instance, self)
	return instance
end

function Map:init(width, height, entities, cellData)
	self.grid = Grid:new(width, height, entities, cellData)

	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()
	local levelWidth = self.grid.width
	local levelHeight = self.grid.height

	local scaleX = screenWidth / levelWidth
	local scaleY = screenHeight / levelHeight
	scale = math.min(scaleX, scaleY)

	offsetX = (screenWidth - (levelWidth * scale) / 2)
	offsetY = (screenHeight - (levelHeight * scale) / 2)
end

function Map:moveEntity(direction) end

function Map:draw()
	love.graphics.push()
	love.graphics.translate(offsetX, offsetY)
	love.graphics.scale(scale, scale)

	self.grid:draw()
	love.graphics.pop()
end

function Map:__tostring()
	return Grid.__tostring(self.grid)
end

return Map
