import "const"

local pd <const> = playdate
local gfx <const> = pd.graphics

Stream = {}

function Stream:new(portal_1, portal_2)
    local stream = {}
    setmetatable(stream, self)
    self.__index = self

    stream.portal_1 = portal_1
    stream.portal_2 = portal_2
    stream.points = stream:getCurvePoints()

    return stream
end

function Stream:getCurvePoints()
    ptsa = {
        self.portal_1.x,
        self.portal_1.y,
        self.portal_2.x,
        self.portal_2.y,
    }
	tension = 0.5
	numOfSegments = 16

	local _pts
    local res = {}			--/ clone array
	local x
    local y					--/ our x,y coords
    local t1x
    local t2x
    local t1y
    local t2y		--/ tension vectors
	local c1, c2, c3, c4			--/ cardinal points
	local st, t, i				--/ steps based on num. of segments
	local pow3, pow2				--/ cache powers
	local pow32, pow23
	local p0, p1, p2, p3			--/ cache points
	local pl = #ptsa

	--/ clone array so we don't change the original content
	local _pts = {}

    for k, v in ipairs(ptsa) do
       _pts[k] = v
    end

    table.insert(_pts, 1, ptsa[2])
    table.insert(_pts, 1, ptsa[1])
    table.insert(_pts, ptsa[pl - 1])
    table.insert(_pts, ptsa[pl])

	--/ 1. loop goes through point array
	--/ 2. loop goes through each segment between the two points + one point before and after
	----for (i = 2 i < pl i += 2)
    for i=3, pl, 2 do
		p0 = _pts[i]
		p1 = _pts[i + 1]
		p2 = _pts[i + 2]
		p3 = _pts[i + 3]

		--/ calc tension vectors
		t1x = (p2 - _pts[i - 2]) * tension
		t2x = (_pts[i + 4] - p0) * tension

		t1y = (p3 - _pts[i - 1]) * tension
		t2y = (_pts[i + 5] - p1) * tension

        for t=0, numOfSegments do
			--/ calc step
			st = t / numOfSegments
		
			pow2 = math.pow(st, 2)
			pow3 = pow2 * st
			pow23 = pow2 * 3
			pow32 = pow3 * 2

			-- calc cardinals
			c1 = pow32 - pow23 + 1 
			c2 = pow23 - pow32
			c3 = pow3 - 2 * pow2 + st
			c4 = pow3 - pow2

			-- Calc x and y cords with common control vectors
			x = c1 * p0 + c2 * p2 + c3 * t1x + c4 * t2x
			y = c1 * p1 + c2 * p3 + c3 * t1y + c4 * t2y
		
			-- Store points in array
            table.insert(res, x)
            table.insert(res, y)
		end
	end
	
	return res
end

function Stream:draw()
	gfx.setColor(gfx.kColorWhite) -- TODO: Why isn't XOR working?

    for i = 1, #self.points - 4, 2 do
        gfx.drawLine(
            self.points[i] * screen.tileSize, 
            self.points[i + 1] * screen.tileSize, 
            self.points[i + 2] * screen.tileSize, 
            self.points[i + 3] * screen.tileSize
        )
    end
end