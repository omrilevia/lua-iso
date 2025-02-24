Mouse = Component:extend()

function Mouse:new()
	self.x = love.mouse:getX()
	self.y = love.mouse.getY()
end

function Mouse:update(dt)
	self.x = love.mouse:getX()
	self.y = love.mouse:getY()
end

function Mouse:draw()
end

function Mouse:getPos()
	return Vec2(self.x, self.y)
end

function Mouse:attachComponent(component)
	self.componentAttached = component
end










