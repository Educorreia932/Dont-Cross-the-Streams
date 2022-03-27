import "CoreLibs/animation"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"


local gfx <const> = playdate.graphics
local DIALOGMAX <const> = 6
local animationFrames = 30
local textPlacement = {
    x= 10,
    y= 140
}

local shakeManager = {
    animFrames = 30,
    offsetX = 0,
    offsetY = 0
}

local typeWriterManager = {
    subStr = {},
    index = 1
}

local dialogIndex = 1
local dialog = {
    "Hello class, welcome to another class in Portals.\nWe will be picking up on where\nwe left last time...",
    "Well as you now know cross- Wait... what are\nyou doing?",
    "Hey don't cross the streams!",
    "Did you hear me?? DON'T CROSS THEM!",
    "I SAID..."
}

screenManager = {
    currentScreen = 0,
    screens = {
        INTRO = 0,
        TITLE = 1,
        GAME = 2
    }
}

gfx.setBackgroundColor(gfx.kColorBlack)
gfx.clear()

function playdate.update()
    if screenManager.currentScreen == screenManager.screens.INTRO then
        introScreen()
        if (dialogIndex > DIALOGMAX and buttonPressed()) then screenManager.currentScreen = screenManager.screens.TITLE end
    elseif screenManager.currentScreen == screenManager.screens.TITLE and not playAnimation() then
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        drawBg()
        gfx.sprite.update()
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawText("*Press any button...*", 140, 200)
        if buttonPressed() then screenManager.currentScreen = screenManager.screens.GAME end
    end 

    gfx.sprite.update()
end

function playAnimation()
    if animationFrames == 0 then return false end 

    textPlacement.y -= 4
    
    title()
    
    animationFrames -= 1

    return true
end

function introScreen()
    if (dialogIndex < DIALOGMAX) then
        dialogBox()
        gfx.sprite.update() 

        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        typeWriter(dialog[dialogIndex])

        if (buttonPressed()) then
            gfx.clear()
            typeWriterSetUp()
            dialogIndex += 1
        end
    else  
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        background()

        title() 
        dialogIndex += 1
    end
end

function dialogBox()
    local dialogBox = gfx.image.new("images/text_box")
    dialogBox:draw(textPlacement.x, textPlacement.y)
end

function drawBg()
    local dialogBox = gfx.image.new("images/startScreen")
    dialogBox:draw(0, 0)
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
    print(backgroundMage)
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
    playdate.display.setOffset(shakeManager.offsetX, shakeManager.offsetY)

    if (shakeManager.animFrames > 2) then
        shakeManager.offsetX = math.random(-6, 6)
        shakeManager.offsetY = math.random(-6, 6)
    else 
        shakeManager.offsetX = 0
        shakeManager.offsetY = 0
    end

    shakeManager.animFrames -= 1
end

function typeWriterSetUp() 
    typeWriterManager.subStr = {}
    typeWriterManager.index = 1
end

function typeWriter(msg) 
    if (typeWriterManager.index > string.len(msg)) then return true end

    for i=1, typeWriterManager.index do
        typeWriterManager.subStr[i] = msg:sub(i,i)
    end

    message = table.concat(typeWriterManager.subStr)

    gfx.drawText(message, 20, 150)

    typeWriterManager.index += 1
end

function buttonPressed()
    return playdate.buttonJustPressed(playdate.kButtonUp) or
    playdate.buttonJustPressed(playdate.kButtonDown) or
    playdate.buttonJustPressed(playdate.kButtonRight) or
    playdate.buttonJustPressed(playdate.kButtonLeft) or
    playdate.buttonJustPressed(playdate.kButtonA) or
    playdate.buttonJustPressed(playdate.kButtonB)
end
