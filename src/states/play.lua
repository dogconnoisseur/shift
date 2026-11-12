local vector = require("lib.hump.vector")

local Constants = require("src.utils.constants")
local Helpers = require("src.utils.helpers")
local Player = require("src.entities.player")
local Monster = require("src.entities.monster")
local Map = require("src.map")
local level1 = require("src.levels.level_1")

local play = {}

local input
local player
local monster
local map
local turn = Constants.TURNS.PLAYERTURN

local moveDirection
local moveDirectionText
function play:enter()
	self.gridCanvas = love.graphics.newCanvas()
	self.fogCanvas = love.graphics.newCanvas()

	local frameWidth, frameHeight = 16, 16

	local playerSheet = love.graphics.newImage("shift-assets/player-idle-Sheet.png")
	local playerQuads = play.getQuads(frameWidth, frameHeight, playerSheet)

	local monsterSheet = love.graphics.newImage("shift-assets/monster-idle-Sheet.png")
	local monsterQuads = play.getQuads(frameWidth, frameHeight, monsterSheet)

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

	local playerSprite = { spriteSheet = playerSheet, quads = playerQuads }
	local monsterSprite = { spriteSheet = monsterSheet, quads = monsterQuads }
	player = Player:new(playerSprite)
	monster = Monster:new(monsterSprite)

	local entities = { [Constants.ENTITY_IDS.PLAYER] = player, [Constants.ENTITY_IDS.MONSTER] = monster }
	map = Map:new()
	map:init(
		level1.width,
		level1.height,
		entities,
		level1.cells,
		{ gridCanvas = self.gridCanvas, fogCanvas = self.fogCanvas }
	)
end

function play:update(dt)
	player:update(dt)
	monster:update(dt)

	input:update()
	if turn == Constants.TURNS.PLAYERTURN then
		if input:released("right") then
			moveDirection = Constants.DIRECTION_VECTORS.RIGHT
			moveDirectionText = "RIGHT"
			player:setFacing(Constants.ENTITY_DIRECTION_IDS.RIGHT)
		end
		if input:released("left") then
			moveDirection = Constants.DIRECTION_VECTORS.LEFT
			moveDirectionText = "LEFT"
			player:setFacing(Constants.ENTITY_DIRECTION_IDS.LEFT)
		end

		if input:released("up") then
			moveDirection = Constants.DIRECTION_VECTORS.UP
			moveDirectionText = "UP"
			player:setFacing(Constants.ENTITY_DIRECTION_IDS.UP)
		end
		if input:released("down") then
			moveDirection = Constants.DIRECTION_VECTORS.DOWN
			moveDirectionText = "DOWN"
			player:setFacing(Constants.ENTITY_DIRECTION_IDS.DOWN)
		end

		if input:released("next") and moveDirection then
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
			Helpers.print2dArray(map.grid.fogGrid, 10, 10)
			print("\n")
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

function play.getQuads(frameWidth, frameHeight, spriteSheet)
	local quads = {}
	local sheetWidth, sheetHeight = spriteSheet:getDimensions()

	local columns = sheetWidth / frameWidth

	for i = 1, columns / 2 do
		quads[i] = {}
		quads[i][1] = love.graphics.newQuad((i - 1) * frameWidth, 16, frameWidth, frameHeight, sheetWidth, sheetHeight)

		quads[i][2] = love.graphics.newQuad((i + 3) * frameWidth, 16, frameWidth, frameHeight, sheetWidth, sheetHeight)
	end
	return quads
end

return play
