Scene = Object:extend()

function Scene:new(components)
	self.components = components
end

function Scene:load()
	for i, val in self.components do
		val:load()
	end
end

function Scene:update(dt)
	for i, val in self.components do
		val:update(dt)
	end
end

function Scene:draw()
	for i, val in self.components do
		val:draw()
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


