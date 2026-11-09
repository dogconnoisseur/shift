local Grid = require("src.grid")

local Map = {}
Map.__index = Map

function Map:new()
	local instance = {}

	instance.grid = nil

	setmetatable(instance, self)
	return instance
end

function Map:init(width, height, entities, cellData)
	self.grid = Grid:new(width, height, entities, cellData)
end

function Map:moveEntity(direction) end

function Map:__tostring()
	return Grid.__tostring(self.grid)
end

return Map
