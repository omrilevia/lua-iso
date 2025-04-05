Component = Object:extend()

function Component:new(id, pos)
	self.id = id
	-- Pos always in cartesian game coordinates.
	self.pos = pos
	self.queue = {}
end

function Component:load(bus)
	self.bus = bus
end

function Component:save()
end

function Component:update(dt)
	for i, event in ipairs(self.queue) do
		
	end

	self.queue = {}
end

function Component:draw()
end

function Component:highlight()
end

function Component:handleEvent(event)

end

function Component:shutdown()

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





