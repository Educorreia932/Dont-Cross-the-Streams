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
		local points = streams[i]
		res = Stream:getCurvePoints(points)

		for i = 1, #res - 4, 2 do
	gfx.setColor(gfx.kColorWhite)

			gfx.drawLine(
				res[i] * screen.tileSize, 
				res[i + 1] * screen.tileSize, 
				res[i + 2] * screen.tileSize, 
				res[i + 3] * screen.tileSize
			)
		end
	end
end