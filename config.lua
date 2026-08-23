local M = {
	window = {
		height = 600,
		width = 1000,
		resizable = true,
	},
	ball = {
		x = 800,
		y = 200,
		radius = 20,
		speed = 11,
		angle = math.rad(60),
	},
	plates = {
		x = 30,
		y = 300,
		width = 20,
		height = 100,
		speed = 8,
		controls = {
			left_up = "w",
			left_down = "s",

			right_up = "i",
			right_down = "k",
		},
	},
	top_panel = {
		height = 70,
		font_height = 19,
	},
	bottom_panel = {
		height = 50,
	},
	abilities = {
		size_increase = {
			height = 220,
			duration = 2,
			cooldown = 6,
			controls = {
				left = "a",
				right = "j",
			},
		},
		speed_up_ball = {
			speed = 16,
			duration = 4,
			cooldown = 6,
			controls = {
				left = "q",
				right = "u",
			},
		},
		knuckleball = {
			cooldown = 1,
			limit_min = math.rad(-90),
			limit_max = math.rad(90),
			controls = {
				left = "d",
				right = "l",
			},
		},
		teleport_enemy = {
			cooldown = 2,
			controls = {
				left = "e",
				right = "o",
			},
		},
	},
	button = {
		font_height = 30,
		height = 50,
	},
}
return M
