
local pd <const> = playdate
local gfx <const> = pd.graphics

Portal = {}
Portal.__index = Portal

function Portal:new(x, y, twin)
    local portal = {}
    setmetatable(portal, Portal)

    local image_table = gfx.imagetable.new("images/portal")

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