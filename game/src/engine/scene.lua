lume = require "lib.lume"

Scene = Component:extend()

function Scene:new(mapid, playerRef)
	self.id = "scene"
	self.player = playerRef
	self.queue = {}
	self.mapId = mapid
	self.window = {translate = Vec2(constants.X_OFFSET, constants.Y_OFFSET), scale = constants.SCALE_FACTOR}
	self.dscale = constants.SCROLL_SCALE_FACTOR
	self.panSpeed = 500
	self.pan = {panXTotal = 0, panYTotal = 0}
	self.panMax = 500
	Scene.super.new(self, mapid, Vec2(0, 0))
end

function Scene:load(bus, saveData)
	saveData = saveData or {}

	Scene.super:load(bus)
	self.sti = require "lib.sti"
	self.HC = require "lib.HC"

	self:instance(self.mapId, saveData)
end

function Scene:instance(mapId, saveData)
	saveData = saveData or {}

	self.collider = self.HC.new(constants.TILE_WIDTH * 4)
	self.mapId = saveData.mapId or mapId

	local mapFile = "/src/maps/" .. self.mapId .. ".lua"
	self.map = self.sti(mapFile)

	-- Bad practice, but let's modify global variable state. Use tileWidth for gridSize analog assuming grid is square. 
	util:setGridSize(self.map.width)

	local gameObjects = self.map:addCustomLayer("gameObjects")

	-- Player and objects from object layers
	local drawables = {}
	local hitboxes = {}

	local objectLookup = {}
	for _, layer in ipairs(self.map.layers) do
    	if layer.type == "objectgroup" then 
        	objectLookup[layer.name] = layer.objects  
    	end
	end				
	
	-- Get player spawn object
	local playerSpawn = objectLookup["player"][1]
	local spawnX, spawnY = playerSpawn.x / Constants().TILE_HEIGHT, playerSpawn.y / Constants().TILE_HEIGHT
	self.player.pos = saveData.playerPos or Vec2(spawnX, spawnY)
	self.player:load()
	table.insert(drawables, self.player)

	local playerScreenPos = util:getRectangleScreenPos(self.player.pos, self.player.image:getWidth(), self.player.image:getHeight())

	-- TODO: set window size and scaling based off of map dimensions.
	self.window = {translate = Vec2(-playerScreenPos.x, -playerScreenPos.y), scale = constants.SCALE_FACTOR}

	-- add player hitbox to the world's collider
	-- current assumption is that player HB is a rectangle based on its image. 
	self.player.hitbox = self.collider:rectangle(playerScreenPos.x + self.player.image:getWidth()/4, playerScreenPos.y, 
		self.player.image:getWidth()/2, self.player.image:getHeight())
	self.player.hitbox.tag = "playerHitbox"

	-- useful to know when the player's feet collide with a specific area. Draw rectangle around player's feet.
	self.player.feet = self.collider:rectangle(playerScreenPos.x + self.player.image:getWidth()/4, playerScreenPos.y + 3/4 * self.player.image:getHeight(), 
	self.player.image:getWidth()/2, self.player.image:getHeight() * 1/4)
	self.player.feet.tag = "playerFeet"

	-- extract object layers from demo map: collisions, sprites, exits
	local collisions = objectLookup["collisions"]
	local sprites = objectLookup["sprites"]
	local collisionNameMap = {}

	-- load collisions
	for _, collision in ipairs(collisions) do
		local gridPos = Vec2(collision.x / constants.TILE_HEIGHT, collision.y / constants.TILE_HEIGHT)
		local screenPos = util:getScreenCoordAt(gridPos)

		if collision.name ~= "" then
			collisionNameMap[collision.name] = gridPos
		end
		
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
		local hcPoly = self.collider:polygon(unpack(polygon.getScreenPoly()))


		if collision.properties.exit then
			hcPoly.tag = "exit:" .. collision.properties.exit
		else
			hcPoly.tag = "collidable"
		end
	end 

	-- load game objects 
	for _, obj in ipairs(sprites) do
		local gid = obj.gid
		local quad = self.map.tiles[gid].quad
		local tileset = self.map.tiles[gid].tileset
		local tilesetImage = self.map.tilesets[tileset].image


		local footprint = obj.properties["footprint"]
		local pos = Vec2(obj.x / constants.TILE_HEIGHT, obj.y / constants.TILE_HEIGHT)

		local sprite = Sprite(gid, pos, {image = tilesetImage, quad = quad})
		sprite.sortPos = collisionNameMap[footprint]
		sprite.collidable = obj.properties["collidable"]

		table.insert(drawables, sprite)
	end

	-- Draw player and sprites
	gameObjects.draw = function(self)
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

