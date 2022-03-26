local pd <const> = playdate
local gfx <const> = pd.graphics

playerSprite = nil

function player_movement()
    if playdate.buttonJustPressed(playdate.kButtonUp) then
        playerSprite:moveBy(0, -screen.tileSize)
    end
    if playdate.buttonJustPressed(playdate.kButtonRight) then
        playerSprite:moveBy(screen.tileSize, 0)
    end
    if playdate.buttonJustPressed(playdate.kButtonDown) then
        playerSprite:moveBy(0, screen.tileSize)
    end
    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        playerSprite:moveBy(- screen.tileSize, 0)
    end
end

function player_render()
    local playerImage = gfx.image.new("images/player")
	playerSprite = gfx.sprite.new(playerImage)
	playerSprite:moveTo(200, 120)
	playerSprite:add()
end