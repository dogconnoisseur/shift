local vector = require("lib.hump.vector")

local Player = require("src.entities.player")
local Monster = require("src.entities.monster")
local Map = require("src.map")
local level1 = require("src.levels.level_1")

local play = {}

local input
local player
local monster
local map
function play:enter()
	local baton = require("lib.baton")

	input = baton.new({
		controls = {
			left = { "key:left", "key:a" },
			right = { "key:right", "key:d" },
			up = { "key:up", "key:w" },
			down = { "key:down", "key:s" },
			pause = { "key:escape" },
		},
		pairs = {
			move = { "left", "right", "up", "down" },
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

	local left = input:get("left")
	local right = input:get("right")
	local up = input:get("up")
	local down = input:get("down")

	local direction = self:getDirection(left, right, up, down)

	player:move(direction:normalizeInplace(), dt)

	if input:released("pause") then
		Signal.emit("pause")
	end
end

function play:draw()
	love.graphics.print("play")
	player:draw()
end

function play:getDirection(left, right, up, down)
	return vector.new(right - left, down - up)
end

return play
