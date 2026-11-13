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

local ability
local moveDirection
local moveDirectionText
function play:enter()
	self.playerStepTimer = 0
	self.playerStepDuration = 1
	self.gridCanvas = love.graphics.newCanvas()
	self.fogCanvas = love.graphics.newCanvas()

	local baton = require("lib.baton")

	input = baton.new({
		controls = {
			left = { "key:left", "key:a" },
			right = { "key:right", "key:d" },
			up = { "key:up", "key:w" },
			down = { "key:down", "key:s" },
			pause = { "key:escape" },
			next = { "key:return" },
			shift = { "key:lshift", "key:rshift" },
		},
		pairs = {},
		joystick = love.joystick.getJoysticks()[1],
	})

	local frameWidth, frameHeight = 16, 16

	local playerIdleSheet = love.graphics.newImage("shift-assets/player-idle-Sheet.png")
	local playerIdleQuads = play.getQuads(frameWidth, frameHeight, playerIdleSheet)
	local playerWalkingSheet = love.graphics.newImage("shift-assets/player-walking-Sheet.png")
	local playerWalkingQuads = play.getQuads(frameWidth, frameHeight, playerWalkingSheet)

	local monsterIdleSheet = love.graphics.newImage("shift-assets/monster-idle-Sheet.png")
	local monsterIdleQuads = play.getQuads(frameWidth, frameHeight, monsterIdleSheet)

	local playerSprite = {
		[Constants.PLAYER_STATES.IDLE] = { spriteSheet = playerIdleSheet, quads = playerIdleQuads },
		[Constants.PLAYER_STATES.WALKING] = { spriteSheet = playerWalkingSheet, quads = playerWalkingQuads },
	}
	local monsterSprite =
		{ [Constants.MONSTER_STATES.IDLE] = { spriteSheet = monsterIdleSheet, quads = monsterIdleQuads } }
	player = Player:new(playerSprite)
	monster = Monster:new(monsterSprite)

	self.visibleEntity = Constants.ENTITY_IDS.PLAYER

	local entities = { [Constants.ENTITY_IDS.PLAYER] = player, [Constants.ENTITY_IDS.MONSTER] = monster }
	map = Map:new()
	map:init(
		level1.width,
		level1.height,
		entities,
		level1.cells,
		{ gridCanvas = self.gridCanvas, fogCanvas = self.fogCanvas }
	)

	monster:init(map.grid)
end

function play:update(dt)
	player:update(dt)
	monster:update(dt)

	input:update()
	if turn == Constants.TURNS.PLAYERTURN then
		self:playerTurn(dt)
	else
		self:monsterTurn()
	end
	if self.playerStepTimer > 0 then
		self.playerStepTimer = self.playerStepTimer - dt

		if self.playerStepTimer <= 0 then
			player:setState(Constants.PLAYER_STATES.IDLE)
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
		if ability then
			love.graphics.print(ability, 400, 0)
		end
		love.graphics.print("PLAYER TURN")
	else
		love.graphics.print("MONSTER TURN")
	end
	map:draw()
end

function play:playerTurn(dt)
	if self.visibleEntity == Constants.ENTITY_IDS.PLAYER then
		if input:released("right") then
			moveDirection = Constants.DIRECTION_VECTORS.RIGHT
			moveDirectionText = "RIGHT"
			player:setFacing(Constants.ENTITY_DIRECTION_IDS.RIGHT)
			ability = nil
		end
		if input:released("left") then
			moveDirection = Constants.DIRECTION_VECTORS.LEFT
			moveDirectionText = "LEFT"
			player:setFacing(Constants.ENTITY_DIRECTION_IDS.LEFT)
			ability = nil
		end

		if input:released("up") then
			moveDirection = Constants.DIRECTION_VECTORS.UP
			moveDirectionText = "UP"
			player:setFacing(Constants.ENTITY_DIRECTION_IDS.UP)
			ability = nil
		end
		if input:released("down") then
			moveDirection = Constants.DIRECTION_VECTORS.DOWN
			moveDirectionText = "DOWN"
			player:setFacing(Constants.ENTITY_DIRECTION_IDS.DOWN)
			ability = nil
		end
	end
	if input:released("shift") then
		ability = "shift"
	end

	if input:released("next") and turn == Constants.TURNS.PLAYERTURN then
		if ability == "shift" then
			moveDirection = nil
			moveDirectionText = nil
			self:shiftAttention()
			map.grid:setVisibility(map.grid:getEntityCell(self.visibleEntity))
			ability = nil
		else
			if moveDirection and self.visibleEntity == Constants.ENTITY_IDS.PLAYER then
				local entityCell = map.grid:getEntityCell(Constants.ENTITY_IDS.PLAYER)
				local moved = map.grid:moveEntity(moveDirection, entityCell)
				if moved then
					player:setState(Constants.PLAYER_STATES.WALKING)
					self.playerStepTimer = self.playerStepDuration
				end
				moveDirection = nil
				moveDirectionText = nil

				if moved then
					turn = Constants.TURNS.MONSTERTURN
				end
				moved = nil
			end
		end
	end
end

function play:monsterTurn()
	if input:released("next") then
		turn = Constants.TURNS.PLAYERTURN
	end
end

function play:shiftAttention()
	if self.visibleEntity == Constants.ENTITY_IDS.PLAYER then
		self.visibleEntity = Constants.ENTITY_IDS.MONSTER
	else
		self.visibleEntity = Constants.ENTITY_IDS.PLAYER
	end
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
