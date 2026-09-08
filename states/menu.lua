local Button = require("objects.button")
local Text = require("objects.text")

local menu = {}
local ping_pong_text = Text:new(100, "Ping Pong")
local start_button = Button:new(love.graphics.getHeight() / 3 * 2, "Start Game")

function menu.load() end
function menu.update(dt) end
function menu.mousepressed(x, y, button)
	if button == 1 then
		if start_button:isMouseInside(x, y) == true then
			print("yes")
			switchState("play")
		else
			print("no")
		end
	end
end
function menu.draw()
	ping_pong_text:draw(love.graphics.getHeight() / 3)
	start_button:draw(love.graphics.getHeight() / 3 * 2)
end

return menu
