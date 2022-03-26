-- Spline.lua
--
function class()
    return setmetatable({}, {
        __call = function(self, ...)
            self:init(...)
            return self
        end
    })
end

Spline = class()

function Spline:init()
end

--!
--  	Smooth curves on canvas version 1.3
--
--		By Ken Fyrstenberg Nilsen (c) 2013
--		Abdias Software, http:--abdiassoftware.com/
--
--		MIT licensed.
--
--
--
--	History:
--
--		1.3		Speed optimizations.
--				Closed mode obsolete (no solution at this point). No change in arguments
--				for backward (and possible future) compatibility but does nothing.
--
--		1.2		Now also an extension to Canvas' context: context.drawCurve()
--
--		1.1		Split main function into three functions so one can retrieve point array
--				separately without drawing. Widens its usage. The three functions are:
--				  drawCurve()		- as before
--				  getCurvePoints()	- get a point array with smooth points based on point array
--				  drawLines()		- draws an array of points to canvas (any point list will do)
--
--

--
--		Uses an array of points (x,y) to return an array containing points
--		for a smooth curve.
--
--	USAGE:
--
--		getCurvePoints(points, tension, numberOfSegments)
--
--		getCurvePoints(array)
--		getCurvePoints(array, float)
--		getCurvePoints(array, float, boolean)
--		getCurvePoints(array, float, boolean, integer)
--
--		points				= array of float or integers arranged as x1,y1,x2,y1,...,xn,yn. Minimum 2 points.
--		tension				= 0-1, 0 = no smoothing, 0.5 = smooth (default), 1 = very smoothed
--		numberOfSegments	= resolution of the smoothed curve. Higer number -> smoother (default 16)
--
--		NOTE: array must contain a minimum set of two points.
--		Known bugs: closed curve draws last point wrong.
--

function Spline:getCurvePoints(ptsa, tension, numOfSegments)

	-- use input value if provided, or use a default value	 
	tension = tension or 0.5
	numOfSegments = numOfSegments or 16

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
	local _pts = ptsa
    --for k, v in ipairs(ptsa) do
    --    _pts[k] = v
    --end

    table.insert(_pts, ptsa[2], 1)
    table.insert(_pts, ptsa[1], 1)
    table.insert(_pts, ptsa[pl - 1])
    table.insert(_pts, ptsa[pl - 0])

	--/ 1. loop goes through point array
	--/ 2. loop goes through each segment between the two points + one point before and after
	----for (i = 2 i < pl i += 2)
    for i=3, pl, 2 do
		p0 = _pts[i]
		p1 = _pts[i + 1]
		p2 = _pts[i + 2]
		p3 = _pts[i + 3]

		--/ calc tension vectors
		t1x = (p2 - _pts[i - 2])* tension
		t2x = (_pts[i + 4] - p0)* tension

		t1y = (p3 - _pts[i - 1])* tension
		t2y = (_pts[i + 5] - p1) * tension

        for t=0, numOfSegments do

			--/ calc step
			st = t / numOfSegments
		
			pow2 = math.pow(st, 2)
			pow3 = pow2 * st
			pow23 = pow2 * 3
			pow32 = pow3 * 2

			--/ calc cardinals
			c1 = pow32 - pow23 + 1 
			c2 = pow23 - pow32
			c3 = pow3 - 2 * pow2 + st
			c4 = pow3 - pow2

			--/ calc x and y cords with common control vectors
			x = c1 * p0 + c2 * p2 + c3 * t1x + c4 * t2x
			y = c1 * p1 + c2 * p3 + c3 * t1y + c4 * t2y
		
			--/ store points in array
            table.insert(res, x)
            table.insert(res, y)
		end
	end
	
	return res
end
