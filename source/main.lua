import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "spline"
import "player"
import "rooms"
import "const"
import "portal"

local gfx <const> = playdate.graphics

local function initalize()
	math.randomseed(playdate.getSecondsSinceEpoch())
	portal = Portal(256, 128)

	portal:render()
	player_render()
end

initalize()

function playdate.update()
	player_movement()

	gfx.sprite.update()
end