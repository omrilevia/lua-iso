Grid = Component:extend()

function Grid:new(id)
	self.grid = {}
	self.queue = {}
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
	
end

function Grid:update(dt)
	local util = Util()
	local gameCoord = util:getGameCoordAt(Vec2(love.mouse:getX(), love.mouse:getY()))
	local gridCoord = Vec2(math.floor(gameCoord.x), math.floor(gameCoord.y))
	if self.grid[gridCoord.x] and self.grid[gridCoord.x][gridCoord.y] then
		self.highlighted = { pos = Vec2(gridCoord.x, gridCoord.y) }
	else 
		self.highlighted = nil
	end

	for i, tile in ipairs(self.queue) do 
		if not self.grid[tile.pos.x] then
			self.grid[tile.pos.x] = {}
		elseif self.grid[tile.pos.x][tile.pos.y] then
			self.grid[gridCoord.x][gridCoord.y] = nil
		end

		self.grid[tile.pos.x][tile.pos.y] = {pos = Vec2(tile.pos.x, tile.pos.y), tile = tile}
	end

	self.queue = {}
end

function Grid:draw()
	local util = Util()
	local gameCoord = util:getGameCoordAt(Vec2(love.mouse:getX(), love.mouse:getY()))
	local gridCoord = Vec2(math.floor(gameCoord.x), math.floor(gameCoord.y))
	love.graphics.print("grid coord: " .. gridCoord.x .. " " .. gridCoord.y, 0, 100)
	for i, row in pairs(self.grid) do
		for j, tile in pairs(row) do
			if self.highlighted and self.highlighted.pos.x == i and self.highlighted.pos.y == j then
				-- don't draw highlighted 
			else 
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



