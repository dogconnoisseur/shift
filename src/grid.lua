local Grid = {}
Grid.__index = Grid

function Grid:new(width, height, entities, cellData)
	local instance = {}

	instance.width = width
	instance.height = height
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

function Grid:__tostring()
	return "[ " .. table.concat(self.cells, ", ") .. " ]"
end

return Grid
