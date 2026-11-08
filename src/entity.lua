local vector = require("lib.hump.vector")
local Entity = {}
Entity.__index = Entity

function Entity.new(self, name)
	local instance = {}

	instance.name = name
	instance.sight = nil
	instance.position = vector(0, 0)
	instance.velocity = vector(0, 0)

	setmetatable(instance, self)
	return instance
end

function Entity:init()
	error(self.name .. " must implement init.")
end

function Entity:isEntity(e)
	return type(e) == table and type(e.name) == string and vector.isvector(e.position) and vector.isvector(e.velocity)
end

function Entity:__tostring()
	return self.name
end

return Entity
