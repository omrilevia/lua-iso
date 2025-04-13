Actor = Component:extend()

function Actor:new(data)
	self.id = data.id
	
	-- tiles per second
	self.speed = data.speed

	-- animation data
	self.animationData = data.animationData

	self.width = data.width or self.animationData.width
	self.height = data.height or self.animationData.height

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

	self.walkSheet = love.graphics.newImage(self.animationData.walkAnimationId)
	self.idleSheet = love.graphics.newImage(self.animationData.idleAnimationId)
	local gWalk = anim8.newGrid(self.animationData.width, self.animationData.height, 
		self.walkSheet:getWidth(), self.walkSheet:getHeight(), 0, 0, 0)
	local gIdle = anim8.newGrid(self.animationData.width, self.animationData.height, 
		self.idleSheet:getWidth(), self.idleSheet:getHeight(), 0, 0, 0)
	
	for i = 1, #self.animationData.animationDirections do 
		local direction = self.animationData.animationDirections[i] 

		local walkFrames = gWalk(self.animationData.walkAnimationFrames, i)
		self.walkAnimations[direction] = anim8.newAnimation(walkFrames, self.animationData.walkDuration)

		local idleFrames = gIdle(self.animationData.idleAnimationFrames, i)
		self.idleAnimations[direction] = anim8.newAnimation(idleFrames, self.animationData.idleDuration)
	end

	self.currentAnimation = {image = self.idleSheet, animation = self.idleAnimations[self.animationData.startDirection], dt = 0}
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

function Actor:getWidth()
	return self.width or self.animationData.width
end

function Actor:getHeight()
	return self.height or self.animationData.height
end