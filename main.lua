local GameState = require("lib.hump.gamestate")
Signal = require("lib.hump.signal")

local menu = require("src.states.menu")
local play = require("src.states.play")
local pause = require("src.states.pause")

local helpers = require("src.utils.helpers")
local constants = require("src.utils.constants")

local canvas

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	GameState.registerEvents()
	GameState.switch(menu)

	Signal.register("start", function()
		GameState.switch(play)
	end)
	Signal.register("pause", function()
		GameState.switch(pause)
	end)
	Signal.register("unpause", function()
		GameState.switch(play)
	end)

	canvas = love.graphics.newCanvas()

	love.graphics.setCanvas(canvas)

	-- love.graphics.clear(helpers.hexToRGB(constants.COLORS.ENTITY.BLUE0))
	love.graphics.setCanvas()
end

function love.update(dt) end

function love.draw()
	love.graphics.draw(canvas, 0, 0)
end
