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
	require "src.engine.scene"
	require "src.engine.constants"
	require "src.components.sprite"
	require "src.components.mouse"
	require "src.components.gui"
	require "src.engine.system"
	require "src.engine.bus"
	require "src.engine.event"
	require "src.engine.events.mousetile"
	require "src.engine.events.placetile"
	require "src.engine.events.removetile"
	require "src.engine.events.dragaddtile"
	require "src.components.button"
	require "src.components.player"

	constants = Constants()
	local bus = Bus()
	local player = Player("assets/player/player.png", Vec2(1, 1))
	local map = Scene("src/maps/desert.lua", player)

	system = SystemMan({ map })
	system:load(bus)
end

function love.update(dt)	
	system:update(dt)

	--currentScene:update(dt)
end

function love.draw()
	system:draw()

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


