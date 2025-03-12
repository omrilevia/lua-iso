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
	require "src.components.tile"
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
	bus = Bus()

	button = Button("save button", Vec2(0, 300), function () return bus:event(Event("save")) end)
	player = Player("assets/player/player.png", Vec2(1, 1))
	gui = Gui("gui", Vec2(0, 0))
	currentScene = Scene({ Grid("grid"), Mouse("mouse"), button, player })

	currentScene:load(bus)
end

function love.update(dt)	
	currentScene:update(dt)
end

function love.draw()
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

	if key == "s" then
		button:press()
	elseif key == "g" then
		if currentScene:getComponent("gui") then
			currentScene:removeComponent("gui")
		else
			currentScene:addComponent(gui)
		end
	end
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


