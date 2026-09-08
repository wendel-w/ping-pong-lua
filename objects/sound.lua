local sound = {}
local config = require("config")

local effects = config.sound.effects
local music = config.sound.music

local pop = love.audio.newSource("sound/pop.mp3", "static")
function sound.play_pop()
	if effects then
		pop:clone():play()
	end
end

local bob = love.audio.newSource("sound/bob.wav", "static")
function sound.play_bob()
	if effects then
		bob:clone():play()
	end
end

return sound
