-- local Ball = require("objects/ball")
-- local Plate = require("objects/plate")
-- local Panels = require("objects/panels")
local end_screen = require("states.end_screen")

local Sound = require("objects/sound")
local config = require("config")

local font

local play = {}

local distance = function(x1, y1, x2, y2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))
end

-- local ball = Ball:new()
-- ball stuff start here
local ball = {
	x = config.ball.x,
	y = config.ball.y,
	radius = config.ball.radius,
	speed = config.ball.speed,
	angle = config.ball.angle,

	fix_angle = function(self)
		while self.angle < 0 do
			self.angle = self.angle + 2 * math.pi
		end
		while self.angle >= 2 * math.pi do
			self.angle = self.angle - 2 * math.pi
		end
	end,
	modify_trajectory = function(self, a)
		self.angle = self.angle + a
		self:fix_angle()
	end,
	bounce_horizontally = function(self)
		self.angle = self.angle * -1
		self:fix_angle()
		Sound.play_bob()
	end,
	bounce_vertically = function(self)
		self.angle = math.rad(180) - self.angle
		self:fix_angle()
		Sound.play_bob()
	end,
	move = function(self)
		self.x = self.x + (self.speed * math.cos(self.angle))
		self.y = self.y + (self.speed * math.sin(self.angle))

		local top = love.graphics.getHeight() - config.bottom_panel.height
		local bottom = config.top_panel.height

		local left = 0
		local right = love.graphics.getWidth()

		if self.y + self.radius > top or self.y - self.radius < bottom then
			self:bounce_horizontally()
		end
		if self.x + self.radius > right or self.x - self.radius < left then
			self:bounce_vertically()
			-- print("hitted left/right wall")
		end
	end,
	draw = function(self)
		love.graphics.circle("fill", self.x, self.y, self.radius)
	end,
	detect_collision = function(self, left_plate, right_plate)
		local return_value = "none"
		-- self:move()
		self.x = self.x + (self.speed * math.cos(self.angle))
		self.y = self.y + (self.speed * math.sin(self.angle))

		local top = love.graphics.getHeight() - config.bottom_panel.height
		local bottom = config.top_panel.height

		local left = 0
		local right = love.graphics.getWidth()

		if self.y + self.radius > top or self.y - self.radius < bottom then
			self:bounce_horizontally()
		end
		if (self.angle < math.rad(90) or math.rad(270) < self.angle) and self.x + self.radius > right then
			self:bounce_vertically()
			-- print("hit right wall")
			return_value = "right"
		end
		if math.rad(90) < self.angle and self.angle < math.rad(270) and self.x - self.radius < left then
			self:bounce_vertically()
			-- print("hit left wall")
			return_value = "left"
		end

		left = left_plate
		right = right_plate
		-- left
		if math.rad(90) < self.angle and self.angle < math.rad(270) then
			if
				--check y coordinates
				left.y < self.y
				and self.y < left.y + left.height
				and distance(self.x, 0, left.x + left.width, 0) < self.radius
				--check x coordinates
				and left.x < self.x - self.radius
				and self.x - self.radius < left.x + left.width
			then
				self:bounce_vertically()
			end
		end
		-- right
		if math.rad(90) > self.angle or self.angle > math.rad(270) then
			if
				--check y coordinates
				self.y > right.y
				and self.y < right.y + right.height
				and distance(self.x, 0, right.x, 0) < self.radius
				--check x coordinates
				and right.x < self.x + self.radius
				and self.x + self.radius < right.x + right.width
			then
				self:bounce_vertically()
			end
		end
		return return_value
	end,
	setSpeed = function(self, s)
		self.speed = s
	end,
}
--ball stuff end here

-- local UpdateAbilities = require("abilities")

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

--plate stuff starts here
local plates = {
	left = {
		x = config.plates.x,
		y = config.plates.y,
		width = config.plates.width,
		height = config.plates.height,
		speed = config.plates.speed,
	},
	right = {
		x = config.plates.x,
		y = config.plates.y,
		width = config.plates.width,
		height = config.plates.height,
		speed = config.plates.speed,
	},
	move = function(self)
		local controls = require("config").plates.controls
		local top_limit = require("config").top_panel.height
		local bottom_limit = love.graphics.getHeight() - require("config").bottom_panel.height
		--left
		if top_limit < self.left.y then
			if love.keyboard.isDown(controls.left_up) then
				self.left.y = self.left.y - self.left.speed
			end
		end
		if self.left.y + self.left.height < bottom_limit then
			if love.keyboard.isDown(controls.left_down) then
				self.left.y = self.left.y + self.left.speed
			end
		end
		--right
		if top_limit < self.right.y then
			if love.keyboard.isDown(controls.right_up) then
				self.right.y = self.right.y - self.right.speed
			end
		end
		if self.right.y + self.right.height < bottom_limit then
			if love.keyboard.isDown(controls.right_down) then
				self.right.y = self.right.y + self.right.speed
			end
		end
	end,
	draw = function(self)
		love.graphics.rectangle("fill", self.left.x, self.left.y, self.left.width, self.left.height)
		self.right.x = love.graphics.getWidth() - config.plates.x - self.right.width
		love.graphics.rectangle("fill", self.right.x, self.right.y, self.right.width, self.right.height)
	end,
	setLeftHeight = function(self, h)
		-- local original_position = self.y
		local original_height = self.left.height
		self.left.height = h
		self.left.y = self.left.y - (self.left.height - original_height) / 2
	end,
	setRightHeight = function(self, h)
		-- local original_position = self.y
		local original_height = self.right.height
		self.right.height = h
		self.right.y = self.right.y - (self.right.height - original_height) / 2
	end,
	teleportLeft = function(self, top_panel_height, bottom_panel_height)
		local old_y = self.left.y - top_panel_height + self.left.height / 2
		local playground_height = love.graphics.getHeight() - top_panel_height - bottom_panel_height
		-- local new_y = top_panel_height + playground_height - old_y
		local new_y = top_panel_height + (old_y + playground_height / 2) % playground_height
		self.left.y = new_y - self.left.height / 2
	end,
	teleportRight = function(self, top_panel_height, bottom_panel_height)
		local old_y = self.right.y - top_panel_height + self.right.height / 2
		local playground_height = love.graphics.getHeight() - top_panel_height - bottom_panel_height
		-- local new_y = top_panel_height + playground_height - old_y
		local new_y = top_panel_height + (old_y + playground_height / 2) % playground_height
		self.right.y = new_y - self.right.height / 2
	end,
}
--plates stuff ends here

