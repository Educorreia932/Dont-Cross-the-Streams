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
	gfx.clear()

	player:movement()
	
	gfx.sprite.update()

	local points = {
		portals[1].x * screen.tileSize,
		portals[1].y * screen.tileSize,

		(portals[1].x * screen.tileSize + portals[2].x * screen.tileSize) / 2,
		(portals[1].y * screen.tileSize + portals[2].y * screen.tileSize) / 2 + 50,

		portals[2].x * screen.tileSize,
		portals[2].y * screen.tileSize
	}

	local spline = Spline()
	res = spline:getCurvePoints(points)

	gfx.setColor(gfx.kColorXOR)

	for i=1, #res - 4, 2 do
		gfx.drawLine(res[i], res[i+1],res[i+2], res[i+3])
	end
end