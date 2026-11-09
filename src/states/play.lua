local vector = require("lib.hump.vector")

local Constants = require("src.utils.constants")
local Player = require("src.entities.player")
local Monster = require("src.entities.monster")
local Map = require("src.map")
local level1 = require("src.levels.level_1")

local play = {}

local input
local player
local monster
local map

local intendedMove
function play:enter()
	local baton = require("lib.baton")

	input = baton.new({
		controls = {
			left = { "key:left", "key:a" },
			right = { "key:right", "key:d" },
			up = { "key:up", "key:w" },
			down = { "key:down", "key:s" },
			pause = { "key:escape" },
			move = { "key:return" },
		},
		pairs = {
			intendedMove = { "left", "right", "up", "down" },
		},
		joystick = love.joystick.getJoysticks()[1],
	})

	player = Player:new()
	monster = Monster:new()

	map = Map:new()
	map:init(level1.width, level1.height, level1.entities, level1.cells)
	print(map)
end

function play:update(dt)
	input:update()

	if input:released("left") then
		intendedMove = Constants.DIRECTIONS.LEFT
	end
	if input:released("right") then
		intendedMove = Constants.DIRECTIONS.RIGHT
	end
	if input:released("up") then
		intendedMove = Constants.DIRECTIONS.UP
	end
	if input:released("down") then
		intendedMove = Constants.DIRECTIONS.DOWN
	end

	if input:released("move") then
		print(intendedMove)
	end
	if input:released("pause") then
		Signal.emit("pause")
	end
end

function play:draw()
	love.graphics.print("play")
	player:draw()
end

return play
