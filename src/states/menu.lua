local menu = {}

local input
function menu:enter()
  local baton = require("lib.baton")

  input = baton.new({
    controls = {
      start = { "key:return", "button:a" },
    },
    joystick = love.joystick.getJoysticks()[1],
  })
end

function menu:update(dt)
  input:update()
  if input:released("start") then
    Signal.emit("start")
  end
end

function menu:draw()
  love.graphics.print("press enter to continue", 10, 10)
end

return menu
