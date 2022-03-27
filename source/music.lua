local player

local enter_portal_player = playdate.sound.fileplayer.new("sounds/portal")
local loop_music_player = playdate.sound.fileplayer.new("sounds/spooky")
local grab_rune_player = playdate.sound.fileplayer.new("sounds/grabRune")

function loopGameMusic()
    loop_music_player:play(0)
end

function playPortalSound()
    enter_portal_player:play(1)
end

function playGrabRuneSound()
    grab_rune_player:play(1)
end
