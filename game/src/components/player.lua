Player = Actor:extend()

function Player:new(playerData)
	Player.super:new(playerData)
end

-- TODO: refactor the animation loading into a common class so that NPC can use it. 
-- parameterize the animation the data by entity id
function Player:load(bus, player)
	Player.super:load(bus, player)
end

function Player:save()
end

function Player:update(dt)
	for i, event in ipairs(self.moveQueue) do
		if event.type == "move" then
			self:move(event.obj.direction, event.obj.target, event.obj.collider, dt)
		end
	end

	Player.super:update(dt)
end

function Player:draw()
	Player.super:draw()
end

function Player:handleEvent(event)
	Player.super:handleEvent(event)
end

function Player:setPosition(pos)
	Player.super:setPosition(pos)
end

function Player:setHitbox(collider, screenPos, tag) 
	Player.super:setHitbox(collider, screenPos, tag)
end

function Player:setFootprint(collider, screenPos, tag)
	Player.super:setFootprint(collider, screenPos, tag)
end

function Player:setMove(move)
	Player.super:setMove(move)
end

-- direction is a unit vector 
function Player:move(direction, target, collider, dt)
	local dx = self.speed * dt * direction.x
	local dy = self.speed * dt * direction.y

	local screenDelta = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT):transform(Vec2(dx, dy))

	local cardinal = util:getCardinal(screenDelta, 0.3)

	if self.currentAnimation.dt > .1 then 
		self.super.currentAnimation = {image = self.walkSheet, animation = self.walkAnimations[cardinal], dt = 0}
	end

	self.super.pos.x = dx + self.pos.x
	self.super.pos.y = dy + self.pos.y
	self.super.hitbox:move(screenDelta.x, screenDelta.y)
	self.super.footprint:move(screenDelta.x, screenDelta.y)

	local collisions = collider:collisions(self.footprint)
	for other, vec in pairs(collisions) do
		
		if other.tag:sub(1, #"exit") == "exit" then
			local _, exit = other.tag:match("(%w+):(%w+)")
			self.bus:event({name = "Instance", mapId = exit})

			self:idle(cardinal)
			return
		elseif other.tag ~= "playerHitbox" then
			self.super.hitbox:move(4 * vec.x,  4 * vec.y)
			self.super.footprint:move(4 * vec.x,  4 * vec.y)

			local currentScreen = util:getScreenCoordAt(self.pos)
			currentScreen.x = currentScreen.x +  4 * vec.x
			currentScreen.y = currentScreen.y + 4 * vec.y

			self.super.pos = util:getGameCoordAt(currentScreen) 

			self:idle(cardinal)
			return
		end
	end

	local distance = Util:getDistance(Vec2(target.x, target.y), self.pos)

	if distance < 0.1 then
		self:idle(cardinal)
		return
	end
end

function Player:idle(cardinal)
	Player.super:idle(cardinal)
end







