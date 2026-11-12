local Entity = require("src.entity")
local Constants = require("src.utils.constants")
local Helpers = require("src.utils.helpers")

local Player = {}
Player.__index = Player

setmetatable(Player, Entity)

local animTimer = 0
local frameDuration = 0.5
function Player:new(sprite)
	local instance = Entity.new(self, Constants.ENTITIES.PLAYER, sprite)

	setmetatable(instance, self)

	return instance
end

return Player
