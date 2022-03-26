
local pd <const> = playdate
local gfx <const> = pd.graphics

Portal = {}
Portal.__index = Portal

function Portal:new(x, y, vertical)
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

    portal.sprite = AnimatedSprite.new(image_table)
    portal.sprite:moveTo(portal.x * screen.tileSize, portal.y * screen.tileSize)
    portal.sprite:addState("idle", nil, nil, {tickStep = 5}) 
    portal.sprite:playAnimation()
	portal.sprite:add()

    return portal
end

function Portal:setTwin(twin)
    self.twin = twin
    twin.twin = self
end