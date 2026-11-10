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
		pairs = {},
		joystick = love.joystick.getJoysticks()[1],
	})

	player = Player:new()
	monster = Monster:new()

	map = Map:new()
	map:init(level1.width, level1.height, level1.entities, level1.cells)
end

function play:update(dt)
	input:update()

	if input:released("pause") then
		Signal.emit("pause")
	end
end

function play:draw()
	map:draw()

	player:draw()
end

return play
