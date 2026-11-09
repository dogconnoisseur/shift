local Entity = require("src.entity")
local Constants = require("src.utils.constants")

local Player = {}
Player.__index = Player

setmetatable(Player, getmetatable(Entity))

function Player:new()
	local instance = Entity.new(self, Constants.ENTITIES.PLAYER)

	setmetatable(instance, self)

	return instance
end

function Player:draw()
	love.graphics.rectangle("fill", self.position.x, self.position.y, 100, 100)
end

function Player:update(dt) end

return Player
