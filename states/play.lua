local Ball = require("objects/ball")
local Plate = require("objects/plate")
-- local Panels = require("objects/panels")
local end_screen = require("states.end_screen")

local config = require("config")

local font

local play = {}

local ball = Ball:new()
local UpdateAbilities = require("abilities")
-- local panels = Panels:new()

local score_to_win = config.score_to_win
local score = {
	left = 0,
	right = 0,
}
local function reset_score()
	score.left = 0
	score.right = 0
end
local function left_scored()
	score.left = score.left + 1
end
local function right_scored()
	score.right = score.right + 1
end

-- panel stuff start here
local top_panel = {
	height = config.top_panel.height,
}
local bottom_panel = {
	height = config.bottom_panel.height,
}
local function check_winner()
	if score.left >= score_to_win then
		return "left"
	elseif score.right >= score_to_win then
		return "right"
	else
		return "none"
	end
end
--- panel stuff end here

local left_plate = Plate:new("left")
local right_plate = Plate:new("right")

function play.load()
	font = love.graphics.newFont(config.top_panel.font_height)
	local ball_config = require("config").ball
	ball.x = ball_config.x
	ball.y = ball_config.y
	ball.speed = ball_config.speed
	ball.radius = ball_config.radius
	ball.angle = ball_config.angle

	-- panels:reset_score()
	reset_score()
end
function play.update(dt)
	-- ball:move()
	local wall_hit = ball:detect_collision(left_plate, right_plate)
	if wall_hit == "left" then
		-- panels:scored("right")
		right_scored()
	elseif wall_hit == "right" then
		-- panels:scored("left")
		left_scored()
	end
	-- local winner = panels:check_winner()
	local winner = check_winner()
	if winner == "left" then
		print("left won")
		switchState("end_screen")
		end_screen.setWinner("left")
	elseif winner == "right" then
		print("right won")
		switchState("end_screen")
		end_screen.setWinner("right")
	end

	left_plate:move()
	right_plate:move()

	UpdateAbilities:Update(dt, ball, left_plate, right_plate)
end
function play.draw()
	ball:draw()
	left_plate:draw()
	right_plate:draw()

	-- panels:draw()
	-- drawing panels
	-- top
	love.graphics.rectangle("line", 0, 0, love.graphics.getWidth(), config.top_panel.height)
	--bottom
	love.graphics.rectangle(
		"line",
		0,
		love.graphics.getHeight() - bottom_panel.height,
		love.graphics.getWidth(),
		bottom_panel.height
	)
	--score
	love.graphics.setFont(font)
	love.graphics.printf(
		"Score",
		0,
		top_panel.height / 3 - config.top_panel.font_height / 2,
		love.graphics.getWidth(),
		"center"
	)
	local score = tostring(score.left) .. " - " .. tostring(score.right)
	love.graphics.printf(
		score,
		0,
		config.top_panel.height * 2 / 3 - config.top_panel.font_height / 2,
		love.graphics.getWidth(),
		"center"
	)

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
