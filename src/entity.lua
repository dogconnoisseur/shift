local vector = require("lib.hump.vector")
local Entity = {}
Entity.__index = Entity

function Entity.new(self, name)
	local instance = {}

	instance.name = name
	instance.sight = nil
	instance.position = vector(0, 0)
	instance.movementSpeed = 100

	setmetatable(instance, self)
	return instance
end

function Entity:init()
	error(self.name .. " must implement init.")
end

function Entity:isEntity(e)
	return type(e) == table and type(e.name) == string and vector.isvector(e.position) and vector.isvector(e.velocity)
end

function Entity:move(v, dt)
	self.position =
		vector.new(self.position.x + (self.movementSpeed * dt) * v.x, self.position.y + (self.movementSpeed * dt) * v.y)
end

function Entity:update(dt)
	error(self.name .. " must implement update.")
end

function Entity:draw()
	error(self.name .. " must implement draw.")
end

function Entity:__tostring()
	return self.name
end

return Entity
