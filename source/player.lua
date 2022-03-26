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
        not detect_collision(self.x, self.y,"up") then
            self.sprite:moveBy(0, -screen.tileSize)
    end
    
    if playdate.buttonJustPressed(playdate.kButtonRight) and 
        not detect_collision(self.x, self.y,"right") then
        self.sprite:moveBy(screen.tileSize, 0)
    end
    
    if playdate.buttonJustPressed(playdate.kButtonDown) and
        not detect_collision(self.x, self.y,"down") then
        self.sprite:moveBy(0, screen.tileSize)
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft) and
        not detect_collision(self.x, self.y,"left") then
        self.sprite:moveBy(- screen.tileSize, 0)
    end

end

