local Ball = require("objects/ball")
local Plate = require("objects/plate")
local Panels = require("objects/panels")
local end_screen = require("states.end_screen")

local play = {}

local ball = Ball:new()
local UpdateAbilities = require("abilities")
local panels = Panels:new()

local left_plate = Plate:new("left")
local right_plate = Plate:new("right")

function play.load()
	local ball_config = require("config").ball
	ball.x = ball_config.x
	ball.y = ball_config.y
	ball.speed = ball_config.speed
	ball.radius = ball_config.radius
	ball.angle = ball_config.angle

	panels:reset_score()
end
function play.update(dt)
	-- ball:move()
	local wall_hit = ball:detect_collision(left_plate, right_plate)
	if wall_hit == "left" then
		panels:scored("right")
	elseif wall_hit == "right" then
		panels:scored("left")
	end
	local winner = panels:check_winner()
	if winner == "left" then
		print("left won")
		end_screen.setWinner("left")
		switchState("end_screen")
	elseif winner == "right" then
		print("right won")
		end_screen.setWinner("right")
		switchState("end_screen")
	end

	left_plate:move()
	right_plate:move()

	UpdateAbilities:Update(dt, ball, left_plate, right_plate)
end
function play.draw()
	ball:draw()
	left_plate:draw()
	right_plate:draw()

	panels:draw()

	local top_panel = require("config").top_panel
	local bottom_panel = require("config").bottom_panel
	love.graphics.rectangle(
		"line",
		0,
		top_panel.height,
		love.graphics.getWidth(),
		love.graphics.getWidth() - top_panel.height - bottom_panel.height
	)
end

return play
