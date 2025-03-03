Button = Component:extend()

function Button:new(id, pos, buttonFunction)
	self.action = buttonFunction
	self.id = id
	self.pos = pos
	Button.super:new(id, pos)
end

function Button:load()
end

function Button:update(dt)
end

function Button:draw()
	love.graphics.print("Button: " .. self.id, self.pos.x, self.pos.y)
end

function Button:press()
	print("Button. " .. self.id .. " onAction.")
	return self.action()
end



