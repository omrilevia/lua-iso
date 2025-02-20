if arg[2] == "debug" then
    require("lldebugger").start()
end

TileWidth = 100
TileHeight = 50



function love.load()
	Tiles = {}
	xStart = love.graphics.getWidth()/2 - TileWidth/2
	yStart = 50
	table.insert(Tiles, love.graphics.newImage("assets/tiles/sand.png"));
	table.insert(Tiles, love.graphics.newImage("assets/tiles/water.png"));
	table.insert(Tiles, love.graphics.newImage("assets/tiles/grass.png"));
end

function love.update()	
end

function love.draw()
	drawTile(Tiles[1], 0, 0)
	drawTile(Tiles[1], 1, 0)
	drawTile(Tiles[1], 2, 0)
	drawTile(Tiles[1], 0, 1)
	drawTile(Tiles[1], 0, 2)
end


function drawTile(img, x, y)
	local screenX = xStart + (x - y) * TileWidth/2
	local screenY = yStart + (x + y) * TileHeight/2

	love.graphics.draw(img, screenX, screenY)
end

