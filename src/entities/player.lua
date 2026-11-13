local Entity = require("src.entity")
local Constants = require("src.utils.constants")
local Helpers = require("src.utils.helpers")

local Player = {}
Player.__index = Player
setmetatable(Player, Entity)

function Player:new(sprite)
	local instance = Entity.new(self, Constants.ENTITIES.PLAYER, sprite, Constants.PLAYER_STATES.IDLE)

	return instance
end

function Player:moveToGrid(targetX, targetY) end

return Player
