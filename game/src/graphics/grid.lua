Grid = Object:extend()

function Grid:new()
	self.grid = {}
end

function Grid:load(grid)
	local constants = Constants()
	if not grid then
		local numberGen = love.math.newRandomGenerator(os.time())
		for i = 1, constants.GRID_SIZE do
			local row = {}
			for j = 1, constants.GRID_SIZE do
				local randomTex = numberGen:random(1, constants.NUM_TILE_TYPES)
				local tile = Tile(randomTex, Vec2(i, j))
				tile:load()
				table.insert(row, j, {pos = Vec2(i, j), tile = tile})
			end

		table.insert(self.grid, i, row)
		end
	else 
		self.grid = grid
	end 
end

function Grid:update(dt)
	local constants = Constants()
	local mouse = Mouse()
	local screen = Screen()
	local gameCoord = screen:getGameCoordAt(mouse:getPos())
	local gridCoord = Vec2(math.floor(gameCoord.x) - 1, math.floor(gameCoord.y))
	if gridCoord.x >= 1 and gridCoord.x <= constants.GRID_SIZE then
		self.highlighted = self.grid[gridCoord.x][gridCoord.y]
	end
end

function Grid:draw()
	for i, row in ipairs(self.grid) do
		for j, tile in ipairs(row) do
			if self.highlighted and self.highlighted.pos.x == i and self.highlighted.pos.y == j then
				love.graphics.print("highlighted!!", 0, 100)
			else 
				tile.tile:draw()
			end
		end
	end
end



