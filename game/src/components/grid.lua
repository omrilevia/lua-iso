lume = require "lib.lume"

Grid = Component:extend()

function Grid:new(id)
	self.grid = {}
	self.queue = {}
	self.xKeys = {}
	self.yKeys = {}
	self.id = id
	self.window = {translate = Vec2(0, 0), scale = 1.0}
	Grid.super.new(self, id, Vec2(0, 0))
end

function Grid:load(scene, tiles)
	Grid.super:load(scene)

	local constants = Constants()

	love.math.setRandomSeed(os.time())
	local numberGen = love.math.newRandomGenerator()

	if tiles then
		for _, tile in ipairs(tiles) do
			local tileVal = Tile(tile.id, Vec2(tile.x, tile.y))
			tileVal:load()

			if not self.grid[tile.x] then
				self.grid[tile.x] = {}
			end

			self.grid[tile.x][tile.y] = {pos = Vec2(tile.x, tile.y), tile = tileVal}
		end
	else
		for i = 0, constants.GRID_SIZE do
			local row = {}

			for j = 0, constants.GRID_SIZE do
				local id = numberGen:random(1, constants.NUM_TILE_TYPES)
				local tile = Tile(id, Vec2(i, j))
				tile:load()
				table.insert(row, j, {pos = Vec2(i, j), tile = tile})
			end
			table.insert(self.grid, i, row)
		end
    end
	
	self:sortTiles()
end

function Grid:save() 
	local map = {}

	for _, x in ipairs(self.xKeys) do
		for _, y in ipairs(self.yKeys[x]) do
			local tile = self.grid[x][y]

			table.insert(map, {x = tile.pos.x, y = tile.pos.y, id = tile.tile.id})
		end
	end

	return map
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
		local row = self.grid[x]
		local yyKeys = {}

		for y in pairs(row) do
			table.insert(yyKeys, y)
		end

		table.sort(yyKeys, function(a, b) return a < b end)

		self.yKeys[x] = yyKeys
	end
end

function Grid:update(dt)
	-- Highlight a moused over tile.
	local util = Util()
	local gridCoord = util:getGridCoordAt(Vec2(love.mouse.getX(), love.mouse.getY()), self.window)
	if self.grid[gridCoord.x] and self.grid[gridCoord.x][gridCoord.y] then
		self.highlighted = { pos = Vec2(gridCoord.x, gridCoord.y) }
	else 
		self.highlighted = nil
	end
	
	-- Check for a tile add or remove. 
	for i, event in ipairs(self.queue) do 
		if event.type == "add" then
			local tile = event.obj
			if not self.grid[tile.pos.x] then
				self.grid[tile.pos.x] = {}
			elseif self.grid[tile.pos.x][tile.pos.y] then
				self.grid[gridCoord.x][gridCoord.y] = nil
			end
			
			-- Ensure tile is loaded.
			if not tile.image then
				tile:load()
			end

			self.grid[tile.pos.x][tile.pos.y] = {pos = Vec2(tile.pos.x, tile.pos.y), tile = tile}
		elseif event.type == "remove" then
			if self.grid[event.obj.x] then
				self.grid[event.obj.x][event.obj.y] = nil
			end
		elseif event.type == "TranslateAndScale" then
			self.window.translate = event.obj.translate
			self.window.scale = event.obj.scale
		end
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
	love.graphics.push()

	love.graphics.translate(self.window.translate.x, self.window.translate.y)
	love.graphics.scale(self.window.scale)

	for _, x in ipairs(self.xKeys) do
		local row = self.grid[x]

		for _, y in ipairs(self.yKeys[x]) do
			local tile = row[y]

			if not (self.highlighted and self.highlighted.pos.x == x and self.highlighted.pos.y == y) then
				tile.tile:draw()
			end 
		end
	end

	love.graphics.pop()
end

function Grid:handleEvent(event)
	if event.name == "PlaceTile" then
		self:addTile(event.sprite)
	elseif event.name == "RemoveTile" then
		self:removeTile(event)
	elseif event.name == "TranslateAndScale" then
		print("Grid:TranslateAndScale. " .. event.translate.x .. " " .. event.translate.y .. " ".. event.scale)
		table.insert(self.queue, { type = event.name, obj = event} )
	end
end

function Grid:addTile(sprite)
	-- sprite: id, pos, image, pos in isometric screen coordinates
	local util = Util()
	local gridCoord = util:getGridCoordAt(sprite.pos, self.window)
	print("Grid:addTile. " .. gridCoord.x .. " " .. gridCoord.y .. " tile: " .. sprite.id)
	
	table.insert(self.queue, { type = "add", obj = Tile(sprite.id, Vec2(gridCoord.x, gridCoord.y)) } )
end

function Grid:removeTile(event)
	print("Grid:removeTile. " .. event.pos.x .. " " .. event.pos.y)

	table.insert(self.queue, { type = "remove", obj = event.pos })
end

function Grid:highlightTile()
	local util = Util()
	local gridCoord = util:getGridCoordAt(Vec2(love.mouse:getX(), love.mouse:getY()), self.window)
	if self.grid[gridCoord.x] and self.grid[gridCoord.x][gridCoord.y] then
		self.highlighted = { pos = Vec2(gridCoord.x, gridCoord.y) }
	else 
		self.highlighted = nil
	end
end



