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
	require "src.engine.sprite"
	require "src.components.tile"
	require "src.components.mouse"
	require "src.components.gui"
	require "src.engine.scene"
	--grid = Grid()
	--grid:load()
	currentScene = Scene({ Grid("grid"), Gui("gui"), Mouse("mouse") })
	currentScene:load()
	--tilem = Tile(1, Vec2(-1, -1))
	--tilea = Tile(1, Vec2(-1, 0))
	tilea = Tile(1, Vec2(0, 1))
	tileb = Tile(1, Vec2(1, 0))
	tile0 = Tile(1, Vec2(0, 0))
	tile1 = Tile(1, Vec2(1, 1))
	tile2 = Tile(1, Vec2(1, 2))
	tile3 = Tile(1, Vec2(1, 3))
	--assert(screen:getGameCoordAt(Vec2(750, 100)).x == 1)
end

function love.update(dt)	
	--grid:update(dt)
	currentScene:update(dt)
end

function love.draw()
	--tilem:draw()
	--tilea:draw()
	--tilea:draw()
	--tileb:draw()
	--tile0:draw()
	--tile1:draw()
	--tile2:draw()
	--tile3:draw()
	--grid:draw()
	currentScene:draw()
end

function love.quit()
    currentScene:shutdown();
end

--
-- User inputs
--
function love.textinput(t)
    currentScene:textinput(t)
end

function love.keypressed(key)
    currentScene:keypressed(key)
end

function love.keyreleased(key)
    currentScene:keyreleased(key)
end

function love.mousemoved(x, y)
    currentScene:mousemoved(x, y)
end

function love.mousepressed(x, y, button)
    currentScene:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    currentScene:mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
    currentScene:wheelmoved(x, y)
end


