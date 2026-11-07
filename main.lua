local GameState = require("lib.hump.gamestate")
Signal = require("lib.hump.signal")

local menu = require("src.states.menu")
local play = require("src.states.play")
local pause = require("src.states.pause")

function love.load()
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
end

function love.update(dt) end

function love.draw() end
