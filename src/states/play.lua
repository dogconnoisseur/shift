local play = {}

local input
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
end

function play:update(dt)
  input:update()

  if input:released("pause") then
    Signal.emit("pause")
  end
end

function play:draw()
  love.graphics.print("play")
end

return play
