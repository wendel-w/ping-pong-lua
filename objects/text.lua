local Text = {}
Text.__index = Text

function Text:new(height, text)
	local t = setmetatable({}, Text)
	t.text = text
	t.y = y
	t.height = height
	t.font = love.graphics.newFont(height)
	return t
end

function Text:set_string(s)
	self.text = s
	print("string modified")
	print(s)
	-- self:draw()
end

function Text:draw(y)
	self.y = y
	-- print("self string", self.text)
	love.graphics.setFont(self.font)
	love.graphics.printf(self.text, 0, self.y - self.height / 2, love.graphics.getWidth(), "center")
end
return Text
