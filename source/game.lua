import "lib/AnimatedSprite/AnimatedSprite.lua"
import "const"
import "music"
import "player"
import "portal"
import "rooms"
import "stream"

local gfx <const> = playdate.graphics

function gameManager()
	player:update()

	gfx.setDrawOffset(-camera_offset.x.value, -camera_offset.y.value)

	for i = 1, #streams do
		local stream = streams[i]

		stream:draw()
	end
end

function checkStreams()
	for _, s1 in pairs(streams) do
		for _, s2 in pairs(streams) do
			if s1 ~= s2 and s1:intersects(s2) then
				return false
			end
		end
	end

	return true
end