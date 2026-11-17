local Entity = require("src.entity")
local Constants = require("src.utils.constants")
local Helpers = require("src.utils.helpers")

local Wall = {}

Wall.__index = Wall

function Wall:new()
	local instance = {}
	setmetatable(instance, self)

	return instance
end

function Wall:draw(x, y)
	love.graphics.setColor(Helpers.hexToRGB(Constants.COLORS.ENTITY.RED0))
	love.graphics.rectangle(
		"fill",
		x - (Constants.CELL_DIMENSIONS.WIDTH / 2),
		y - (Constants.CELL_DIMENSIONS.HEIGHT / 2),
		Constants.CELL_DIMENSIONS.WIDTH,
		Constants.CELL_DIMENSIONS.HEIGHT
	)
end

return Wall
