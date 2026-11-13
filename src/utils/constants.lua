local vector = require("lib.hump.vector")

local TURNS = {
	PLAYERTURN = "PLAYERTURN",
	MONSTERTURN = "MONSTERTURN",
}

local ENTITIES = {
	PLAYER = "PLAYER",
	MONSTER = "MONSTER",
}

local CELL_DIMENSIONS = {
	WIDTH = 16,
	HEIGHT = 16,
}

local COLORS = {
	-- https://lospec.com/palette-list/fluffy8
	ENTITY = {
		RED0 = "#933a63",
		RED1 = "#ff95b1",
		RED2 = "#ffc4cf",
		WHITE = "#ffecf0",
		BLUE0 = "#44387a",
		BLUE1 = "#7679db",
		BLUE2 = "#96b3fd",
		BLUE3 = "#d4d5f6",
	},
	--	https://lospec.com/palette-list/pastelito2
	BACKGROUND = {
		DARK = "#4b475c",
		LIGHT = "#d7dedc",
	},
}

local DIRECTIONS = {
	RIGHT = "RIGHT",
	LEFT = "LEFT",
	UP = "UP",
	DOWN = "DOWN",
}

local DIRECTION_VECTORS = {
	LEFT = vector(-1, 0),
	RIGHT = vector(1, 0),
	UP = vector(0, -1),
	DOWN = vector(0, 1),
}

local ENTITY_IDS = {
	PLAYER = 1,
	MONSTER = 2,
}

local ENTITY_DIRECTION_IDS = {
	DOWN = 1,
	UP = 2,
	RIGHT = 3,
	LEFT = 4,
}

local MONSTER_STATES = {
	IDLE = "IDLE",
	CHASE = "CHASE",
	ATTACK = "ATTACK",
	FLEE = "FLEE",
	HEAL = "HEAL",
}

local PLAYER_STATES = {
	IDLE = "IDLE",
	WALKING = "WALKING",
}

return {
	ENTITIES = ENTITIES,
	COLORS = COLORS,
	DIRECTION_VECTORS = DIRECTION_VECTORS,
	DIRECTIONS = DIRECTIONS,
	ENTITY_IDS = ENTITY_IDS,
	ENTITY_DIRECTION_IDS = ENTITY_DIRECTION_IDS,
	CELL_DIMENSIONS = CELL_DIMENSIONS,
	TURNS = TURNS,
	MONSTER_STATES = MONSTER_STATES,
	PLAYER_STATES = PLAYER_STATES,
}
