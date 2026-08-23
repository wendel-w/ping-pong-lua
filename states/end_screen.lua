local Button = require("objects.button")
local Text = require("objects.text")
local config = require("config").button

local end_screen = {}

local menu_button
local play_again_button
local text

function end_screen:load()
	menu_button = Button:new(love.graphics.getHeight() / 2, 300, "Main menu")
	play_again_button = Button:new(love.graphics.getHeight() * 3 / 4, 300, "Play again")
	text = Text:new(love.graphics.getHeight() / 4, 50, "Somebody won")
end

function end_screen.setWinner(w)
	local winner = "The winner is " .. w
	print(winner)
	text:set_string(winner)
	text.text = winner
end
function end_screen.mousepressed(x, y, button)
	if button == 1 then
		if play_again_button:isMouseInside(x, y) == true then
			print("yes")
			switchState("play")
		else
			print("no")
		end
	end
end

function end_screen:update(dt) end
function end_screen:draw()
	menu_button:draw()
	play_again_button:draw()
	text:draw()
end

return end_screen
