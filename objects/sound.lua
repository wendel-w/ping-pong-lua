local sound = {}
local config = require("config")

-- local bg_music = {
-- 	love.audio.newSource("sound/xtremefreddy-resurgence.mp3", "stream"),
-- 	love.audio.newSource("sound/xtremefreddy-game-music-loop-3.mp3", "stream"),
-- 	-- bg_music[3] = love.audio.newSource("sound/xtremefreddy-resurgence.mp3")
-- }
local bg_music = {}
local current = 1
local next = 1

local effects = config.sound.effects
local music = config.sound.music

local pop = love.audio.newSource("sound/pop.mp3", "static")
pop:setVolume(0.4)
function sound.play_pop()
	if effects then
		pop:clone():play()
	end
end

local bob = love.audio.newSource("sound/bob.wav", "static")
bob:setVolume(0.4)
function sound.play_bob()
	if effects then
		bob:clone():play()
	end
end

function sound.load()
	bg_music = {
		love.audio.newSource("sound/xtremefreddy-resurgence.mp3", "static"),
		love.audio.newSource("sound/xtremefreddy-game-music-loop-3.mp3", "static"),
		-- bg_music[3] = love.audio.newSource("sound/xtremefreddy-resurgence.mp3")
	}
	next = 1
	current = 1
	-- bg_music[1]:play()
end

function sound.check_bg_music()
	if music then
		-- current = 1
		-- print("current", current)
		if bg_music[current]:isPlaying() == false then
			next = current + 1
			if next > #bg_music then
				next = 1
			end
			bg_music[next]:play()
			print("now playing", next)
			current = next
		end
	end
end

return sound
