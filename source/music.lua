local player

local enter_portal_player = playdate.sound.fileplayer.new("sounds/portal")
local loop_music_player = playdate.sound.fileplayer.new("sounds/spooky")
local grab_rune_player = playdate.sound.fileplayer.new("sounds/grabRune")
local title_screen_player = playdate.sound.fileplayer.new("sounds/textscreen")
local enraged_wizard_player = playdate.sound.fileplayer.new("sounds/explosion")

function playBackgroundMusic()
    if screenManager.currentScreen == screenManager.screens.GAME then
        stopTitleScreenMusic()
        loopGameMusic()
    else 
        stopGameMusic()
        loopTitleScreenMusic()
    end
end

function loopGameMusic()
    loop_music_player:play(0)
end

function stopGameMusic()
    loop_music_player:stop()
end

function playPortalSound()
    enter_portal_player:play(1)
end

function playGrabRuneSound()
    grab_rune_player:play(1)
end

function loopTitleScreenMusic()
    title_screen_player:play(0)
end

function stopTitleScreenMusic()
    title_screen_player:stop()
end

function playEnragedWizardSound()
    enraged_wizard_player:play(1)
end