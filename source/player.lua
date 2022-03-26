local pd <const> = playdate
local gfx <const> = pd.graphics

playerSprite = nil

function player_movement()
    if playdate.buttonJustPressed(playdate.kButtonUp) and
        not detect_collision(playerSprite.x, playerSprite.y,"up") then
            playerSprite:moveBy(0, -screen.tileSize)
    end
    if playdate.buttonJustPressed(playdate.kButtonRight) and 
        not detect_collision(playerSprite.x, playerSprite.y,"right") then
        playerSprite:moveBy(screen.tileSize, 0)
    end
    if playdate.buttonJustPressed(playdate.kButtonDown) and
        not detect_collision(playerSprite.x, playerSprite.y,"down") then
        playerSprite:moveBy(0, screen.tileSize)
    end
    if playdate.buttonJustPressed(playdate.kButtonLeft) and
        not detect_collision(playerSprite.x, playerSprite.y,"left") then
        playerSprite:moveBy(- screen.tileSize, 0)
    end
end

function player_render()
    local playerImage = gfx.image.new("images/player")
	playerSprite = gfx.sprite.new(playerImage)
	playerSprite:moveTo(160, 160)
	playerSprite:add()
end