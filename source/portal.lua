local pd <const> = playdate
local gfx <const> = pd.graphics

Portal = {}
Portal.__index = Portal

function Portal:new(x, y, twin)
    local portal = {}
    setmetatable(portal, Portal)

    portal.x = x
    portal.y = y
    portal.twin = twin

    local image = gfx.image.new("images/portal1.png")
    
	portal.sprite = gfx.sprite.new(image)
    portal.sprite:moveTo(portal.x * screen.tileSize, portal.y * screen.tileSize)
	portal.sprite:add()

    return portal
end

function Portal:setTwin(twin)
    self.twin = twin
    twin.twin = self
end