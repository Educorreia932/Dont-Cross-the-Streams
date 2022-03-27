
local pd <const> = playdate
local gfx <const> = pd.graphics

Rune = {}
Rune.__index = Rune

function Rune:new(x, y, i, portal)
    local rune = {}
    setmetatable(rune, Rune)
    
    rune.x = x
    rune.y = y
    rune.portal = portal
    rune.i = i

    local image = gfx.image.new("images/rune" .. i)
    
    rune.sprite = gfx.sprite.new(image)
    rune.sprite:moveTo(rune.x * screen.tileSize, rune.y * screen.tileSize)
	rune.sprite:add()

    return rune
end

function displayRuneGUI(rune)
    local ui = gfx.image.new("images/UI_slot")
    ui_sprite = gfx.sprite.new(ui)
    ui_sprite:setIgnoresDrawOffset(true)
    ui_sprite:moveTo(gui.left_align.x, gui.left_align.y)
    ui_sprite:add()

    if rune ~= nil then
        local image = gfx.image.new("images/big_rune".. rune.i)
        rune.sprite = gfx.sprite.new(image)
        rune.sprite:setIgnoresDrawOffset(true)
        rune.sprite:moveTo(gui.left_align.x, gui.left_align.y)
        rune.sprite:add()
    end
end