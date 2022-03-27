import "CoreLibs/animation"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "AnimatedSprite/AnimatedSprite.lua"
import "const"
import "music"
import "player"
import "portal"
import "rooms"
import "stream"

local gfx <const> = playdate.graphics

local function initalize()
	print(intersect({0, 0}, {10, 10}, {0, 10}, {10, 0}))
	player = Player:new(10, 5)
	background_render()
    loopGameMusic()
	gfx.setLineWidth(2)
	gfx.setBackgroundColor(gfx.kColorBlack)
end

initalize()

function playdate.update()
	player:update()

	gfx.setDrawOffset(-camera_offset.x.value, -camera_offset.y.value)
	gfx.sprite.update()

	for i = 1, #streams do
		local stream = streams[i]

		stream:draw()
	end
end

function checkStreams()
	for _, s1 in pairs(streams) do
		for _, s2 in pairs(streams) do
			if s1:intersects(s2) then
				return true
			end
		end
	end

	return false
end