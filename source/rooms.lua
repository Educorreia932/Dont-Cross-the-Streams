local pd <const> = playdate
local gfx <const> = pd.graphics

local map = {}
local rooms = {
    4,
    {24, 24, 144, 128}, --startposition(x,y), width, height
    {256, 24, 96, 112},
    {160, 96, 144, 144},
    {256, 160, 112, 112}
}

function background_render()
    map_render()
    
    local backgroundImage = gfx.image.new("images/lvl1_map")
    gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0, 0)
			gfx.clearClipRect()
		end
	)
end

function detect_collision(x, y, direction)   
    if (direction == "up" and y - screen.tileSize >= 0 and map[x][y - screen.tileSize] == 1)
    or (direction == "down" and y + screen.tileSize <= screen.height and map[x][y + screen.tileSize] == 1)
    or (direction == "right" and x + screen.tileSize <= screen.width and map[x + screen.tileSize][y] == 1)
    or (direction == "left" and x - screen.tileSize >= 0 and map[x - screen.tileSize][y] == 1) then
        return true
    end

    return false
end

function map_render()
    for i=1, screen.width do
        map[i] = {}
        for j=1, screen.height do
            map[i][j] = 0
        end
    end

    --mark walls
    for i=2, rooms[1] do
        local room = rooms[i]
        local startX = room[1]
        local startY = room[2]
        local endX = room[1] + room[3]
        local endY = room[2] + room[4]

        for i=startX, endX do
            map[i][startY] = 1
            map[i][endY] = 1
        end
        for i=startY, endY do
           map[startX][i] = 1
           map[endX][i] = 1
        end
    end
end

