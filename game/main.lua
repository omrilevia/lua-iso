if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
	imgui = require "lib.imgui"
	Object = require "lib.classic"
	require "src.components.component"
	require "src.math2.mat2"
	require "src.math2.iso"
	require "src.math2.vec2"
	require "src.components.grid"
	require "src.engine.constants"
	require "src.components.sprite"
	require "src.components.tile"
	require "src.engine.mouse"
	require "src.engine.screen"
	require "src.components.gui"

	mouse = Mouse()
	screen = Screen()
	grid = Grid()
	gui = Gui()
	gui:load()
	grid:load()
	--assert(screen:getGameCoordAt(Vec2(750, 100)).x == 1)
end

function love.update(dt)	
	mouse:update(dt)
	grid:update(dt)
	gui:update(dt)
end

function love.draw()
	grid:draw()
	gui:draw()
end

function love.quit()
    gui:shutdown();
end

--
-- User inputs
--
function love.textinput(t)
    gui:textinput(t)
end

function love.keypressed(key)
    gui:keypressed(key)
end

function love.keyreleased(key)
    gui:keyreleased(key)
end

function love.mousemoved(x, y)
    gui:mousemoved(x, y)
end

function love.mousepressed(x, y, button)
    gui:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    gui:mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
    gui:wheelmoved(x, y)
end


