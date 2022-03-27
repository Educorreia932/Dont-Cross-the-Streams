
local pd <const> = playdate
local gfx <const> = pd.graphics

Portal = {}
Portal.__index = Portal

function Portal:new(x, y, player_direction, rune_direction, i)
    local portal = {}
    setmetatable(portal, Portal)

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

    -- Set portal orientation
    if portal.player_direction.x == 0 then
        image_table = gfx.imagetable.new("images/portal")
    else
        image_table = gfx.imagetable.new("images/portal-horizontal")
    end

    local sprite = AnimatedSprite.new(image_table)

    sprite:moveTo(portal.x * screen.tileSize, portal.y * screen.tileSize)
    sprite:addState("idle", nil, nil, {tickStep = 5}) 
    sprite:playAnimation()
	sprite:add()

    return portal
end

function Portal:setTwin(portal)
    self.twin = portal
    portal.twin = self
end

function Portal:removeRune()
    self.rune.sprite:remove()
    self.rune = nil
    self.stream.active = false
end

function Portal:addRune(rune)
    self.rune = rune
    self.rune.x = self.x + self.rune_direction.x
    self.rune.y = self.y + self.rune_direction.y
    self.rune.sprite:moveTo(self.rune.x * screen.tileSize, self.rune.y * screen.tileSize)
    self.rune.sprite:add()
    self.stream.active = true
end