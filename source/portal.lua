
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
    self.rune.stream.active = false
    
    print("Rune " .. self.rune.i .. "removed from portal (".. self.x .. "," .. self.y .. ")")
    print("Rune portals:" .. self.rune.stream.rune_1.portal.x, self.rune.stream.rune_1.portal.y, self.rune.stream.rune_2.portal.x, self.rune.stream.rune_2.portal.y)
    
    self.rune = nil
end

function Portal:addRune(rune)
    -- Update rune's coordinates
    rune.x = self.x + self.rune_direction.x
    rune.y = self.y + self.rune_direction.y

    -- Update portal rune's sprite
    rune.sprite:moveTo(rune.x * screen.tileSize, rune.y * screen.tileSize)
    rune.sprite:add()

    -- Update stream
    self.rune = rune

    print(rune.portal.x, rune.stream.rune_1.portal.x, rune.stream.rune_2.portal.x)
    if rune.stream.rune_1.portal == rune.portal then
        rune.stream.rune_1.portal = self
    else
        rune.stream.rune_2.portal = self
    end
    
    rune.stream.points = rune.stream:getCurvePoints()
    self:getTwin().rune.stream = rune.stream
    rune.stream.active = true

    rune.portal = self
    

    print("Rune " .. self.rune.i .. "added to portal (".. self.x .. "," .. self.y .. ")")
end

function Portal:getTwin()
	if self.rune.stream.rune_1.portal == self then
		return self.rune.stream.rune_2.portal
    end

	return self.rune.stream.rune_1.portal
end
