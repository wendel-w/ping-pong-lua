local Timer = {}
Timer.__index = Timer
function Timer:new(type, cooldown, d)
	local t = setmetatable({}, Timer)
	if type == "instant" then
		t.type = type
		t.duration = 0
	elseif type == "effect" then
		t.type = type
		t.duration = d
	end
	t.cooldown = cooldown
	t.timer = 0
	t.state = "ready"
	return t
end
function Timer:getStatus()
    if self.state=="ready" then
        return -1
    end
    if self.state=="duration" then
        return self.duration
    end
    if self.state=="cooldown" then
        return self.cooldown
    end
end
function Timer:update(dt, cast_key, effect_start, effect_over)
	if self.state == "ready" and love.keyboard.isDown(cast_key) then
		self.timer = self.duration
		self.state = "duration"
		effect_start()
		-- print("casted")
	elseif self.state == "duration" or self.state == "cooldown" then
		self.timer = self.timer - dt
	end
	--check if duraiton expired
	if self.state == "duration" and self.timer <= 0 then
		self.state = "cooldown"
		self.timer = self.cooldown
		-- print("duration expired")
		effect_over()
	--check if cooldown expired
	elseif self.state == "cooldown" and self.timer <= 0 then
		self.state = "ready"
		self.timer = 0
		-- print("cooldown expired, ability ready")
	end
end

function Timer:draw(x, y)
    local def_rad=20
    if self.state=="ready" then
        love.graphics.circle("fill", x, y, def_rad)
    end
    if self.state=="duration" then

        rad=(self.duration-self.timer)/(self.duration)*def_rad
        love.graphics.setColor(1, 1, 1, 0.7)
        love.graphics.circle("fill", x, y, rad)
        
    end
    if self.state=="cooldown" then
        rad=(self.cooldown-self.timer)/(self.cooldown)*def_rad
        love.graphics.setColor(255, 255, 255, 0.5)
        love.graphics.setColor(1, 1, 1, 0.7)
        love.graphics.circle("fill", x, y, rad)
        love.graphics.circle("fill", x, y, def_rad)
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("line", x, y, def_rad)
end

return Timer
