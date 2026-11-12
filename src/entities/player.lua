local Entity = require("src.entity")
local Constants = require("src.utils.constants")
local Helpers = require("src.utils.helpers")

local Player = {}
Player.__index = Player

setmetatable(Player, Entity)

local animTimer = 0
local frameDuration = 0.1
function Player:new(sprite)
	local instance = Entity.new(self, Constants.ENTITIES.PLAYER, sprite)

	setmetatable(instance, self)

	return instance
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
