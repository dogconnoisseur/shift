local vector = require("lib.hump.vector")

local ENTITIES = {
	PLAYER = "PLAYER",
	MONSTER = "MONSTER",
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
	LEFT = vector(-1, 0),
	RIGHT = vector(1, 0),
	UP = vector(0, -1),
	DOWN = vector(0, 1),
}

return {
	ENTITIES = ENTITIES,
	COLORS = COLORS,
	DIRECTIONS = DIRECTIONS,
}
