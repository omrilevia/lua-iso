Mouse = Component:extend()

function Mouse:new()
	self.x = love.mouse:getX()
	self.y = love.mouse.getY()
	self.id = "mouse"
	Mouse.super:new("mouse", Vec2(self.x, self.y))
end

function Mouse:update(dt)
	self.x = love.mouse:getX()
	self.y = love.mouse:getY()
end

function Mouse:draw()
	if self.spriteAttached then
		love.graphics.draw(self.spriteAttached.image, self.x, self.y)
	end
end

function Mouse:getPos()
	return Vec2(self.x, self.y)
end

function Mouse:attachSprite(sprite)
	print("Mouse:attachSprite. id " .. sprite.id .. " pos " .. sprite.pos.x .. " " .. sprite.pos.y)
	self.spriteAttached = sprite
end

function Mouse:place()
	local currentPos = Vec2(love.mouse:getX(), love.mouse:getY())
	self.spriteAttached.pos = currentPos
	print("Mouse:place. " .. "id " .. self.spriteAttached.id .. " pos " .. self.spriteAttached.pos.x .. " " .. self.spriteAttached.pos.y)
	self.super.scene:getComponent("grid"):addTile(self.spriteAttached)
	self.spriteAttached = nil
end

function Mouse:getSpriteAttached()
	return self.spriteAttached
end










