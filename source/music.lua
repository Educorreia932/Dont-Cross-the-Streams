local player

function loopGameMusic()
    player = playdate.sound.fileplayer.new("sounds/spooky")
    player.play(player, 0)
end