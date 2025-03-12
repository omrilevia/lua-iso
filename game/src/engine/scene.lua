Scene = Object:extend()

function Scene:new(components)
	local constants = Constants()
	self.components = components
	self.componentMap = {}

	for i, c in ipairs(self.components) do
		self.componentMap[c.id] = c
	end

	self.queue = {}
	--	sets up window variables
	self.window = {translate={x=0, y=0}, scale=1}
	self.dscale = constants.SCROLL_SCALE_FACTOR 
	self.drawables = {}
	self.highlighted = {}
end

function Scene:load(bus)
	self.bus = bus
	
	-- set self as the listener/broadcaster for events. give bus to components to publish events.
	bus:setBroadcaster(self)
	local data = {}
	-- load saved data
	if love.filesystem.getInfo("savedata") then
		local file = love.filesystem.read("savedata")
		data = lume.deserialize(file) or {}
	end

	for i, val in ipairs(self.components) do
		local componentData = data[val.id]
		val:load(bus, componentData)
	end

	self.drawables = self:collectDrawables()
	self:sortDrawables()
end

function Scene:save()
	print("Scene:save.")
	local data = {}

	for i, val in ipairs(self.components) do 
		data[val.id] = val:save()
	end

	love.filesystem.write("savedata", lume.serialize(data))
	assert(love.filesystem.getInfo("savedata"))
end

function Scene:update(dt)
	if #self.queue > 0 then
		for i, ev in ipairs(self.queue) do
			if ev.name == "save" then
				self:save()
			end
		end
	end

	for i, val in ipairs(self.components) do
		val:update(dt)
	end

	self.queue = {}

	self.drawables = self:collectDrawables()
	self:sortDrawables()
end

function Scene:sortDrawables()
	table.sort(self.drawables, function(a, b) 
		return a.drawable.pos.y < b.drawable.pos.y or 
			(a.drawable.pos.y == b.drawable.pos.y and a.drawable.pos.x == b.drawable.pos.x and a.drawable.index < b.drawable.index) or
			(a.drawable.pos.y == b.drawable.pos.y and a.drawable.pos.x < b.drawable.pos.x)
	end)
end

-- Gets each of the components' drawables, and an optional highlighted component position
function Scene:collectDrawables()
    local drawables = {}
    local index = 1

    for _, component in ipairs(self.components) do
        local componentDrawables, highlighted = component:getDrawables()
		self.highlighted[component.id] = highlighted

        local count = #componentDrawables

        table.move(componentDrawables, 1, count, index, drawables)
        index = index + count
    end

    return drawables
end


function Scene:draw()
	love.graphics.push()
	love.graphics.translate(self.window.translate.x, self.window.translate.y)
	love.graphics.scale(self.window.scale)

	for _, d in ipairs(self.drawables) do
		if not (self.highlighted[d.component] and self.highlighted[d.component].pos.x == d.drawable.pos.x and 
			self.highlighted[d.component].pos.y == d.drawable.pos.y) then
				d.drawable:draw()
		else
			d.drawable:highlight()
		end
	end
 
	love.graphics.pop()

	for i, val in ipairs(self.components) do
		if not val:isScalable() then
			val:draw()
		end
	end
end

function Scene:event(event)
	if event.name == "save" then
		table.insert(self.queue, event)
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
	local mx = love.mouse.getX()
	local my = love.mouse.getY()
    if not (y == 0) then -- mouse wheel moved up or down
--		zoom in to point or zoom out of point
		local mouse_x = mx - self.window.translate.x
		local mouse_y = my - self.window.translate.y
		local k = self.dscale^y
		self.window.scale = self.window.scale * k
		self.window.translate.x = math.floor(self.window.translate.x + mouse_x * (1 - k))
		self.window.translate.y = math.floor(self.window.translate.y + mouse_y * (1 - k))

		self:event({name = "TranslateAndScale", translate = Vec2(self.window.translate.x, self.window.translate.y), scale = self.window.scale})
	else
--		print ('wheel x: ' .. x .. ' y: ' .. y)
    end
	
	for i, val in ipairs(self.components) do
		val:wheelmoved(x, y)
	end
end

function Scene:addComponent(component)
	if not component.loaded then 
		component:load(self.bus)
	end

	table.insert(self.components, component)
	self.componentMap[component.id] = component
end

function Scene:removeComponent(id)
	if self.componentMap[id] then
		for j, c in ipairs(self.components) do
			if c.id == id then
				self.componentMap[id] = nil
				table.remove(self.components, j)
			end
		end
	end
end

function Scene:getComponent(id)
	return self.componentMap[id]
end




