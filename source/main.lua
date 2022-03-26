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
end