-- save player position. For certain maps it makes more sense for the player to reset to one of a few spawn points or checkpoints.
-- save map. 
function Scene:save() 
	local scene = {}

	scene.id = self.id
	scene.playerPos = self.player.pos
	scene.mapId = self.mapId

	return scene
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

	if self.pan["panEvent"] then
		local testX = self.pan.panXTotal + self.pan["panEvent"].translate.x * dt
		local testY = self.pan.panYTotal + self.pan["panEvent"].translate.y * dt

		if (testX < 0 and testX > -self.panMax) or (testX >=0 and testX < self.panMax)  then
			self.window.translate.x = self.pan["panEvent"].translate.x * dt + self.window.translate.x
			self.pan.panXTotal = testX
		end
		
		if (testY < 0 and testY > -self.panMax) or (testY >=0 and testY < self.panMax)  then
			self.window.translate.y = self.pan["panEvent"].translate.y * dt + self.window.translate.y
			self.pan.panYTotal = testY
		end
	end

	self.queue = {}
end

-- The scene will retrieve the grid's drawables via getDrawables for global draw order.
function Scene:draw()
	love.graphics.push()
	love.graphics.translate(self.window.translate.x, self.window.translate.y)
	love.graphics.scale(self.window.scale)

		for _, layer in ipairs(self.map.layers) do
			self.map:drawLayer(layer)
		end

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
	elseif event.name == "Instance" then
		-- TODO: Need to save the current map state somewhere so it can be loaded later.
		self:instance(event.mapId)
	end
end

function Scene:addTile(sprite)
	local gridCoord = util:getGridCoordAt(sprite.pos, self.window)
	print("Grid:addTile. " .. gridCoord.x .. " " .. gridCoord.y .. " tile: " .. sprite.id)
	
	table.insert(self.queue, { type = "add", obj = Sprite(sprite.id, Vec2(gridCoord.x, gridCoord.y)) } )
end

function Scene:removeTile(event)
	print("Grid:removeTile. " .. event.pos.x .. " " .. event.pos.y)

	table.insert(self.queue, { type = "remove", obj = event.pos })
end

function Scene:highlightTile()
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

function Scene:wheelmoved(x, y)
	local mx = love.mouse.getX()
	local my = love.mouse.getY()
    if not (y == 0) then -- mouse wheel moved up or down
--		zoom in to point or zoom out of point
		local mouse_x = mx - self.window.translate.x
		local mouse_y = my - self.window.translate.y
		local k = self.dscale^y
		self.window.scale = self.window.scale * k
		self.window.translate.x = math.floor(self.window.translate.x + mouse_x * (1 - k))
		self.window.translate.y = math.floor(self.window.translate.y + mouse_y * (1 - k))
	else
--		print ('wheel x: ' .. x .. ' y: ' .. y)
    end
end

function Scene:mousemoved(x, y)
	local width, height = love.graphics.getDimensions()
	local panX = 0
	local panY = 0

	if x > (width - 5) then
		panX = - self.panSpeed
	elseif x < 5 then
		panX = self.panSpeed
	end

	if y > (height - 5) then 
		panY = - self.panSpeed
	elseif y < 5 then
		panY = self.panSpeed
	end

	local test = self.window.translate:add(Vec2(panX, panY))

	if test.x ~= self.window.translate.x or test.y ~= self.window.translate.y then
		if self.pan.panEvent then return end 

		self.pan.panEvent = {name = "TranslateAndScale", translate = Vec2(panX, panY), scale = self.window.scale}
	else
		self.pan.panEvent = nil
	end
end





