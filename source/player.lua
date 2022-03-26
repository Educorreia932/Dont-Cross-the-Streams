import "rooms"
import "soundeffects"

local pd <const> = playdate
local gfx <const> = pd.graphics

Player = {}
Player.__index = Player

function Player:new(x, y)
    local player = {}
    setmetatable(player, Player)

    player.x = x
    player.y = y

    local image = gfx.image.new("images/player")

	player.sprite = gfx.sprite.new(image)
    player.sprite:setIgnoresDrawOffset(true)
	player.sprite:moveTo(player.x * screen.tileSize, player.y * screen.tileSize)
	player.sprite:add()

    return player
end

function Player:update()
    new_x = self.x
    new_y = self.y

    if playdate.buttonJustPressed(playdate.kButtonUp) then
        new_y = self.y - 1
    elseif playdate.buttonJustPressed(playdate.kButtonDown) then
        new_y = self.y + 1  
    elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
        new_x = self.x - 1  
    elseif playdate.buttonJustPressed(playdate.kButtonRight) then
        new_x = self.x + 1  
    elseif playdate.buttonJustPressed(playdate.kButtonA) then
        self:interact()

        return
    end

    local block = detect_collision(new_x, new_y)

    if block == ACTIVE_PORTAL then
        local portal = find_portal(new_x, new_y)

        playPortalSound()

        -- TODO: Create a portal method for this?
        self.x = portal.twin.x + portal.twin.player_direction.x
        self.y = portal.twin.y + portal.twin.player_direction.y
    elseif block ~= WALL then
        self.x = new_x
        self.y = new_y
    end

    camera_movement()
end

function Player:interact() 
    for i=1, #portals do
        local portal = portals[i]
        local rune = portal.rune

        if rune.x + portal.player_direction.x == self.x and rune.y + portal.player_direction.y == self.y then
            print("Interacting...")
        end
    end
end
