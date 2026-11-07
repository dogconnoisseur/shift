local pause = {}

local input
function pause:enter()
  local baton = require("lib.baton")

  input = baton.new({
    controls = {
      unpause = { "key:escape" },
    },
  })
end

function pause:update(dt)
  input:update()

  if input:released("unpause") then
    Signal.emit("unpause")
  end
end

function pause:draw()
  love.graphics.print("pause")
end

return pause
