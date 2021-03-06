import "rooms"
import "music"

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

        if portal.rune ~= nil and portal.rune.stream.active then
            -- Teleport player
            playPortalSound()

            twin = portal:getTwin()

            self.x = twin.x + twin.player_direction.x
            self.y = twin.y + twin.player_direction.y
        end
    elseif block ~= WALL then
        self.x = new_x
        self.y = new_y
    end

    camera_movement()
    displayRuneGUI()
end

function Player:interact() 
    for i=1, #portals do
        local portal = portals[i]

        -- Necessary coordinates the player needs to be in order to interact with the portal's rune
        local interact_x = portal.x + portal.player_direction.x + portal.rune_direction.x
        local interact_y = portal.y + portal.player_direction.y + portal.rune_direction.y
        local interacting = interact_x == self.x and interact_y == self.y

        if interacting then
            playGrabRuneSound()

            -- Player is holding rune
            if player.holding_rune ~= nil then
                -- Check if origin and destination of the stream are the same
                if player.holding_rune.stream.rune_1 == player.holding_rune then
                    originating_portal = player.holding_rune.stream.rune_2.portal
                else
                    originating_portal = player.holding_rune.stream.rune_1.portal
                end

                local destination_portal = portal

                if originating_portal == destination_portal then
                    return
                end

                -- Replace portal's rune
                local portal_rune = portal.rune

                if portal_rune ~= nil then
                    portal:removeRune()
                end

                portal:addRune(player.holding_rune)
                player.holding_rune = portal_rune
            -- Player is not holding rune
            else
                player.holding_rune = portal.rune
                portal:removeRune()
            end

            -- Check if any streams cross
            if checkStreams() then
                gfx.clear(gfx.kColorBlack)
                gfx.sprite.removeAll()
                screenManager.currentScreen = screenManager.screens.ENDING 
            end
        end
    end
end
