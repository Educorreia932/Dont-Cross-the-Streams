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
	player = Player:new(11, 4)
	background_render()
end

initalize()

function playdate.update()
	player:movement()

	gfx.sprite.update()
end