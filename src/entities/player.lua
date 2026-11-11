local Entity = require("src.entity")
local Constants = require("src.utils.constants")
local Helpers = require("src.utils.helpers")

local Player = {}
Player.__index = Player

setmetatable(Player, Entity)

local animTimer = 0
local frameDuration = 0.1
function Player:new(quads, spriteSheet)
	local instance = Entity.new(self, Constants.ENTITIES.PLAYER)

	instance.currentFrame = 1
	instance.quads = quads
	instance.spriteSheet = spriteSheet
	setmetatable(instance, self)

	return instance
end

function Player:draw(x, y)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.spriteSheet, self.quads[self.currentFrame], x, y)
end

function Player:update(dt)
	animTimer = animTimer + dt
	if animTimer >= frameDuration then
		animTimer = animTimer - frameDuration
		self.currentFrame = self.currentFrame + 1
		if self.currentFrame > #self.quads then
			self.currentFrame = 1
		end
	end
end

return Player
