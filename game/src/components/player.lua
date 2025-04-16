Player = Actor:extend()

function Player:new(playerData)
	Player.super.new(self, playerData)
end

-- TODO: refactor the animation loading into a common class so that NPC can use it. 
-- parameterize the animation the data by entity id
function Player:load(bus, player)
	self.dialogArea = nil

	Player.super.load(self, bus, player)
end

function Player:save()
end

function Player:update(dt)
	Player.super.update(self, dt)
end

function Player:draw()
	Player.super.draw(self)
end

function Player:handleEvent(event)
	Player.super.handleEvent(self, event)
end

function Player:setPosition(pos)
	Player.super.setPosition(self, pos)
end

function Player:setHitbox(collider, screenPos, tag) 
	Player.super.setHitbox(self, collider, screenPos, tag)
end

function Player:setFootprint(collider, screenPos, tag)
	Player.super.setFootprint(self, collider, screenPos, tag)
end

function Player:setMove(move)
	Player.super.setMove(self, move)
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
	self.footprint:move(screenDelta.x, screenDelta.y)

	local collisions = collider:collisions(self.footprint)
	
	if self:resolveCollision(collisions, cardinal) then 
		return 
	end

	local distance = Util:getDistance(Vec2(target.x, target.y), self.pos)

	if distance < 0.1 then
		self:idle(cardinal)
		return
	end
end

function Player:resolveCollision(collisions, cardinal)
	
	local dialogCollided = false 

	for other, vec in pairs(collisions) do
		
		-- Check entering or exiting another area.
		-- Check entering a dialog area. 
		-- Finally check collision with an object or npc's footprint. Ignore our own hitbox. 
		if other.tag:sub(1, #"exit") == "exit" then
			local _, exit = other.tag:match("(%w+):(%w+)")
			self.bus:event(Instance(exit))

			self:idle(cardinal)
			return true
		elseif other.tag:sub(1, #"dialog") == "dialog" then
			local _, npc = other.tag:match("(%w+):(%w+)")
			self:setInDialogArea(npc)
			dialogCollided = true
		elseif other.tag ~= "playerHitbox" or other.tag:sub(-#"footprint") == "footprint" then
			self.hitbox:move(4 * vec.x,  4 * vec.y)
			self.footprint:move(4 * vec.x,  4 * vec.y)

			local currentScreen = util:getScreenCoordAt(self.pos)
			currentScreen.x = currentScreen.x +  4 * vec.x
			currentScreen.y = currentScreen.y + 4 * vec.y

			self.pos = util:getGameCoordAt(currentScreen) 

			self:idle(cardinal)
			return true
		end
	end

	if self:isInDialogArea() and not dialogCollided then self:leaveDialogArea() end 

	return false
end

function Player:idle(cardinal)
	Player.super.idle(self, cardinal)
end

function Player:isInDialogArea() 
	return self.dialogArea ~= nil
end

function Player:setInDialogArea(npcDialog) 
	if self.dialogArea and self.dialogArea.npc == npcDialog then return end

	self.bus:event(EnterDialogArea(npcDialog))
	self.dialogArea = {npc = npcDialog}
end

function Player:leaveDialogArea()
	self.bus:event(LeaveDialogArea())
	self.dialogArea = nil
end







