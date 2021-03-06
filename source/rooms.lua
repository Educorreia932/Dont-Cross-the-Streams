import "const"
import "portal"
import "rune"

local pd <const> = playdate
local gfx <const> = pd.graphics

function roomsInitialize()
    map = {}
    rooms = {
        -- room 1
        {3, 2, 6, 10},
        {9, 2, 5, 5},
        -- room 2
        {35, 2, 7, 8},
        -- room 3
        {12, 23, 3, 5},
        {15, 19, 6, 9},
        {21, 23, 3, 5},
        -- room 4
        {36, 20, 8, 7}
    }

    backgroundImage = gfx.image.new("images/lvl1_map")

    portals = {
        Portal:new(14, 4, {-1, 0}, {0, 1}, 1),
        Portal:new(6, 12, {0, -1}, {1, 0}, 2),
        Portal:new(12, 25, {1, 0}, {0, 1}, 3),
        Portal:new(24, 25, {-1, 0}, {0, 1}, 4),
        Portal:new(36, 25, {1, 0}, {0, 1}, 5),
        Portal:new(40, 20, {0, 1}, {1, 0}, 6),
        Portal:new(39, 10, {0, -1}, {1, 0}, 7),
        Portal:new(35, 5, {1, 0}, {0, 1}, 8)
    }

    portals[1]:setTwin(portals[3])
    portals[2]:setTwin(portals[5])
    portals[4]:setTwin(portals[7])
    portals[6]:setTwin(portals[8])

    streams = {}

    camera_offset = {
        x = {
            value = 0,
            free_roam = false
        },
        y = {
            value = 0,
            free_roam = false
        }
    }
end

function background_render()
    map_render()
end

function detect_collision(x, y)   
    if x < 0 or x > 50 or y < 0 or y > 30 then
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

    -- Mark portals and streans
    for i = 1, #portals do
        local portal = portals[i]
        local x = portal.x
        local y = portal.y

        map[x][y] = ACTIVE_PORTAL

        if portal.rune.stream == nil then
            local stream = Stream:new(portal.rune, portal.twin.rune)

            portal.rune.stream = stream
            portal.twin.rune.stream = stream

            table.insert(streams, stream)
        end
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

function camera_movement()
    camera_offset.x.value = (player.x - 10) * screen.tileSize
    camera_offset.y.value = (player.y - 5) * screen.tileSize

    gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
            gfx.setDrawOffset(-camera_offset.x.value, -camera_offset.y.value)
			gfx.clear()
            gfx.sprite.redrawBackground()
            backgroundImage:draw(-8, -8)
			gfx.clearClipRect()
		end
	)
end


