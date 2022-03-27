import "CoreLibs/animation"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"


local gfx <const> = playdate.graphics
local animationFrames = 30
local textPlacement = {
    x= 10,
    y= 150
}

local shakeManager = {
    animFrames = 16,
    offsetIndex = 1,
    offsetX = {1, 2, 1, 0, -1, 0, 1, 2, 1, 0, -1, -2, -1, 0, 1, 0},
    offsetY = {-1, 0, -1, -2, -1, 0, -1, 0, -1, -2, -1, 0, 1, 2, 1, 0}
}

screenManager = {
    currentScreen = 0,
    screens = {
        INTRO = 0,
        TITLE = 1,
        GAME = 2
    }
}

function playdate.update()
    if screenManager.currentScreen == screenManager.screens.INTRO then
        introScreen()
        if buttonPressed() then screenManager.currentScreen = screenManager.screens.TITLE end
    elseif screenManager.currentScreen == screenManager.screens.TITLE and not playAnimation() then
        gfx.drawText("Press any button...", 150, 200)
        if buttonPressed() then screenManager.currentScreen = screenManager.screens.GAME end
    end

    gfx.sprite.update()
end

function playAnimation()
    if animationFrames == 0 then return false end 
    
    textPlacement.y -= 1
    
    title()
    
    animationFrames -= 1

    return true
end

function introScreen()
    background()

    title()    
end

function background()
    local backgroundImage = gfx.image.new("images/wizard_background")

    gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0, 0)
			gfx.clearClipRect()
		end
	)
end

function title()
    local textImage = gfx.image.new("images/text_box_title")

    gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			textImage:draw(textPlacement.x, textPlacement.y)
			gfx.clearClipRect()
		end
	)

    if(shakeManager.animFrames > 0) then shake() end
end

function shake()
    playdate.display.setOffset(shakeManager.offsetX[shakeManager.offsetIndex], shakeManager.offsetY[shakeManager.offsetIndex])

    shakeManager.offsetIndex += 1
    shakeManager.animFrames -= 1
end

function buttonPressed()
    return playdate.buttonJustPressed(playdate.kButtonUp) or
    playdate.buttonJustPressed(playdate.kButtonDown) or
    playdate.buttonJustPressed(playdate.kButtonRight) or
    playdate.buttonJustPressed(playdate.kButtonLeft) or
    playdate.buttonJustPressed(playdate.kButtonA) or
    playdate.buttonJustPressed(playdate.kButtonB)
end
