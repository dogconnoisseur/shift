local vector = require("lib.hump.vector")

local Constants = require("src.utils.constants")
local Helpers = require("src.utils.helpers")
local Player = require("src.entities.player")
local Monster = require("src.entities.monster")
local Map = require("src.map")
local level1 = require("src.levels.level_1")

local play = {}

local spriteSheet
local quads = {}

local input
local player
local monster
local map
local turn = Constants.TURNS.PLAYERTURN

local moveDirection
local moveDirectionText
function play:enter()
	local frameWidth, frameHeight = 16, 16

	spriteSheet = love.graphics.newImage("assets/player-idle-Sheet.png")
	local sheetWidth, sheetHeight = spriteSheet:getDimensions()

	local columns = sheetWidth / frameWidth
	for i = 0, columns - 1 do
		table.insert(
			quads,
			love.graphics.newQuad(
				i * frameWidth, -- X position moves 16 pixels right per frame
				0, -- Y position (assumes row 1)
				frameWidth,
				frameHeight,
				sheetWidth,
				sheetHeight
			)
		)
	end

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

	local playerSprite = { spriteSheet = spriteSheet, quads = quads }
	player = Player:new(playerSprite)
	monster = Monster:new()

	local entities = { [Constants.ENTITY_IDS.PLAYER] = player, [Constants.ENTITY_IDS.MONSTER] = monster }
	map = Map:new()
	map:init(level1.width, level1.height, entities, level1.cells)
end

function play:update(dt)
	-- player:update(dt)

	input:update()

	if turn == Constants.TURNS.PLAYERTURN then
		if input:released("right") then
			moveDirection = Constants.DIRECTIONS.RIGHT
			moveDirectionText = "RIGHT"
		end
		if input:released("left") then
			moveDirection = Constants.DIRECTIONS.LEFT
			moveDirectionText = "LEFT"
		end

		if input:released("up") then
			moveDirection = Constants.DIRECTIONS.UP
			moveDirectionText = "UP"
		end
		if input:released("down") then
			moveDirection = Constants.DIRECTIONS.DOWN
			moveDirectionText = "DOWN"
		end

		if input:released("next") then
			local entityCell = map.grid:getEntityCell(Constants.ENTITY_IDS.PLAYER)
			local moved = map.grid:moveEntity(moveDirection, entityCell)

			moveDirection = nil
			moveDirectionText = nil
			if moved then
				turn = Constants.TURNS.MONSTERTURN
			end
		end
	else
		if input:released("next") then
			turn = Constants.TURNS.PLAYERTURN
		end
	end

	if input:released("pause") then
		Signal.emit("pause")
	end
end

function play:draw()
	love.graphics.setColor(Helpers.hexToRGB(Constants.COLORS.ENTITY.WHITE))
	if turn == Constants.TURNS.PLAYERTURN then
		if moveDirectionText then
			love.graphics.print("move " .. moveDirectionText, 200, 0)
		end
		love.graphics.print("PLAYER TURN")
	else
		love.graphics.print("MONSTER TURN")
	end
	map:draw()
end

return play
