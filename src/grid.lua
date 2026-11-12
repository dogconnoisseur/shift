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
	instance.grid = cellData

	instance.fogGrid = {}
	instance.prevVisible = {}
	instance.visibleRadius = 2

	setmetatable(instance, self)
	Grid.init(instance)
	return instance
end

function Grid.init(self)
	for i = 1, self.width * self.height + 1 do
		self.fogGrid[i] = 0
	end
	local playeri = self:getEntityCell(Constants.ENTITY_IDS.PLAYER)
	self.fogGrid[playeri] = 1
	self:setVisibility(playeri)
	self.prevVisible = self:getVisibleCells(playeri, self.visibleRadius)
end

function Grid:isEmpty() end

function Grid:drawFogGrid()
	for i = 0, #self.fogGrid - 1 do
		local coords = self:getCellCoords(i)
		if self.fogGrid[i] == 0 then
			love.graphics.setColor(Helpers.hexToRGB(Constants.COLORS.ENTITY.BLUE0))
		else
			love.graphics.setColor(1, 1, 1, 0)
		end
		love.graphics.rectangle(
			"fill",
			coords.x,
			coords.y,
			Constants.CELL_DIMENSIONS.WIDTH,
			Constants.CELL_DIMENSIONS.HEIGHT
		)
	end
end

function Grid:drawGrid()
	local currentY
	local currentX
	for i = 0, #self.grid - 1 do
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
		if self.grid[i] ~= 0 then
			local coords = self:getCellCenter(i)
			local entity = self:getEntity(i)
			entity:draw(coords.x, coords.y)
		end
	end
end

function Grid:getEntityCell(entityID)
	for i, v in ipairs(self.grid) do
		if v == entityID then
			return i
		end
	end
	return -1
end

function Grid:moveEntity(d, i)
	local target
	if d == Constants.DIRECTION_VECTORS.RIGHT then
		target = i + 1
	elseif d == Constants.DIRECTION_VECTORS.LEFT then
		target = i - 1
	elseif d == Constants.DIRECTION_VECTORS.UP then
		target = i - self.width
	else
		target = i + self.width
	end
	if self:isValidMoveCell(i, target) then
		local entity = self.grid[i]
		self.grid[i] = 0
		self.grid[target] = entity
		self.fogGrid[target] = entity
		self:setVisibility(target)
		return target
	end
	return nil
end

function Grid:isValidMoveCell(start, target)
	start = start - 1
	target = target - 1
	return target >= 0
		and target < self.width * self.height
		and (
			math.floor(start / self.width) == math.floor(target / self.width)
			or start % self.width == target % self.width
		)
end

function Grid:setVisibility(i, show)
	local visable = self:getVisibleCells(i, self.visibleRadius)

	for c = 1, #self.prevVisible do
		self.fogGrid[self.prevVisible[c]] = 0
	end

	for c = 1, #visable do
		self.fogGrid[visable[c]] = 1
	end
	self.prevVisible = visable
end

function Grid:getVisibleCells(playerIndex, radius)
	local result = {}
	local visited = {}

	-- 1. Convert the player's 1D index into 2D grid coordinates (1-based)
	local playerX = ((playerIndex - 1) % self.width) + 1
	local playerY = math.floor((playerIndex - 1) / self.width) + 1

	-- 2. Loop through a bounding box around those coordinates
	for dy = -radius, radius do
		for dx = -radius, radius do
			-- Optional: Use Manhattan distance for a diamond shape instead of a square
			if math.abs(dx) + math.abs(dy) <= radius then
				local targetX = playerX + dx
				local targetY = playerY + dy

				-- 3. Strict boundary check prevents leaking past edges or top row
				if targetX >= 1 and targetX <= self.width and targetY >= 1 and targetY <= self.height then
					-- 4. Convert safe 2D coordinates back into a 1D array index
					local index = targetX + (targetY - 1) * self.width

					if not visited[index] then
						visited[index] = true
						table.insert(result, index)
					end
				end
			end
		end
	end

	return result
	-- 	i,
	-- 	-- r = 1
	-- 	i + 1,
	-- 	i - 1,
	-- 	i + self.width,
	-- 	i - self.width,
	-- 	i + self.width + 1,
	-- 	i + self.width - 1,
	-- 	i - self.width + 1,
	-- 	i - self.width - 1,
	-- 	-- r = 2
	-- 	i - 2 * self.width,
	-- 	i - 2 * self.width - 1,
	-- }
	-- i - r * self.width + r-1
	-- i - r * self.width - r-1
	-- i + r * self.width + r-1
	-- i + r * self.width - r-1
	--
	--i +
	--
	-- i - r * self.width - (r- (r1)
	--
end

function Grid:isSameRow(i, target)
	if target < 0 then
		print(i)
	end
	return target > 0
		and target <= self.width * self.height
		and math.floor((i - 1) / self.width) == math.floor((target - 1) / self.width)
end

function Grid:isSameCol(i, target)
	return i % self.width == target % self.width
end

function Grid:getEntity(i)
	return self.entities[self.grid[i]]
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
	return "[ " .. table.concat(self.grid, ", ") .. " ]"
end

return Grid
