local gameover = {}

local input
function gameover:enter(previous)
	local baton = require("lib.baton")

	self.from = previous
	input = baton.new({
		controls = {
			unpause = { "key:escape" },
		},
	})
end

function gameover:update(dt)
	input:update()

	if input:released("unpause") then
		Signal.emit("unpause")
	end
end

function gameover:draw()
	if self.from and self.from.draw then
		self.from:draw()
	end

	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf("GAME OVER", 0, love.graphics.getHeight() / 2 - 12, love.graphics.getWidth(), "center")
end

return gameover
