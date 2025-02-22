if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
	Object = require "src.dependencies.classic"
	require "src.model.GameObject"
	require "src.math2d.mat2d"
	require "src.math2d.iso"
	require "src.math2d.vec"
	require "src.graphics.grid"
	require "src.graphics.constants"
	require "src.graphics.tile"

	grid = Grid()
	grid:load()
end

function love.update()	

end

function love.draw()
	grid:draw()
	
end


