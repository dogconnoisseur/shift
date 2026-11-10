local Entity = require("src.entity")
local Constants = require("src.utils.constants")

local Player = {}
Player.__index = Player

setmetatable(Player, Entity)

function Player:new()
	local instance = Entity.new(self, Constants.ENTITIES.PLAYER)

	setmetatable(instance, self)

	return instance
end

function Player:draw(x, y)
	love.graphics.rectangle("fill", x, y, 5, 5)
end

function Player:update(dt) end

return Player
