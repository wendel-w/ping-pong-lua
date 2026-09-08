Config = require("config")

-- function love.conf(t)
-- 	t.window.title = "PingPong"
-- 	-- w.window.width = Config.window.width
-- 	t.window.width = 800
-- 	t.window.height = Config.window.height
-- 	t.window.resizable = Config.window.resizable
-- end

-- Table to hold loaded state modules
local states = {}
local currentState = nil
-- Global helper function to switch states
function switchState(stateName)
	currentState = states[stateName]
	if currentState and currentState.load then
		currentState.load() -- Call the new state's load/reset function
	end
end

function love.load()
	--initializing the window
	local w = Config.window
	love.window.setMode(w.width, w.height, {
		resizable = w.resizable,
		vsync = true,
		minwidth = 800,
		minheight = 600,
	})
	love.window.setTitle("Ping Pong")

	-- Require all state modules
	-- states.menu = require("states.menu")
	states.play = require("states.play")
	states.end_screen = require("states.end_screen")
	states.menu = require("states.menu")
	-- states.gameover = require("states.gameover")

	-- Start the game on the menu screen
	-- switchState("play")
	switchState("menu")
	-- switchState("end_screen")
end

function love.update(dt)
	if currentState and currentState.update then
		currentState.update(dt)
	end
end
function love.mousepressed(x, y, button)
	if currentState and currentState.mousepressed then
		currentState.mousepressed(x, y, button)
	end
end

function love.draw()
	if currentState and currentState.draw then
		currentState.draw()
	end
end

function love.keypressed(key)
	if currentState and currentState.keypressed then
		currentState.keypressed(key)
	end
end
