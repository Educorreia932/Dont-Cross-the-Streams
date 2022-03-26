local portalSample

function playPortalSound()
    local portalSample = playdate.sound.sampleplayer.new("sounds/portal")
    portalSample.play(portalSample)
end