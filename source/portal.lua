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

    return portal
end

function Portal:render()
    local image = gfx.image.new("images/portal1.png")
	local sprite = gfx.sprite.new(image)

	sprite:moveTo(self.x, self.y)
	sprite:add()
end

function Portal:setTwin(twin)
    self.twin = twin
    twin.twin = self
end