Scene = Object:extend()

function Scene:new(components)
	self.components = components
end

function Scene:load(bus)
	-- set self as the listener/broadcaster for events. give bus to components to publish events.
	bus:setBroadcaster(self)
	local data = {}
	-- load saved data
	if love.filesystem.getInfo("savedata.txt") then
		local file = love.filesystem.read("savedata.txt")
		data = lume.deserialize(file) or {}
	end

	for i, val in ipairs(self.components) do
		local componentData = data[val.id]
		val:load(bus, componentData)
	end
end

function Scene:save()
	local data = {}

	for i, val in ipairs(self.components) do 
		data[val.id] = val:save()
	end

	love.filesystem.write("savedata", data)
end

function Scene:update(dt)
	for i, val in ipairs(self.components) do
		-- circular, but easy way for components to call back into the scene for basic events.
		val:update(dt)
	end
end

function Scene:draw()
	for i, val in ipairs(self.components) do
		val:draw()
	end
end

function Scene:event(event)
	if event.id == "save" then
		self:save()
		return
	end

	for _, component in ipairs(self.components) do
		component:handleEvent(event)
	end
end

function Scene:shutdown()
	for i, val in ipairs(self.components) do
		val:shutdown()
	end

end

function Scene:textinput(t)
	for i, val in ipairs(self.components) do
		val:textinput(t)
	end
   
end

function Scene:keypressed(key)
	for i, val in ipairs(self.components) do
		val:keypressed(key)
	end
end

function Scene:keyreleased(key)
    for i, val in ipairs(self.components) do
		val:keyreleased(key)
	end
end

function Scene:mousemoved(x, y)
	for i, val in ipairs(self.components) do
		val:mousemoved(x, y)
	end
end

function Scene:mousepressed(x, y, button)
	for i, val in ipairs(self.components) do
		val:mousepressed(x, y, button)
	end
end

function Scene:mousereleased(x, y, button)
	for i, val in ipairs(self.components) do
		val:mousereleased(x, y, button)
	end
end

function Scene:wheelmoved(x, y)
	for i, val in ipairs(self.components) do
		val:wheelmoved(x, y)
	end
end

function Scene:addComponent(component)
	table.insert(self.components, {id = component.id, obj = component})
end

function Scene:removeComponent(component)
	for i = #self.components, 1, -1 do
		if self.components[i].id == component.id then
			table.remove(self.components, i)
		end
	end
end

function Scene:getComponent(id)
	for i = #self.components, 1, -1 do
		if self.components[i].id == id then
			return self.components[i]
		end
	end

	return nil
end




