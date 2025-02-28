Grid = Component:extend()

function Grid:new(id)
	self.grid = {}
	self.queue = {}
	self.xKeys = {}
	self.yKeys = {}
	self.id = id
	Grid.super.new(self, id, Vec2(0, 0))
end

function Grid:load(scene)
	Grid.super:load(scene)

	local constants = Constants()
	love.math.setRandomSeed(os.time())
	local numberGen = love.math.newRandomGenerator()
	for i = 0, constants.GRID_SIZE do
		local row = {}
		for j = 0, constants.GRID_SIZE do
			local randomTex = numberGen:random(1, constants.NUM_TILE_TYPES)
			local tile = Tile(randomTex, Vec2(i, j))
			table.insert(row, j, {pos = Vec2(i, j), tile = tile})
		end
		table.insert(self.grid, i, row)
	end
	
	self:sortTiles()
end

function Grid:sortTiles()
	self.xKeys = {}
	self.yKeys = {}

	for k in pairs(self.grid) do
		table.insert(self.xKeys, k)
	end
	
	-- sort x keys.
	table.sort(self.xKeys, function(a, b) return a < b end)
	
	-- store sorted y keys by which row index they belong to.
	for _, x in ipairs(self.xKeys) do
		local column = self.grid[x]
		local yyKeys = {}

		for y in pairs(column) do
			table.insert(yyKeys, y)
		end

		table.sort(yyKeys, function(a, b) return a < b end)

		self.yKeys[x] = yyKeys
	end
end

function Grid:update(dt)
	-- Highlight a moused over tile.
	local util = Util()
	local gameCoord = util:getGameCoordAt(Vec2(love.mouse:getX(), love.mouse:getY()))
	local gridCoord = Vec2(math.floor(gameCoord.x), math.floor(gameCoord.y))
	if self.grid[gridCoord.x] and self.grid[gridCoord.x][gridCoord.y] then
		self.highlighted = { pos = Vec2(gridCoord.x, gridCoord.y) }
	else 
		self.highlighted = nil
	end
	
	-- Check for a tile add. 
	for i, tile in ipairs(self.queue) do 
		if not self.grid[tile.pos.x] then
			self.grid[tile.pos.x] = {}
		elseif self.grid[tile.pos.x][tile.pos.y] then
			self.grid[gridCoord.x][gridCoord.y] = nil
		end

		self.grid[tile.pos.x][tile.pos.y] = {pos = Vec2(tile.pos.x, tile.pos.y), tile = tile}
	end

	-- Only need to sort the grid if a tile was added.
	-- Sort the keys (indices) of the grid. 
	-- Collect the keys (indices, positive and negative) from the the grid
	if #self.queue > 0 then
		self:sortTiles()
	end

	self.queue = {}
end

function Grid:draw()
	local util = Util()
	local gameCoord = util:getGameCoordAt(Vec2(love.mouse:getX(), love.mouse:getY()))
	local gridCoord = Vec2(math.floor(gameCoord.x), math.floor(gameCoord.y))
	love.graphics.print("grid coord: " .. gridCoord.x .. " " .. gridCoord.y, 0, 100)

	for _, x in ipairs(self.xKeys) do
		local column = self.grid[x]

		for _, y in ipairs(self.yKeys[x]) do
			local tile = column[y]

			if not (self.highlighted and self.highlighted.pos.x == x and self.highlighted.pos.y == y) then
				tile.tile:draw()
			end 
		end
	end

end

function Grid:addTile(sprite)
	-- sprite: id, pos, image, pos in isometric screen coordinates
	local util = Util()
	local gameCoord = util:getGameCoordAt(sprite.pos)
	local gridCoord = Vec2(math.floor(gameCoord.x), math.floor(gameCoord.y))
	print("Grid:addTile. " .. gridCoord.x .. " " .. gridCoord.y .. " tile: " .. sprite.id)
	
	table.insert(self.queue, Tile(sprite.id, Vec2(gridCoord.x, gridCoord.y)))
end



