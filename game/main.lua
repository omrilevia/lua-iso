if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
	imgui = require "lib.imgui"
	Object = require "lib.classic"

	require "src.engine.component"
	require "src.math2.mat2"
	require "src.math2.iso"
	require "src.math2.vec2"
	require "src.math2.util"
	require "src.components.grid"
	require "src.engine.constants"
	require "src.components.sprite"
	require "src.components.mouse"
	require "src.components.gui"
	require "src.engine.scene"
	require "src.engine.bus"
	require "src.engine.event"
	require "src.engine.events.mousetile"
	require "src.engine.events.placetile"
	require "src.engine.events.removetile"
	require "src.engine.events.dragaddtile"
	require "src.components.button"
	require "src.components.player"

	constants = Constants()

	sti = require("lib.sti")

	--[[ bus = Bus()

	button = Button("save button", Vec2(0, 300), function () return bus:event(Event("save")) end)
	player = Player("assets/player/player.png", Vec2(1, 1))
	gui = Gui("gui", Vec2(0, 0))
	currentScene = Scene({ Grid("grid"), Mouse("mouse"), button, player }

	currentScene:load(bus) ]]

	demoMap = sti("src/maps/test-map01.lua")

	window = {translate = Vec2(constants.X_OFFSET, constants.Y_OFFSET), scale = 1.0}
	
	-- adding a custom layer called "gameObjects" in the fourth layer
	local gameObjects = demoMap:addCustomLayer("gameObjects", 4)

	objectLookup = {}

	for _, layer in ipairs(demoMap.layers) do
    	if layer.type == "objectgroup" then
        	objectLookup[layer.name] = layer.objects  
    	end
	end

	-- Get player spawn object
	local playerSpawn = objectLookup["player"][1]
	local spawnX, spawnY = math.floor(playerSpawn.x/Constants().TILE_WIDTH), math.floor(playerSpawn.y/Constants().TILE_HEIGHT)

	-- extract object layers from demo map: collisions, sprites
	print("Map coord: " .. spawnX .. " " .. spawnY)
	local collisions = objectLookup["collisions"]
	local sprites = objectLookup["sprites"]

	player = Player("assets/player/player.png", Vec2(spawnX, spawnY))
	player:load()

	drawables = {}

	table.insert(drawables, player)
	
	for _, obj in ipairs(sprites) do
		local gid = obj.gid
		local quad = demoMap.tiles[gid].quad
		local tileset = demoMap.tiles[gid].tileset
		local tilesetImage = demoMap.tilesets[tileset].image



		local sortPos = Vec2:fromKey(obj.properties["sortPos"])
		local pos = Vec2:fromKey(obj.properties["pos"])

		local sprite = Sprite(gid, pos, {image = tilesetImage, quad = quad})
		sprite.sortPos = sortPos

		table.insert(drawables, sprite)
	end

	-- Draw player and sprites
	gameObjects.draw = function(self)
		player:draw()
		local util = Util()
		local gridCoord = util:getGridCoordAt(Vec2(love.mouse:getX(), love.mouse:getY()), self.window)
		local constants = Constants() 

		if constants.HINTS then
			love.graphics.print("Mouse grid coordinate: " .. gridCoord.x .. " " .. gridCoord.y, 0, 25)
			love.graphics.print("mouse coordinate: " .. love.mouse:getX() .. " " .. love.mouse:getY(), 0, 65)
		end

		for _, drawable in ipairs(drawables) do
			drawable:draw()
		end
		--[[ -- Temporarily draw a point at our location so we know
		-- that our sprite is offset properly
		love.graphics.setPointSize(5)
		love.graphics.points(math.floor(self.player.x), math.floor(self.player.y)) ]]
	end

	gameObjects.update = function(self, dt)
		for _, drawable in ipairs(drawables) do
			drawable:update(dt)
		end

		-- sort drawables 
		table.sort(drawables, function(a, b) 
			return (a.sortPos.x + a.sortPos.y) < (b.sortPos.x + b.sortPos.y)
		end)
	end
	
	demoMap:removeLayer("player")
	demoMap:removeLayer("collisions")
	demoMap:removeLayer("sprites")

end

function love.update(dt)	
	demoMap:update(dt)
	--currentScene:update(dt)
end

function love.draw()

	love.graphics.push()
	love.graphics.translate(window.translate.x, window.translate.y)
	love.graphics.scale(window.scale)
	demoMap:draw(window.translate.x, window.translate.y, window.scale)
	love.graphics.pop()
	--currentScene:draw()
end

function love.quit()
    --currentScene:shutdown();
end

--
-- User inputs
--
function love.textinput(t)
    --currentScene:textinput(t)
end

function love.keypressed(key)
	--currentScene:keypressed(key)

	--[[ if key == "s" then
		button:press()
	elseif key == "g" then
		if currentScene:getComponent("gui") then
			currentScene:removeComponent("gui")
		else
			currentScene:addComponent(gui)
		end
	end ]]
end

function love.keyreleased(key)
    --currentScene:keyreleased(key)
end

function love.mousemoved(x, y)
    --currentScene:mousemoved(x, y)
end

function love.mousepressed(x, y, button)
	player:mousepressed(x, y, button)
    --currentScene:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    --currentScene:mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
    --currentScene:wheelmoved(x, y)
end


