local Abilities = {}

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

function Abilities:Update(dt, ball, left_plate, right_plate)
	--size_increase
	local controls = abilities.size_increase.controls
	ability_states.left.size_increase:update(dt, controls.left, function()
		--activate
		left_plate:setHeight(config.abilities.size_increase.height)
	end, function()
		--deactivate
		left_plate:setHeight(config.plates.height)
	end)

	ability_states.right.size_increase:update(dt, controls.right, function()
		--activate
		right_plate:setHeight(config.abilities.size_increase.height)
	end, function()
		--deactivate
		right_plate:setHeight(config.plates.height)
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
		right_plate:teleport(config.top_panel.height, config.bottom_panel.height)
	end, function() end)
	ability_states.right.teleport_enemy:update(dt, controls.right, function()
		--activate
		left_plate:teleport(config.top_panel.height, config.bottom_panel.height)
	end, function() end)
end

return Abilities
