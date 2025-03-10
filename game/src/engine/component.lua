Component = Object:extend()

function Component:new(id, pos)
	self.id = id
	-- Pos always in cartesian game coordinates.
	self.pos = pos
end

function Component:load(bus)
	self.bus = bus
end

function Component:save()
end

function Component:update(dt)
end

function Component:draw()
end

function Component:handleEvent(event)

end

function Component:shutdown()

end

-- Function to return component drawables which are drawn within the current scene.
-- These drawables are ones which require scene translation and scaling applied. 
-- For components which do not desire to follow translation and scaling within the scene, they should use the draw function.
function Component:getDrawables()
	return {}
end

--
-- User inputs
--
function Component:textinput(t)
   
end

function Component:keypressed(key)
  
end

function Component:keyreleased(key)
    
end

function Component:mousemoved(x, y)

end

function Component:mousepressed(x, y, button)

end

function Component:mousereleased(x, y, button)

end

function Component:wheelmoved(dx, dy)

end





