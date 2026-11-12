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

function Map:init(width, height, entities, cellData, canvas)
	self.grid = Grid:new(width, height, entities, cellData)

	self.canvas = canvas
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()
	local levelWidth = self.grid:getTotalWidth()
	local levelHeight = self.grid:getTotalHeight()

	local scaleX = screenWidth / levelWidth
	local scaleY = screenHeight / levelHeight
	scale = math.floor(math.min(scaleX, scaleY))

	offsetX = (screenWidth - (levelWidth * scale)) / 2
	offsetY = (screenHeight - (levelHeight * scale)) / 2

	love.graphics.setCanvas(canvas.gridCanvas)
	love.graphics.clear()
	love.graphics.setColor(1, 1, 1, 1)
	self.grid:drawGrid()
	love.graphics.setCanvas()
end

function Map:draw()
	love.graphics.push()
	love.graphics.translate(offsetX, offsetY)

	love.graphics.scale(scale, scale)
	love.graphics.draw(self.canvas.gridCanvas)

	-- self.grid:drawGrid()
	self.grid:drawEntities()
	self.grid:drawFogGrid()

	love.graphics.pop()
end

function Map:__tostring()
	return Grid.__tostring(self)
end

return Map
