lume = require "lib.lume"

Scene = Component:extend()

function Scene:new(mapid, playerRef)
	self.player = playerRef
	self.queue = {}
	self.id = mapid
	self.window = {translate = Vec2(0, 0), scale = 1.0}
	Scene.super.new(self, mapid, Vec2(0, 0))
end

function Scene:load(bus, saveData)
	Scene.super:load(bus)
	local sti = require "lib.sti"


	self.map = sti(self.id)
	--[[ self.world = bump.newWorld(64)
	self.map = sti(self.id, { "bump" } )

	self.map:bump_init(self.world) ]]

	local gameObjects = self.map:addCustomLayer("gameObjects")

	local objectLookup = {}

	for _, layer in ipairs(self.map.layers) do
    	if layer.type == "objectgroup" then 
        	objectLookup[layer.name] = layer.objects  
    	end
	end				
	
	-- Get player spawn object
	local playerSpawn = objectLookup["player"][1]
	local spawnX, spawnY = playerSpawn.x/Constants().TILE_HEIGHT, playerSpawn.y/Constants().TILE_HEIGHT
	local playerScreenPos = Util():getScreenCoordAt(Vec2(spawnX, spawnY))
	self.player.pos = Vec2(spawnX, spawnY)
	self.player:load()
	self.player.collidable = true
	--self.world:add(self.player, playerScreenPos.x + constants.GRID_SIZE * constants.TILE_WIDTH/2 - self.player.image:getWidth()/2, 
	--	playerScreenPos.y, self.player.image:getWidth(), self.player.image:getHeight())

	-- extract object layers from demo map: collisions, sprites
	local collisions = objectLookup["collisions"]
	local sprites = objectLookup["sprites"]

	local drawables = {}
	local hitBoxes = {}

	table.insert(drawables, self.player)
	
	for _, obj in ipairs(sprites) do
		local gid = obj.gid
		local quad = self.map.tiles[gid].quad
		local tileset = self.map.tiles[gid].tileset
		local tilesetImage = self.map.tilesets[tileset].image


		local sortPos = Vec2:fromKey(obj.properties["sortPos"])
		local pos = Vec2(obj.x / constants.TILE_HEIGHT, obj.y / constants.TILE_HEIGHT)

		local sprite = Sprite(gid, pos, {image = tilesetImage, quad = quad})
		sprite.sortPos = sortPos
		sprite.collidable = obj.properties["collidable"]

		table.insert(drawables, sprite)
	end

	--[[ for _, box in ipairs(collisions) do
		local pos = Vec2(box.x / constants.TILE_HEIGHT, box.y / constants.TILE_HEIGHT)
		local w = box.width 
		local h = box.height 

		local screenPos = Util():getScreenCoordAt(pos)
		screenPos.x = screenPos.x + constants.GRID_SIZE/2 * constants.TILE_WIDTH - constants.TILE_WIDTH/2
		--screenPos.y = screenPos

		local obj = {pos = screenPos, w = w, h = w}
		table.insert(hitBoxes, obj)
		self.world:add(obj, screenPos.x, screenPos.y, w, h)
	end ]]

	-- Draw player and sprites
	gameObjects.draw = function(self)
		local gridCoord = Util():getGridCoordAt(Vec2(love.mouse:getX(), love.mouse:getY()), self.window)

		for _, drawable in ipairs(drawables) do
			drawable:draw()
		end

		for _, box in ipairs(hitBoxes) do
			love.graphics.rectangle("line", box.pos.x, box.pos.y, box.w, box.h)
		end
	end

	local world = self.world
	gameObjects.update = function(self, dt)
		for _, drawable in ipairs(drawables) do
			drawable:update(dt)
			local drawableScreenPos = Util():getScreenCoordAt(Vec2(drawable.pos.x, drawable.pos.y))

			if drawable.collidable then
				if drawable.isPlayer then
					drawableScreenPos.y = drawableScreenPos.y -	drawable.image:getHeight()
					drawableScreenPos.x = drawableScreenPos.x - drawable.image:getWidth()/2
				end
				--world:update(drawable, drawableScreenPos.x + constants.GRID_SIZE/2 * constants.TILE_WIDTH, drawableScreenPos.y)
			end
		end

		-- sort drawables 
		table.sort(drawables, function(a, b) 
			return a.sortPos.y < b.sortPos.y or (a.sortPos.y == b.sortPos.y and a.sortPos.x < b.sortPos.x)
		end)
	end
	
	self.map:removeLayer("player")
	self.map:removeLayer("collisions")
	self.map:removeLayer("sprites")
