local Constants = require("src.utils.constants")
local Helpers = require("src.utils.helpers")

local Grid = {}
Grid.__index = Grid

function Grid:new(width, height, entities, cellData)
	local instance = {}

	instance.width = width
	instance.height = height
	instance.cellWidth = Constants.CELL_DIMENSIONS.WIDTH
	instance.cellHeight = Constants.CELL_DIMENSIONS.HEIGHT
	instance.entities = entities
	instance.cellData = cellData

	setmetatable(instance, self)
	Grid.init(instance)
	return instance
end

function Grid.init(self)
	self.cells = {}
	for i = 1, self.width * self.height do
		self.cells[i] = 0
	end
end

function Grid:isEmpty() end

function Grid:drawGrid()
	local currentY
	local currentX
	for i = 0, #self.cells - 1 do
		currentX = i % self.width
		currentY = math.floor(i / self.width)
		if currentY % 2 == 0 then
			if i % 2 == 0 then
				love.graphics.setColor(Helpers.hexToRGB(Constants.COLORS.BACKGROUND.DARK))
			else
				love.graphics.setColor(Helpers.hexToRGB(Constants.COLORS.BACKGROUND.LIGHT))
			end
		else
			if i % 2 ~= 0 then
				love.graphics.setColor(Helpers.hexToRGB(Constants.COLORS.BACKGROUND.DARK))
			else
				love.graphics.setColor(Helpers.hexToRGB(Constants.COLORS.BACKGROUND.LIGHT))
			end
		end
		love.graphics.rectangle(
			"fill",
			currentX * Constants.CELL_DIMENSIONS.WIDTH,
			currentY * Constants.CELL_DIMENSIONS.HEIGHT,
			Constants.CELL_DIMENSIONS.WIDTH,
			Constants.CELL_DIMENSIONS.HEIGHT
		)
	end
end

function Grid:drawEntities()
	for i = 1, self.width * self.height do
		if self.cellData[i] ~= 0 then
			local coords = self:getCellCenter(i)
			self.entities[self.cellData[i]]:draw(coords.x, coords.y)
		end
	end
end

function Grid:getCellCoords(i)
	i = i - 1
	local currentX = i % self.width * Constants.CELL_DIMENSIONS.WIDTH
	local currentY = math.floor(i / self.width) * Constants.CELL_DIMENSIONS.HEIGHT
	return { x = currentX, y = currentY }
end

function Grid:getCellCenter(i)
	local coords = self:getCellCoords(i)
	local centerX = coords.x + (self.cellWidth / 2)
	local centerY = coords.y + (self.cellHeight / 2)
	return { x = centerX, y = centerY }
end

function Grid:getTotalWidth()
	return self.width * self.cellWidth
end

function Grid:getTotalHeight()
	return self.height * self.cellHeight
end

function Grid:__tostring()
	return "[ " .. table.concat(self.cells, ", ") .. " ]"
end

return Grid
