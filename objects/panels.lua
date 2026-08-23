local Panels = {}
Panels.__index = Panels

local top_panel = require("config").top_panel
local bottom_panel = require("config").bottom_panel

local top_font
function Panels:new()
	top_font = love.graphics.newFont(top_panel.font_height)
	local t = setmetatable({}, Panels)

	t.top = {
		height = top_panel.height,
	}
	t.bottom = {
		height = bottom_panel.height,
	}
	t.score = {
		left = 0,
		right = 0,
		to_win = 3,
	}

	return t
end

function Panels:reset_score()
	self.score.left = 0
	self.score.right = 0
end

function Panels:check_winner()
	if self.score.left >= self.score.to_win then
		return "left"
	elseif self.score.right >= self.score.to_win then
		return "right"
	else
		return "none"
	end
end

function Panels:scored(side)
	if side == "left" then
		self.score.left = self.score.left + 1
	elseif side == "right" then
		self.score.right = self.score.right + 1
	end
end

function Panels:draw()
	love.graphics.rectangle("line", 0, 0, love.graphics.getWidth(), self.top.height)
	love.graphics.rectangle(
		"line",
		0,
		love.graphics.getHeight() - self.bottom.height,
		love.graphics.getWidth(),
		self.top.height
	)

	-- love.graphics.setColor(1, 0, 0)
	love.graphics.setFont(top_font)
	love.graphics.printf(
		"Score",
		0,
		top_panel.height / 3 - top_panel.font_height / 2,
		love.graphics.getWidth(),
		"center"
	)
	local score = tostring(self.score.left) .. " - " .. tostring(self.score.right)
	love.graphics.printf(
		score,
		0,
		top_panel.height * 2 / 3 - top_panel.font_height / 2,
		love.graphics.getWidth(),
		"center"
	)
end

return Panels
