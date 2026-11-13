local vector = require("lib.hump.vector")

local Constants = require("src.utils.constants")

local Entity = {}
Entity.__index = Entity

function Entity.new(self, name, sprite, initialState)
	local instance = setmetatable({}, self)

	instance.name = name
	instance.sight = nil
	instance.position = vector(400, 400)
	instance.sprite = sprite
	instance.state = initialState
	-- instance.spriteSheet = sprite.spriteSheet
	-- instance.quads = sprite.idleQuads
	instance.currentFrame = 1
	instance.animTimer = 0
	instance.frameDuration = 0.5

	instance:applyStateSprite()

	instance.facing = Constants.ENTITY_DIRECTION_IDS.DOWN

	return instance
end

function Entity:setState(newState)
	if self.state == newState then
		return
	end

	self.state = newState
	self:applyStateSprite()
end

function Entity:update(dt)
	self.animTimer = self.animTimer + dt
	if self.animTimer >= self.frameDuration then
		self.animTimer = self.animTimer - self.frameDuration
		self.currentFrame = self.currentFrame + 1
		if self.currentFrame > #self.quads[self.facing] then
			self.currentFrame = 1
		end
	end
end

function Entity:draw(x, y)
	love.graphics.setColor(1, 1, 1, 1)
	local _, _, qWidth, qHeight = self.quads[self.facing][self.currentFrame]:getViewport()

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

function Entity:getStateSprite()
	return self.sprite[self.state]
end

function Entity:applyStateSprite()
	local currentStateSprite = self:getStateSprite()
	if currentStateSprite then
		self.spriteSheet = currentStateSprite.spriteSheet
		self.quads = currentStateSprite.quads
	end
end

function Entity:__tostring()
	return self.name
end

return Entity
