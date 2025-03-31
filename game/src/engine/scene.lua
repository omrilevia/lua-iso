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
	local HC = require "lib.HC"

	self.collider = HC.new(constants.TILE_WIDTH * 4)

	self.map = sti(self.id)

	local gameObjects = self.map:addCustomLayer("gameObjects")

	local objectLookup = {}

	-- Player and objects from object layers
	local drawables = {}
	local hitboxes = {}

	for _, layer in ipairs(self.map.layers) do
    	if layer.type == "objectgroup" then 
        	objectLookup[layer.name] = layer.objects  
    	end
	end				
	
	-- Get player spawn object
	local playerSpawn = objectLookup["player"][1]
	local spawnX, spawnY = playerSpawn.x / Constants().TILE_HEIGHT, playerSpawn.y / Constants().TILE_HEIGHT
	self.player.pos = Vec2(spawnX, spawnY)
	self.player:load()
	table.insert(drawables, self.player)

	local playerScreenPos = util:getRectangleScreenPos(self.player.pos, self.player.image:getWidth(), self.player.image:getHeight())

	-- add player hitbox to the world's collider
	-- current assumption is that player HB is a rectangle based on its image. 
	self.player.hitbox = self.collider:rectangle(playerScreenPos.x + self.player.image:getWidth()/4, playerScreenPos.y, 
		self.player.image:getWidth()/2, self.player.image:getHeight())

	-- extract object layers from demo map: collisions, sprites
	local collisions = objectLookup["collisions"]
	local sprites = objectLookup["sprites"]

	
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

	for _, collision in ipairs(collisions) do

		local gridPos = Vec2(collision.x / constants.TILE_HEIGHT, collision.y / constants.TILE_HEIGHT)
		local screenPos = util:getScreenCoordAt(gridPos)
		
		local polygon = {
			shape = "polygon",
			points = collision.polygon,
			pos = Vec2(screenPos.x, screenPos.y),
			getScreenPoly = function() 
				local screenPoly = {}
				for _, point in ipairs(collision.polygon) do
					table.insert(screenPoly, point.x)
					table.insert(screenPoly, point.y)
				end

				return screenPoly
			end
		}

		table.insert(hitboxes, polygon)
		self.collider:polygon(unpack(polygon.getScreenPoly()))
	end 

	-- Draw player and sprites
	gameObjects.draw = function(self)
		local gridCoord = Util():getGridCoordAt(Vec2(love.mouse:getX(), love.mouse:getY()), self.window)

		for _, drawable in ipairs(drawables) do
			drawable:draw()
		end

		for _, hb in ipairs(hitboxes) do
			if hb.shape == "rectangle" then
				love.graphics.rectangle("line", hb.pos.x, hb.pos.y, hb.w, hb.h)
			elseif hb.shape == "polygon" then
				love.graphics.polygon("line", unpack(hb:getScreenPoly()))
				love.graphics.points(hb.pos.x, hb.pos.y)
			end
		end
	end

	local world = self.world
	gameObjects.update = function(self, dt)
		for _, drawable in ipairs(drawables) do
			drawable:update(dt)
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
	local screen = util:getScreenCoordAt(vec)
	love.graphics.print("Mouse: " .. vec.x .. " " .. vec.y)
	love.graphics.print("Mouse px: " .. screen.x .. " " .. screen.y, 0, 20)

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
		local gameCoordMouse = util:getGameCoordAt(Vec2(x, y), self.window)
		print("Player move: " .. gameCoordMouse.x .. " " .. gameCoordMouse.y)
		local cos, sin = util:getUnitVectorObjToMouse(gameCoordMouse, self.player.pos)
		
		self.player.moveQueue = {}
		table.insert(self.player.moveQueue, {type = "move", obj = {direction = Vec2(cos, sin), target = gameCoordMouse, collider = self.collider}})
	end
end





