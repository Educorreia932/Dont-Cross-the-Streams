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

        if portal.stream.active then
            -- Teleport player
            twin = portal:getTwin()

            self.x = twin.x + twin.player_direction.x
            self.y = twin.y + twin.player_direction.y
        end
    elseif block ~= WALL then
        self.x = new_x
        self.y = new_y
    end

    camera_movement()
    displayRuneGUI(player.holding_rune)
end

function Player:interact() 
    for i=1, #portals do
        local portal = portals[i]

        -- Necessary coordinates the player needs to be in order to interact with the portal's rune
        local interact_x = portal.x + portal.player_direction.x + portal.rune_direction.x
        local interact_y = portal.y + portal.player_direction.y + portal.rune_direction.y
        local interacting = interact_x == self.x and interact_y == self.y and portal.rune ~= nil

        if interacting then
            -- Player is holding rune
            if player.holding_rune ~= nil then
                -- Replace portal's rune
                local portal_rune = portal.rune
                portal:removeRune()
                portal:addRune(player.holding_rune)
                player.holding_rune = portal_rune

            -- Player is not holding rune
            else
                player.holding_rune = portal.rune
                portal:removeRune()
            end

            print(player.holding_rune.i)
        end
    end
end
