Mouse = Component:extend()

function Mouse:new()
	self.x = love.mouse:getX()
	self.y = love.mouse.getY()
	self.id = "mouse"
	self.spriteAttached = nil
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
	if event.name == "MouseTile" then
		self:attachSprite(event.sprite)
	elseif event.name == "DragAddTile" and self.spriteAttached then
		self:place()
	end
end

function Mouse:attachSprite(sprite)
	print("Mouse:attachSprite. id " .. sprite.id .. " pos " .. sprite.pos.x .. " " .. sprite.pos.y)
	self.spriteAttached = sprite
	self.spriteAttached:load()
end

function Mouse:place()
	local currentPos = Vec2(love.mouse:getX(), love.mouse:getY())
	self.spriteAttached.pos = currentPos
	print("Mouse:place. " .. "id " .. self.spriteAttached.id .. " pos " .. self.spriteAttached.pos.x .. " " .. self.spriteAttached.pos.y)
	self.super.bus:event(PlaceTile(self.spriteAttached))
end

function Mouse:getSpriteAttached()
	return self.spriteAttached
end

function Mouse:mousemoved(x, y)
	
end

-- 1 = LMB
-- 2 = RMB
function Mouse:mousepressed(x, y, button)
	local util = Util()
	local pos = Vec2(x, y)
	local gridCoord = util:getGameCoordAt(pos)
	local gameCoord = Vec2(math.floor(gridCoord.x), math.floor(gridCoord.y))

	if button == 1 then
		self.drag = {isDrag = true, dragMode = "add", pos = gameCoord}
		if self.spriteAttached then
			self:place()
		end
	elseif button == 2 then
		self.drag = {isDrag = true, dragMode = "remove", pos = gameCoord}
		self.spriteAttached = nil
	end
end

function Mouse:mousereleased(x, y, button)

end










