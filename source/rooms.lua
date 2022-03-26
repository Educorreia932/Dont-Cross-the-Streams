import "const"
import "portal"

local pd <const> = playdate
local gfx <const> = pd.graphics

local map = {}
local rooms = {
    {10, 2, 3, 4}
}

local portals = {
}

function background_render()
    map_render()
    
    local backgroundImage = gfx.image.new("images/lvl1_map")
    gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(-8, -8)
			gfx.clearClipRect()
		end
	)
end

function detect_collision(x, y)   
    if x < 0 or x > 25 or y < 0 or y > 15 then
        return VOID
    end

    return map[x][y]
end

function map_render()
    for i=1, screen.width do
        map[i] = {}
        
        for j=1, screen.height do
            map[i][j] = 0
        end
    end

    --Mark walls
    for i = 1, #rooms do
        local room = rooms[i]
        local startX = room[1]
        local startY = room[2]
        local endX = room[1] + room[3]
        local endY = room[2] + room[4]

        for i=startX, endX do
            map[i][startY] = WALL
            map[i][endY] = WALL
        end

        for i=startY, endY do
           map[startX][i] = WALL
           map[endX][i] = WALL
        end
    end

    -- Mark portals
    for i = 1, #portals do
        local portal = portals[i]
        local x = portal.x
        local y = portal.y

        map[x][y] = ACTIVE_PORTAL
    end

    printTable(map)
end

