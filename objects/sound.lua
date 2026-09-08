local sound = {}

local pop = love.audio.newSource("sound/pop.mp3", "static")

function sound.play_pop()
	pop:clone():play()
end

local bob = love.audio.newSource("sound/bob.wav", "static")
function sound.play_bob()
	bob:clone():play()
end

return sound
