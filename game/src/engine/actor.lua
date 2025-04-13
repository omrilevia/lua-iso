Actor = Component:extend()

function Actor:new(data)
	self.id = data.id
	
	-- tiles per second
	self.speed = data.speed

	-- animation ids
	self.walkAnimationId = data.walkAnimationId
	self.idleAnimationId = data.idleAnimationId

	-- frame dimensions 
	self.width = data.width 
	self.height = data.height 

	-- animation frame counts
	self.walkAnimationFrames = data.walkAnimationFrames
	self.idleAnimationFrames = data.idleAnimationFrames

	-- collision data 
	self.footprint = {}
	self.hitbox = {}

	self.walkAnimations = {}
	self.idleAnimations = {}
	self.currentAnimation = {}

	self.loaded = false

	self.moveQueue = {}
end

function Actor:load(bus, actor)
	if self.loaded then return end

	local anim8 = require 'lib.anim8'

	self.walkSheet = love.graphics.newImage(self.walkAnimationId)
	self.idleSheet = love.graphics.newImage(self.idleAnimationId)
	local gWalk = anim8.newGrid(self.width, self.height, self.walkSheet:getWidth(), self.walkSheet:getHeight(), 0, 0, 0)
	local gIdle = anim8.newGrid(self.width, self.height, self.idleSheet:getWidth(), self.idleSheet:getHeight(), 0, 0, 0)
	
	local directions = {'n', 'nw', 'w', 'sw', 's', 'se', 'e', 'ne'}
	for i = 1, 8 do 
		local direction = directions[i] 

		local walkFrames = gWalk(self.walkAnimationFrames, i)
		self.walkAnimations[direction] = anim8.newAnimation(walkFrames, 0.1)

		local idleFrames = gIdle(self.idleAnimationFrames, i)
		self.idleAnimations[direction] = anim8.newAnimation(idleFrames, 0.1)
	end

	self.currentAnimation = {image = self.idleSheet, animation = self.idleAnimations['w'], dt = 0}
	self.bus = bus
	self.loaded = true
end

function Actor:draw()
	local vecIso = util:getRectangleScreenPos(self.pos, self.width, self.height)

	self.currentAnimation.animation:draw(self.currentAnimation.image, vecIso.x, vecIso.y)

	local x1,y1, x2,y2 = self.hitbox:bbox()
	local x3, y3, x4, y4 = self.footprint:bbox()
	love.graphics.rectangle('line', x1, y1, x2 - x1, y2 - y1)
	love.graphics.rectangle('line', x3, y3, x4 - x3, y4 - y3)
end

function Actor:update(dt)
	self.sortPos = Vec2(self.pos.x, self.pos.y)
	self.currentAnimation.animation:update(dt)
	self.currentAnimation.dt  = self.currentAnimation.dt + dt
end

function Actor:setPosition(pos)
	self.pos = pos
	self.sortPos = pos
end

function Actor:setHitbox(collider, screenPos, tag) 
	self.hitbox = collider:rectangle(screenPos.x + self.width/4, screenPos.y, 
		self.width/2, self.height)
	self.hitbox.tag = tag
end

function Actor:setFootprint(collider, screenPos, tag)
	self.footprint = collider:rectangle(screenPos.x + self.width/4, screenPos.y + 3/4 * self.height, 
	self.width/2, self.height * 1/4)
	self.footprint.tag = tag
end

function Actor:setMove(move)
	self.moveQueue = {}
	table.insert(self.moveQueue, move)
end

function Actor:move(direction, target, collider, dt)
end

function Actor:idle(cardinal)
	self.moveQueue = {}
	self.currentAnimation = {image = self.idleSheet, animation = self.idleAnimations[cardinal], dt = 0}
end