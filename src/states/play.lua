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

local playerMove
function play:enter()
	local baton = require("lib.baton")

	input = baton.new({
		controls = {
			left = { "key:left", "key:a" },
			right = { "key:right", "key:d" },
			up = { "key:up", "key:w" },
			down = { "key:down", "key:s" },
			pause = { "key:escape" },
			next = { "key:return" },
		},
		pairs = {},
		joystick = love.joystick.getJoysticks()[1],
	})

	player = Player:new()
	monster = Monster:new()

	local entities = { [Constants.ENTITY_IDS.PLAYER] = player, [Constants.ENTITY_IDS.MONSTER] = monster }
	map = Map:new()
	map:init(level1.width, level1.height, entities, level1.cells)
end

function play:update(dt)
	input:update()

	local entityCell = map.grid:getEntityCell(Constants.ENTITY_IDS.PLAYER)

	if input:released("right") then
		playerMove = map.grid:moveEntity(Constants.DIRECTIONS.RIGHT, entityCell)
	end
	if input:released("left") then
		playerMove = map.grid:moveEntity(Constants.DIRECTIONS.LEFT, entityCell)
	end

	if input:released("up") then
		playerMove = map.grid:moveEntity(Constants.DIRECTIONS.UP, entityCell)
	end
	if input:released("down") then
		playerMove = map.grid:moveEntity(Constants.DIRECTIONS.DOWN, entityCell)
	end

	if input:released("next") then
		print(playerMove)
		playerMove = nil
	end

	if input:released("pause") then
		Signal.emit("pause")
	end
end

function play:draw()
	map:draw()
end

return play
