if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
	Object = require "lib.classic"

	require "src.engine.component"
	require "src.math2.mat2"
	require "src.math2.iso"
	require "src.math2.vec2"
	require "src.math2.util"
	require "src.engine.scene"
	require "src.engine.constants"
	require "src.components.tile"
	require "src.components.mouse"
	require "src.engine.actor"
	require "src.engine.system"
	require "src.engine.bus"

	require "src.engine.event"
	require "src.engine.events.map.instance"
	require "src.engine.events.player.enterdialogarea"
	require "src.engine.events.player.leavedialogarea"

	require "src.components.button"
	require "src.components.player"
	require "src.data.player.playerdata"
	require "src.data.npcs.npcdata"
	require "src.components.npc"

	constants = Constants()
	util = Util(constants.GRID_SIZE, constants.TILE_WIDTH, constants.TILE_HEIGHT)
	
	local bus = Bus()
	-- Eventually will be part of a menu
	local button = Button("Hit 's' to save.", Vec2(0, 80), function() bus:event({name = "save"}) end)
	local player = Player(PlayerData())
	map = Scene("desert", player)

	system = SystemMan({ map, button })

	system:load(bus)
end

function love.update(dt)	
	system:update(dt)

	--currentScene:update(dt)
end

function love.draw()
	system:draw()

	if constants.HINTS then
		local x, y = love.mouse:getPosition()
		local vec = util:getGridCoordAt(Vec2(x, y), map.window)
		local screen = util:getScreenCoordAt(vec)
		love.graphics.print("Mouse: " .. vec.x .. " " .. vec.y)
		love.graphics.print("Mouse px: " .. screen.x .. " " .. screen.y, 0, 20)
		love.graphics.print("True mouse: " .. x .. " " .. y, 0, 40)
		love.graphics.print("Window translate/scale: " .. map.window.translate.x .. " " .. map.window.translate.y .. " " .. map.window.scale, 0, 60)
	end
	
	--currentScene:draw()
end

function love.quit()
	system:shutdown()
    --currentScene:shutdown();
end

--
-- User inputs
--
function love.textinput(t)
	system:textinput(t)
    --currentScene:textinput(t)
end

function love.keypressed(key)
	system:keypressed(key)
	--currentScene:keypressed(key)
end

function love.keyreleased(key)
	system:keyreleased(key)
end

function love.mousemoved(x, y)
	system:mousemoved(x, y)
end

function love.mousepressed(x, y, button)
	system:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    system:mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
    system:wheelmoved(x, y)
end


