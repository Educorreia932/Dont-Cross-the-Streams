local pd <const> = playdate
local gfx <const> = pd.graphics

function class()
    return setmetatable({}, {
        __call = function(self, ...)
            self:init(...)
            return self
        end
    })
end

Portal = class()

function Portal:init(x, y)
    self.x = x
    self.y = y
end

function Portal:render()
    local image = gfx.image.new("images/portal1.png")
	sprite = gfx.sprite.new(image)

	sprite:moveTo(self.x, self.y)
	sprite:add()
end