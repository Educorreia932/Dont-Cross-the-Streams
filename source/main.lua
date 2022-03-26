import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

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
end

initalize()

function playdate.update()
	gfx.clear()

	player:movement()

	gfx.sprite.update()

	print(player.x .. " " .. player.y .. " " .. camera_offset.x.value .. " " .. camera_offset.y.value)
end