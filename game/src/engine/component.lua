Component = Object:extend()

function Component:new(id, pos)
	self.id = id
	-- Pos always in cartesian game coordinates.
	self.pos = pos
	self.window = {translate = Vec2(0, 0), scale = 1.0}
	self.queue = {}
end

function Component:load(bus)
	self.bus = bus
end

function Component:save()
end

function Component:update(dt)
	for i, event in ipairs(self.queue) do
		if event.type == "TranslateAndScale" then
			self.window.translate = event.obj.translate
			self.window.scale = event.obj.scale
		end		
	end

	self.queue = {}
end

function Component:draw()
end

function Component:highlight()
end

function Component:handleEvent(event)
	if event.name == "TranslateAndScale" then
		print("Grid:TranslateAndScale. " .. event.translate.x .. " " .. event.translate.y .. " ".. event.scale)
		table.insert(self.queue, { type = event.name, obj = event} )
	end
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





