import "rooms"

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
	player.sprite:moveTo(player.x * screen.tileSize, player.y * screen.tileSize)
	player.sprite:add()

    return player
end

function Player:movement()
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
    end

    local block = detect_collision(new_x, new_y)

    if block == ACTIVE_PORTAL then
        local portal = find_portal(new_x, new_y)
        print(portal)

        self.x = portal.twin.x - 1
        self.y = portal.twin.y
    elseif block ~= WALL then
        self.x = new_x
        self.y = new_y
    end

    self.sprite:moveTo(screen.tileSize * self.x, screen.tileSize * self.y)
end

