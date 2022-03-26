import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "spline"
import "player"
import "rooms"
import "const"

local gfx <const> = playdate.graphics

local playTimer = nil
local playTime = 30 * 1000

local coinSprite = nil

local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

local function moveCoin()
	local randX = math.random(40, 360)
	local randY = math.random(40, 200)
	coinSprite:moveTo(randX, randY)
end

local function initalize()
	math.randomseed(playdate.getSecondsSinceEpoch())
	player_render()
	background_render()
	local coinImage = gfx.image.new("images/coin")
    coinSprite = gfx.sprite.new(coinImage)
	moveCoin()
	coinSprite:setCollideRect(0, 0, coinSprite:getSize())
	coinSprite:add()

	resetTimer()

	local points = {
		0,
		0,

		100,
		150,

		200,
		0
	}

	local spline = Spline()
	res = spline:getCurvePoints(points)
end

initalize()

function playdate.update()
	player_movement()

		local collisions = coinSprite:overlappingSprites()
		if #collisions >= 1 then
			moveCoin()
		end

	playdate.timer.updateTimers()
	gfx.sprite.update()

	for i=1, #res - 4, 4 do
		gfx.drawLine(res[i], res[i+1],res[i+2], res[i+3])
	end
end