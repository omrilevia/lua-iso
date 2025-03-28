Player = Component:extend()

function Player:new(id, pos)
	self.id = id
	-- grid coordinate, (1,1) for example
	self.pos = pos
	self.sortPos = pos
	-- tiles per second
	self.speed = 3
	self.moveQueue = {}
	self.index = 1
	self.isPlayer = true
	Player.super:new(id, pos)
end

function Player:load(bus, player)
	self.image = love.graphics.newImage(self.id)
	self.bus = bus
end

function Player:save()
end

function Player:update(dt)
	Player.super:update(dt)

	for i, event in ipairs(self.moveQueue) do
		if event.type == "move" then
			self:move(event.obj.direction, event.obj.target, event.obj.collider, dt)
		end
	end

	self.sortPos = Vec2(math.floor(self.pos.x), math.floor(self.pos.y))
end

function Player:draw()
	local vecIso = Util():getRectangleScreenPos(self.pos, self.image:getWidth(), self.image:getHeight())

	love.graphics.draw(self.image, vecIso.x, vecIso.y)
	local x1,y1, x2,y2 = self.hitbox:bbox()
	love.graphics.rectangle('line', x1, y1, x2 - x1, y2 - y1)

end

function Player:handleEvent(event)
	Player.super:handleEvent(event)
end

-- 1 = LMB
-- 2 = RMB
function Player:mousepressed(x, y, button)
	
end

function Player:isScalable()
	return true
end

function Player:move(direction, target, collider, dt)
	local dx = self.speed * dt * direction.x
	local dy = self.speed * dt * direction.y

	local screenDelta = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT):transform(Vec2(dx, dy))

	self.pos.x = dx + self.pos.x
	self.pos.y = dy + self.pos.y
	self.hitbox:move(screenDelta.x, screenDelta.y)

	local collisions = collider:collisions(self.hitbox)
	for other, vec in pairs(collisions) do
    	self.hitbox:move(vec.x,  vec.y)

		local currentScreen = util:getScreenCoordAt(self.pos)
		currentScreen.x = currentScreen.x + vec.x
		currentScreen.y = currentScreen.y + vec.y

		self.pos = util:getGameCoordAt(currentScreen) 

		self.moveQueue = {}
		return
	end

	local distance = Util:getDistance(Vec2(target.x, target.y), self.pos)

	if distance < 0.1 then
		self.moveQueue = {}
		return
	end

end



