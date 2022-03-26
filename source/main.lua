import "CoreLibs/animation"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "AnimatedSprite/AnimatedSprite.lua"
import "spline"
import "player"
import "rooms"
import "const"
import "portal"
import "music"

local gfx <const> = playdate.graphics

local function initalize()
	player = Player:new(3, 2)
	background_render()
    loopGameMusic()
	gfx.setLineWidth(2)
end

initalize()

function playdate.update()
	gfx.setDrawOffset(-camera_offset.x.value, -camera_offset.y.value)

	player:movement()
	
	gfx.sprite.update()

	local points = {
		portals[1].x,
		portals[1].y,

		portals[1].x + 3,
		portals[1].y + 3,

		(portals[1].x + portals[3].x) / 3 + 5,
		(portals[1].y + portals[3].y) / 3 + 8,

		portals[3].x,
		portals[3].y
	}

	local spline = Spline()
	res = spline:getCurvePoints(points)

	gfx.setColor(gfx.kColorXOR)

	for i=1, #res - 4, 2 do 
		gfx.drawLine(
			res[i] * screen.tileSize, 
			res[i + 1] * screen.tileSize,
			res[i + 2] * screen.tileSize, 
			res[i + 3] * screen.tileSize
		)
	end
end