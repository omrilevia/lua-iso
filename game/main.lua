if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
	Object = require "src.dependencies.classic"
	require "src.model.GameObject"
	require "src.math2d.mat2"
	require "src.math2d.iso"
	require "src.math2d.vec2"
	require "src.graphics.grid"
	require "src.graphics.constants"
	require "src.graphics.tile"
	require "src.util.mouse"
	require "src.util.screen"

	mouse = Mouse()
	screen = Screen()
	grid = Grid()
	grid:load()
end

function love.update(dt)	
	mouse:update(dt)
	grid:update(dt)
end

function love.draw()
	grid:draw()
	love.graphics.print("Screen coord: " .. mouse:getPos().x .. " " .. mouse:getPos().y .. "\n")
	love.graphics.print("Game coord: " .. screen:getGameCoordAt(mouse:getPos()).x .. " " .. screen:getGameCoordAt(mouse:getPos()).y, 0, 50)
end

function love.keypressed(key)
	if key == "space" then
		love.graphics.captureScreenshot(os.time() .. '-test.png')
	end
end


