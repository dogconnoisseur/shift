local vector = require("lib.hump.vector")

local Constants = require("src.utils.constants")

local Entity = {}
Entity.__index = Entity

function Entity.new(self, name, sprite)
	local instance = {}

	instance.name = name
	instance.sight = nil
	instance.position = vector(400, 400)
	if sprite then
		instance.spriteSheet = sprite.spriteSheet
		instance.quads = sprite.quads
		instance.currentFrame = 1
	end

	instance.facing = Constants.ENTITY_DIRECTION_IDS.DOWN

	setmetatable(instance, self)
	return instance
end

function Entity:init()
	error(self.name .. " must implement init.")
end

function Entity:isEntity(e)
	return type(e) == table and type(e.name) == string and vector.isvector(e.position) and vector.isvector(e.velocity)
end

function Entity:update(dt)
	error(self.name .. " must implement update.")
end

function Entity:draw(x, y)
	love.graphics.setColor(1, 1, 1, 1)
	local _, _, qWidth, qHeight = self.quads[self.facing][self.currentFrame]:getViewport()

	print(self.currentFrame)
	love.graphics.draw(
		self.spriteSheet,
		self.quads[self.facing][self.currentFrame],
		x,
		y,
		0,
		1,
		1,
		qWidth / 2,
		qHeight / 2
	)
end

function Entity:setFacing(d)
	self.facing = d
end

function Entity:__tostring()
	return self.name
end

return Entity
