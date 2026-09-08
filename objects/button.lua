local Button = {}
Button.__index = Button

local config = require("config").button

function Button:new(width, text)
	local b = setmetatable({}, Button)
	-- b.x = x
	b.y = y
	b.height = config.height
	b.width = width
	b.font = love.graphics.newFont(config.font_height)
	b.text = text
	return b
end

function Button:isMouseInside(x, y)
	local self_x = love.graphics.getWidth() / 2 - (self.width / 2)
	local self_y = self.y - config.font_height / 2
	print("got", x, y)
	print("self", self_x, self_y)
	-- love.graphics.circle("fill", self_x, 0, 1000)
	if self_x < x and x < self_x + self.width and self_y < y and y < self_y + self.height then
		print("detected")
		return true
	else
		return false
	end
end

function Button:draw(y)
	self.y = y
	love.graphics.rectangle(
		"line",
		love.graphics.getWidth() / 2 - self.width / 2,
		self.y - self.height / 2,
		self.width,
		self.height
	)
	love.graphics.setFont(self.font)
	love.graphics.printf(self.text, 0, self.y - config.font_height / 2, love.graphics.getWidth(), "center")
end
return Button
