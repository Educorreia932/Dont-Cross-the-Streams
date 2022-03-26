
local pd <const> = playdate
local gfx <const> = pd.graphics

Rune = {}
Rune.__index = Rune

function Rune:new(x, y, i)
    local rune = {}
    setmetatable(rune, Rune)
    
    rune.x = x
    rune.y = y

    local image = gfx.image.new("images/rune" .. i)

    rune.sprite = gfx.sprite.new(image)
    rune.sprite:moveTo(rune.x * screen.tileSize, rune.y * screen.tileSize)
	rune.sprite:add()

    return rune
end