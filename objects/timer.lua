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
-- function Timer:cast()
-- 	if self.state == "ready" then
-- 		self.timer = self.duration
-- 		self.state = "duration"
-- 		print("casted")
-- 	end
-- end
return Timer
