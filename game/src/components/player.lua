Player = Component:extend()

function Player:new(id, pos)
	self.id = id
	-- grid coordinate, (1,1) for example
	self.pos = pos
	self.sortPos = pos
	-- tiles per second
	self.speed = 2
	self.moveQueue = {}
	self.index = 1
	self.isPlayer = true
	self.walkAnimations = {}
	self.idleAnimations = {}

	Player.super:new(id, pos)
end

function Player:load(bus, player)
	local anim8 = require 'lib.anim8'

	self.walkSheet = love.graphics.newImage('assets/player/player_walk.png')
	self.idleSheet = love.graphics.newImage('assets/player/player_idle.png')
	local gWalk = anim8.newGrid(32, 32, self.walkSheet:getWidth(), self.walkSheet:getHeight(), 0, 0, 0)
	local gIdle = anim8.newGrid(32, 32, self.idleSheet:getWidth(), self.idleSheet:getHeight(), 0, 0, 0)
	
	local directions = {'n', 'nw', 'w', 'sw', 's', 'se', 'e', 'ne'}
	for i = 1, 8 do 
		local direction = directions[i] 

		local walkFrames = gWalk('1-8', i)
		self.walkAnimations[direction] = anim8.newAnimation(walkFrames, 0.1)

		local idleFrames = gIdle('1-12', i)
		self.idleAnimations[direction] = anim8.newAnimation(idleFrames, 0.1)
	end

	self.image = love.graphics.newImage(self.id)
	self.currentAnimation = {image = self.idleSheet, animation = self.idleAnimations['w'], dt = 0}
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

	self.sortPos = Vec2(self.pos.x, self.pos.y)

	self.currentAnimation.animation:update(dt)
	self.currentAnimation.dt  = self.currentAnimation.dt + dt
end

function Player:draw()
	local vecIso = util:getRectangleScreenPos(self.pos, self.image:getWidth(), self.image:getHeight())

	self.currentAnimation.animation:draw(self.currentAnimation.image, vecIso.x, vecIso.y)
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

-- direction is a unit vector 
function Player:move(direction, target, collider, dt)
	local dx = self.speed * dt * direction.x
	local dy = self.speed * dt * direction.y

	local screenDelta = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT):transform(Vec2(dx, dy))

	local cardinal = util:getCardinal(screenDelta, 0.3)

	if self.currentAnimation.dt > .1 then 
		self.currentAnimation = {image = self.walkSheet, animation = self.walkAnimations[cardinal], dt = 0}
	end

	self.pos.x = dx + self.pos.x
	self.pos.y = dy + self.pos.y
	self.hitbox:move(screenDelta.x, screenDelta.y)

	local collisions = collider:collisions(self.hitbox)
	for other, vec in pairs(collisions) do
    	self.hitbox:move(4 * vec.x,  4 * vec.y)

		local currentScreen = util:getScreenCoordAt(self.pos)
		currentScreen.x = currentScreen.x +  4 * vec.x
		currentScreen.y = currentScreen.y + 4 * vec.y

		self.pos = util:getGameCoordAt(currentScreen) 

		self.moveQueue = {}
		self.currentAnimation = {image = self.idleSheet, animation = self.idleAnimations[cardinal], dt = 0}
		return
	end

	local distance = Util:getDistance(Vec2(target.x, target.y), self.pos)

	if distance < 0.1 then
		self.moveQueue = {}
		self.currentAnimation = {image = self.idleSheet, animation = self.idleAnimations[cardinal], dt = 0}
		return
	end
end





