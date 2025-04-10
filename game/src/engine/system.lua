SystemMan = Object:extend()

function SystemMan:new(components)
	self.systems = components
	self.systemMap = {}

	for i, c in ipairs(self.systems) do
		self.systemMap[c.id] = c
	end

	self.queue = {}
end

function SystemMan:load(bus)
	self.bus = bus
	
	-- set self as the listener/broadcaster for events. give bus to components to publish events.
	bus:setBroadcaster(self)
	local data = {}
	-- load saved data
	if love.filesystem.getInfo("savedata") then
		local file = love.filesystem.read("savedata")
		data = lume.deserialize(file) or {}
	end

	for i, val in ipairs(self.systems) do
		local componentData = data[val.id]
		val:load(bus, componentData)
	end
end

function SystemMan:save()
	print("System:save.")
	local data = {}

	for i, val in ipairs(self.systems) do 
		data[val.id] = val:save()
	end

	love.filesystem.write("savedata", lume.serialize(data))
	assert(love.filesystem.getInfo("savedata"))
end

function SystemMan:update(dt)
	if #self.queue > 0 then
		for i, ev in ipairs(self.queue) do
			if ev.name == "save" then
				self:save()
			end
		end
	end

	for i, val in ipairs(self.systems) do
		val:update(dt)
	end

	self.queue = {}
end

function SystemMan:draw()
	for i, val in ipairs(self.systems) do
		val:draw()
	end
end

function SystemMan:event(event)
	if event.name == "save" then
		table.insert(self.queue, event)
		return
	end

	for _, component in ipairs(self.systems) do
		component:handleEvent(event)
	end
end

function SystemMan:shutdown()
	for i, val in ipairs(self.systems) do
		val:shutdown()
	end

end

function SystemMan:textinput(t)
	for i, val in ipairs(self.systems) do
		val:textinput(t)
	end
   
end

function SystemMan:keypressed(key)
	for i, val in ipairs(self.systems) do
		val:keypressed(key)
	end
end

function SystemMan:keyreleased(key)
    for i, val in ipairs(self.systems) do
		val:keyreleased(key)
	end
end

function SystemMan:mousemoved(x, y)
	for i, val in ipairs(self.systems) do
		val:mousemoved(x, y)
	end
end

function SystemMan:mousepressed(x, y, button)
	for i, val in ipairs(self.systems) do
		val:mousepressed(x, y, button)
	end
end

function SystemMan:mousereleased(x, y, button)
	for i, val in ipairs(self.systems) do
		val:mousereleased(x, y, button)
	end
end

function SystemMan:wheelmoved(x, y)
	for i, val in ipairs(self.systems) do
		val:wheelmoved(x, y)
	end
end

function SystemMan:addSystem(component)
	if not component.loaded then 
		component:load(self.bus)
	end

	table.insert(self.systems, component)
	self.systemMap[component.id] = component
end

function SystemMan:removeSystem(id)
	if self.systemMap[id] then
		for j, c in ipairs(self.systems) do
			if c.id == id then
				self.systemMap[id] = nil
				table.remove(self.systems, j)
			end
		end
	end
end

function SystemMan:getSystem(id)
	return self.systemMap[id]
end




