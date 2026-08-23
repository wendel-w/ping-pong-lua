local Ball = {}
Ball.__index = Ball

local config = require("config")

function Ball:new()
	local conf = require("config").ball
	local b = setmetatable({}, Ball)
	b.x = conf.x
	b.y = conf.y
	b.radius = conf.radius
	b.speed = conf.speed
	b.angle = conf.angle
	return b
end

function Ball:move()
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
		print("hitted left/right wall")
	end
end

local distance = function(x1, y1, x2, y2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))
end

function Ball:fix_angle()
	while self.angle < 0 do
		self.angle = self.angle + 2 * math.pi
	end
	while self.angle >= 2 * math.pi do
		self.angle = self.angle - 2 * math.pi
	end
end
function Ball:bounce_horizontally()
	self.angle = self.angle * -1
	self:fix_angle()
end
function Ball:bounce_vertically()
	self.angle = math.rad(180) - self.angle
	self:fix_angle()
end
function Ball:setSpeed(s)
	self.speed = s
end
function Ball:modify_trajectory(a)
	self.angle = self.angle + a
	self:fix_angle()
end

function Ball:detect_collision(left_plate, right_plate)
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
		print("hit right wall")
		return_value = "right"
	end
	if math.rad(90) < self.angle and self.angle < math.rad(270) and self.x - self.radius < left then
		self:bounce_vertically()
		print("hit left wall")
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
end

function Ball:draw()
	love.graphics.circle("fill", self.x, self.y, self.radius)
end

return Ball