end

function Scene:save() 
	local map = {}

	for i, tileVal in ipairs(self.gridList) do
		table.insert(map, {x = tileVal.drawable.pos.x, y = tileVal.drawable.pos.y, id = tileVal.drawable.id})
	end

	return map
end

function Scene:update(dt)
	-- Highlight a moused over tile.
	self:highlightTile()

	-- Check for a tile add or remove. 
	for i, event in ipairs(self.queue) do 
		if event.type == "add" then
			local tile = event.obj

			if self.gridMap[tile.pos:key()] then
				self.gridMap[tile.pos:key()] = nil
				for j, v in ipairs(self.gridList) do	
					if v.drawable.pos:key() == tile.pos:key() then
						table.remove(self.gridList, j)
					end
				end
			end
			
			-- Ensure tile is loaded.
			if not tile.image then
				tile:load()
			end

			self.gridMap[tile.pos:key()] = tile
			table.insert(self.gridList, {drawable = tile, component = "grid"})
		elseif event.type == "remove" then
		
			if self.gridMap[event.obj:key()] then
				self.gridMap[event.obj:key()] = nil
				for j, v in ipairs(self.gridList) do	
					if v.drawable.pos:key() == event.obj:key() then
						table.remove(self.gridList, j)
					end
				end
			end
		elseif event.type == "TranslateAndScale" then
			self.window.translate = event.obj.translate
			self.window.scale = event.obj.scale
		end
	end

	self.map:update(dt)

	self.queue = {}
end

-- The scene will retrieve the grid's drawables via getDrawables for global draw order.
function Scene:draw()
	local x, y = love.mouse:getPosition()
	local vec = Util():getGridCoordAt(Vec2(x, y), self.window)
	love.graphics.print("Mouse: " .. vec.x .. " " .. vec.y)

	love.graphics.push()
	love.graphics.translate(self.window.translate.x, self.window.translate.y)
	love.graphics.scale(self.window.scale)

		for _, layer in ipairs(self.map.layers) do
			self.map:drawLayer(layer)
		end

		--self.map:bump_draw()

	love.graphics.pop()
end

function Scene:handleEvent(event)
	self.player:handleEvent(event)

	if event.name == "PlaceTile" then
		self:addTile(event.sprite)
	elseif event.name == "RemoveTile" then
		self:removeTile(event)
	elseif event.name == "TranslateAndScale" then
		print("Grid:TranslateAndScale. " .. event.translate.x .. " " .. event.translate.y .. " ".. event.scale)
		table.insert(self.queue, { type = event.name, obj = event} )
	end
end

function Scene:addTile(sprite)
	local util = Util()
	local gridCoord = util:getGridCoordAt(sprite.pos, self.window)
	print("Grid:addTile. " .. gridCoord.x .. " " .. gridCoord.y .. " tile: " .. sprite.id)
	
	table.insert(self.queue, { type = "add", obj = Sprite(sprite.id, Vec2(gridCoord.x, gridCoord.y)) } )
end

function Scene:removeTile(event)
	print("Grid:removeTile. " .. event.pos.x .. " " .. event.pos.y)

	table.insert(self.queue, { type = "remove", obj = event.pos })
end

function Scene:highlightTile()
	local util = Util()
	local gridCoord = util:getGridCoordAt(Vec2(love.mouse:getX(), love.mouse:getY()), self.window)

	--[[ if self.gridMap[gridCoord:key()] then
		self.highlighted = { pos = Vec2(gridCoord.x, gridCoord.y) }
	else 
		self.highlighted = nil
	end ]]
end

function Scene:isScalable()
	return true
end

function Scene:mousepressed(x, y, button)
	if (button == 1) then
		local gameCoordMouse = Util():getGameCoordAt(Vec2(x, y), self.window)
		print("Player move: " .. gameCoordMouse.x .. " " .. gameCoordMouse.y)
		local cos, sin = Util():getUnitVectorPlayerToMouse(gameCoordMouse, self.player.pos)
		
		self.player.moveQueue = {}
		table.insert(self.player.moveQueue, {type = "move", obj = {direction = Vec2(cos, sin), target = gameCoordMouse, world = self.world}})
	end
end





