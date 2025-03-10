lume = require "lib.lume"

Grid = Component:extend()

function Grid:new(id)
	-- Map for O(1) lookup
	self.gridMap = {}
	-- sorted tile list by position
	self.gridList = {}
	self.queue = {}
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

			self.gridMap[Vec2(tile.x, tile.y):key()] = tileVal
			table.insert(self.gridList, tileVal)
		end
	else
		for i = 0, constants.GRID_SIZE do

			for j = 0, constants.GRID_SIZE do
				local id = numberGen:random(1, constants.NUM_TILE_TYPES)
				if id == 6 then id = 7 end
				local tile = Tile(constants.TILE_ASSET_PATH .. "tile-" .. id .. ".png", Vec2(i, j))
				tile:load()

				self.gridMap[Vec2(tile.x, tile.y):key()] = tile
				table.insert(self.gridList, tile)
			end
		end
    end
	
	self:sortTiles()
end

function Grid:save() 
	local map = {}

	for i, tileVal in ipairs(self.gridList) do
		table.insert(map, {x = tileVal.pos.x, y = tileVal.pos.y, id = tileVal.id})
	end

	return map
end

function Grid:sortTiles()

	table.sort(self.gridList, function(a, b)
        -- Primary sorting by Y position
        if a.pos.y ~= b.pos.y then
            return a.pos.y < b.pos.y 
        end
        -- Secondary sorting by X position (in case of same Y)
        return a.pos.x < b.pos.x  -- Lower X is drawn first
    end)
end

function Grid:update(dt)
	-- Highlight a moused over tile.
	self:highlightTile()

	-- Check for a tile add or remove. 
	for i, event in ipairs(self.queue) do 
		if event.type == "add" then
			local tile = event.obj

			if self.gridMap[tile.pos:key()] then
				self.gridMap[tile.pos:key()] = nil
				for j, v in ipairs(self.gridList) do	
					if v.pos:key() == tile.pos:key() then
						table.remove(self.gridList, j)
					end
				end
			end
			
			-- Ensure tile is loaded.
			if not tile.image then
				tile:load()
			end

			self.gridMap[tile.pos:key()] = tile
			table.insert(self.gridList, tile)
		elseif event.type == "remove" then
		
			if self.gridMap[event.obj:key()] then
				self.gridMap[event.obj:key()] = nil
				for j, v in ipairs(self.gridList) do	
					if v.pos:key() == event.obj:key() then
						table.remove(self.gridList, j)
					end
				end
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

	for _, val in ipairs(self.gridList) do
		if not (self.highlighted and self.highlighted.pos:key() == val.pos:key()) then
			val:draw()
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

	if self.gridMap[gridCoord:key()] then
		self.highlighted = { pos = Vec2(gridCoord.x, gridCoord.y) }
	else 
		self.highlighted = nil
	end
end



