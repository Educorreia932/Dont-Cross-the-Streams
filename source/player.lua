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
    if playdate.buttonJustPressed(playdate.kButtonUp) and
        detect_collision(self.x, self.y, "up") ~= WALL then
            self.sprite:moveBy(0, -screen.tileSize)
    end
    
    if playdate.buttonJustPressed(playdate.kButtonRight) and 
        detect_collision(self.x, self.y,"right") ~= WALL then
        self.sprite:moveBy(screen.tileSize, 0)
    end
    
    if playdate.buttonJustPressed(playdate.kButtonDown) and
        detect_collision(self.x, self.y, "down") ~= WALL then
        self.sprite:moveBy(0, screen.tileSize)
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft) and
        detect_collision(self.x, self.y, "left") ~= WALL then
        self.sprite:moveBy(-screen.tileSize, 0)
    end
end