-- local left_plate = Plate:new("left")
-- local right_plate = Plate:new("right")

--abilities stuff start here
local Timer = require("objects.timer")
local config = require("config")
local abilities = require("config").abilities
local ability_states = {
	left = {
		size_increase = Timer:new("effect", abilities.size_increase.cooldown, abilities.size_increase.duration),
		speed_up_ball = Timer:new("effect", abilities.speed_up_ball.cooldown, abilities.speed_up_ball.duration),
		knuckleball = Timer:new("instant", abilities.knuckleball.cooldown),
		teleport_enemy = Timer:new("instant", abilities.teleport_enemy.cooldown),
	},
	right = {
		size_increase = Timer:new("effect", abilities.size_increase.cooldown, abilities.size_increase.duration),
		speed_up_ball = Timer:new("effect", abilities.speed_up_ball.cooldown, abilities.speed_up_ball.duration),
		knuckleball = Timer:new("instant", abilities.knuckleball.cooldown),
		teleport_enemy = Timer:new("instant", abilities.teleport_enemy.cooldown),
	},
}
function update_abilities(dt, ball, left_plate, right_plate)
	--size_increase
	local controls = abilities.size_increase.controls
	ability_states.left.size_increase:update(dt, controls.left, function()
		--activate
		plates:setLeftHeight(config.abilities.size_increase.height)
	end, function()
		--deactivate
		plates:setLeftHeight(config.plates.height)
	end)

	ability_states.right.size_increase:update(dt, controls.right, function()
		--activate
		plates:setRightHeight(config.abilities.size_increase.height)
	end, function()
		--deactivate
		plates:setRightHeight(config.plates.height)
	end)

	-- speed_up_ball
	controls = abilities.speed_up_ball.controls
	ability_states.left.speed_up_ball:update(dt, controls.left, function()
		--activate
		ball:setSpeed(abilities.speed_up_ball.speed)
	end, function()
		--deactivate
		ball:setSpeed(config.ball.speed)
	end)
	ability_states.right.speed_up_ball:update(dt, controls.right, function()
		--activate
		ball:setSpeed(abilities.speed_up_ball.speed)
	end, function()
		--deactivate
		ball:setSpeed(config.ball.speed)
	end)

	-- knuckleball
	local min = abilities.knuckleball.limit_min
	local max = abilities.knuckleball.limit_max
	local r = min + math.random() * (max - min) -- e.g., 5.43819...
	-- print("r=", r)
	controls = abilities.knuckleball.controls
	ability_states.left.knuckleball:update(dt, controls.left, function()
		--activate
		print("r=", r)
		ball:modify_trajectory(r)
	end, function() end)
	ability_states.right.knuckleball:update(dt, controls.right, function()
		--activate
		ball:modify_trajectory(r)
	end, function() end)

	--teleport_enemy
	controls = abilities.teleport_enemy.controls
	ability_states.left.teleport_enemy:update(dt, controls.left, function()
		--activate
		plates:teleportRight(config.top_panel.height, config.bottom_panel.height)
	end, function() end)
	ability_states.right.teleport_enemy:update(dt, controls.right, function()
		--activate
		plates:teleportLeft(config.top_panel.height, config.bottom_panel.height)
	end, function() end)
end
--abilities stuff end here

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
	local wall_hit = ball:detect_collision(plates.left, plates.right)
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
		-- print("left won")
		switchState("end_screen")
		end_screen.setWinner("left")
	elseif winner == "right" then
		-- print("right won")
		switchState("end_screen")
		end_screen.setWinner("right")
	end

	-- left_plate:move()
	-- right_plate:move()
	plates:move()

	-- UpdateAbilities:Update(dt, ball, left_plate, right_plate)
	update_abilities(dt, ball, plates.left, plates.right)
end
function play.draw()
	ball:draw()
	-- left_plate:draw()
	-- right_plate:draw()
	plates:draw()

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
