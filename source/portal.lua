
local pd <const> = playdate
local gfx <const> = pd.graphics

Portal = {}
Portal.__index = Portal

function Portal:new(x, y, vertical, player_direction, rune_direction, i)
    local portal = {}
    setmetatable(portal, Portal)

    if vertical then
        image_table = gfx.imagetable.new("images/portal")
    else
        image_table = gfx.imagetable.new("images/portal-horizontal")
    end

    portal.x = x
    portal.y = y
    portal.twin = twin
    portal.rune = Rune:new(
        portal.x + rune_direction[1],
        portal.y + rune_direction[2],
        i,
        portal
    )
    portal.player_direction = {
        x = player_direction[1], 
        y = player_direction[2]
    }
    portal.rune_direction = {
        x = rune_direction[1], 
        y = rune_direction[2]
    }

    local sprite = AnimatedSprite.new(image_table)

    sprite:moveTo(portal.x * screen.tileSize, portal.y * screen.tileSize)
    sprite:addState("idle", nil, nil, {tickStep = 5}) 
    sprite:playAnimation()
	sprite:add()

    return portal
end


