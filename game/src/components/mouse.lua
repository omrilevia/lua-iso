Mouse = Component:extend()

function Mouse:new()
	self.x = love.mouse:getX()
	self.y = love.mouse.getY()
	self.id = "mouse"
	Mouse.super:new("mouse", Vec2(self.x, self.y))
end

function Mouse:load(bus)
	Mouse.super:new(bus)
end

function Mouse:update(dt)
	self.x = love.mouse:getX()
	self.y = love.mouse:getY()
end

function Mouse:draw()
	local constants = Constants()
	if self.spriteAttached then
		love.graphics.draw(self.spriteAttached.image, self.x - constants.TILE_WIDTH/2, self.y - constants.TILE_WIDTH/2)
	end
end

function Mouse:getPos()
	return Vec2(self.x, self.y)
end

function Mouse:handleEvent(event)
	if event.name == "mouse" then
		self:attachSprite(event.payload)
	end
end

function Mouse:attachSprite(sprite)
	print("Mouse:attachSprite. id " .. sprite.id .. " pos " .. sprite.pos.x .. " " .. sprite.pos.y)
	self.spriteAttached = sprite
end

function Mouse:place()
	local currentPos = Vec2(love.mouse:getX(), love.mouse:getY())
	self.spriteAttached.pos = currentPos
	print("Mouse:place. " .. "id " .. self.spriteAttached.id .. " pos " .. self.spriteAttached.pos.x .. " " .. self.spriteAttached.pos.y)
	self.super.bus:event(Event("placeTile", Sprite(self.spriteAttached.id, self.spriteAttached.pos, self.spriteAttached.img)))
	self.spriteAttached = nil
end

function Mouse:getSpriteAttached()
	return self.spriteAttached
end

function Mouse:mousepressed(x, y, button)
	if self:getSpriteAttached() then
		self:place()
	end
end










