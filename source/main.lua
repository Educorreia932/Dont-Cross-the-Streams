import "CoreLibs/animation"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "game"
import "music"

local gfx <const> = playdate.graphics
local DIALOGMAX <const> = 6
local ENDING_DIALOG_MAX <const> = 5

local explosionSound = 0

local animationFrames = 30
local textPlacement = {
    x= 10,
    y= 140
}
local backgroundImage = nil
local textImage = nil
local startTextImage = nil

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
local endingDialogIndex = 1
local dialog = {
    "Hello class, welcome to another class in Portals.\nWe will be picking up on where\nwe left last time...",
    "Well as you now know cross- Wait... what are\nyou doing?",
    "Hey don't cross the streams!",
    "Did you hear me?? DON'T CROSS THEM!",
    "I SAID..."
}
local endDialog = {
    "Finally, the runes are where they belong...",
    "Now that streams are not crossing, lets resume\nthe class...",
    "Oh...",
    "They all left..."
}

screenManager = {
    currentScreen = 0,
    screens = {
        INTRO = 0,
        TITLE = 1,
        GAME_START = 2,
        GAME = 3,
        ENDING = 4
    }
}

gfx.setBackgroundColor(gfx.kColorBlack)
gfx.clear()

function playdate.update()
    loopTitleScreenMusic()

    if screenManager.currentScreen == screenManager.screens.INTRO then
        introScreen()
        if (dialogIndex > DIALOGMAX and buttonPressed()) then screenManager.currentScreen = screenManager.screens.TITLE end
    elseif screenManager.currentScreen == screenManager.screens.TITLE and not playTitleAnimation() then
        drawBg()
        gfx.sprite.update()
        if buttonPressed() then 
            textImage:clear(gfx.kColorClear)
            startTextImage:clear(gfx.kColorClear)
            screenManager.currentScreen = screenManager.screens.GAME_START end
    elseif screenManager.currentScreen == screenManager.screens.GAME_START then
        player = Player:new(10, 5)
        roomsInitialize()
        background_render()
        loopGameMusic()
        gfx.setLineWidth(2)
        gfx.sprite.update()

        screenManager.currentScreen = screenManager.screens.GAME
    elseif screenManager.currentScreen == screenManager.screens.GAME then
        gameManager()
    elseif screenManager.currentScreen == screenManager.screens.ENDING then
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        endingScreen()
    end 
    gfx.sprite.update()
end

function playTitleAnimation()
    if animationFrames == 0 then 
        backgroundImage:clear(gfx.kColorClear) 
        startText()
        return false end 

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
        stopTitleScreenMusic()
        if explosionSound == 0 then 
            playEnragedWizardSound()
            explosionSound = 1
        end
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        background()

        title() 
        dialogIndex += 1
    end
end

function endingScreen() 
    if (endingDialogIndex < ENDING_DIALOG_MAX) then
        animationFrames = 30

        dialogBox()
        gfx.sprite.update() 

        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        typeWriter(endDialog[endingDialogIndex])

        if (buttonPressed()) then
            gfx.clear()
            typeWriterSetUp()
            endingDialogIndex += 1
        end
    else
        print("here")
        local endingImage = gfx.image.new("images/wizarding_school_background")

        gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			if animationFrames > 0 then
                endingImage:drawFaded(0, 0, 1/animationFrames, gfx.image.kDitherTypeDiagonalLine)
            else
                endingImage:draw(0,0)
            end
			gfx.clearClipRect()
		end
	    )

        animationFrames -= 1
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
    backgroundImage = gfx.image.new("images/wizard_background")

    gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0, 0)
			gfx.clearClipRect()
		end
	)
end

function title()
    textImage = gfx.image.new("images/text_box_title")

    gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			textImage:draw(textPlacement.x, textPlacement.y)
			gfx.clearClipRect()
		end
	)

    if(shakeManager.animFrames > 0) then shake() end
end

function startText()
    startTextImage = gfx.image.new("images/press_start_text")

    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			startTextImage:draw(textPlacement.x + 150, textPlacement.y + 180)
			gfx.clearClipRect()
		end
    )
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
