import "const"
import "portal"

local pd <const> = playdate
local gfx <const> = pd.graphics

local map = {}
local rooms = {
    {3, 2, 6, 10},
    {9, 2, 5, 5}
}

local portals = {
    Portal:new(14, 4),
    Portal:new(10, 4),
}

portals[1].twin = portals[2]
portals[2].twin = portals[1]

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
            if map[i][startY] == WALL then
                map[i][startY] = VOID
            else    
                map[i][startY] = WALL
            end

            if map[i][endY] == WALL then
                map[i][endY] = VOID
            else    
                map[i][endY] = WALL
            end
        end

        for i=startY, endY do
            if map[startX][i] == WALL then
                map[startX][i] = VOID
            else    
                map[startX][i] = WALL
            end

            if map[endX][i] == WALL then
                map[endX][i] = VOID
            else    
                map[endX][i] = WALL
            end
        end
    end

    -- Mark portals
    for i = 1, #portals do
        local portal = portals[i]
        local x = portal.x
        local y = portal.y

        map[x][y] = ACTIVE_PORTAL
    end
end

function find_portal(x, y)
    for i = 1, #portals do
        local portal = portals[i]

        if portal.x == x and portal.y == y then
            return portal
        end
    end
end
