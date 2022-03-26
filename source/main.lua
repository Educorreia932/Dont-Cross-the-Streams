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
	player = Player:new(10, 5)
	background_render()
    loopGameMusic()
	gfx.setLineWidth(2)
end

initalize()

function playdate.update()
	player:movement()

	gfx.setDrawOffset(-camera_offset.x.value, -camera_offset.y.value)

	gfx.sprite.update()

	for i = 1, #streams do
		local stream = streams[i]

		stream:draw()
	end
end