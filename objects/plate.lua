local Plate = {}
Plate.__index = Plate

function Plate:new(s)
	local conf = require("config").plates
	local p = setmetatable({}, Plate)
	p.side = s
	if p.side == "left" then
		p.x = conf.x
		p.y = conf.y
	else
		local width = love.graphics.getWidth()
		p.x = width - conf.x - conf.width
		p.y = conf.y
	end
	p.width = conf.width
	p.height = conf.height
	p.speed = conf.speed
	return p
end
function Plate:move()
	local controls = require("config").plates.controls
	local top_limit = require("config").top_panel.height
	local bottom_limit = love.graphics.getHeight() - require("config").bottom_panel.height

	if top_limit < self.y then
		if self.side == "left" and love.keyboard.isDown(controls.left_up) then
			self.y = self.y - self.speed
		elseif self.side == "right" and love.keyboard.isDown(controls.right_up) then
			self.y = self.y - self.speed
		end
	end
	if self.y + self.height < bottom_limit then
		if self.side == "left" and love.keyboard.isDown(controls.left_down) then
			self.y = self.y + self.speed
		elseif self.side == "right" and love.keyboard.isDown(controls.right_down) then
			self.y = self.y + self.speed
		end
	end
end

function Plate:setHeight(h)
	local original_position = self.y
	local original_height = self.height
	self.height = h
	self.y = self.y - (self.height - original_height) / 2
end

function Plate:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Plate:teleport(top_panel_height, bottom_panel_height)
	local old_y = self.y - top_panel_height + self.height / 2
	local playground_height = love.graphics.getHeight() - top_panel_height - bottom_panel_height
	-- local new_y = top_panel_height + playground_height - old_y
	local new_y = top_panel_height + (old_y + playground_height / 2) % playground_height
	self.y = new_y - self.height / 2
end

return Plate
