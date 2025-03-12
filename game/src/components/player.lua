Player = Component:extend()

function Player:new(id, pos)
	self.id = id
	-- grid coordinate, (1,1) for example
	self.pos = pos
	self.drawPos = pos
	-- tiles per second
	self.speed = 10
	self.moveQueue = {}
	self.index = 0
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
			self:move(event.obj.direction, event.obj.target, dt, i)
		end
	end
end

function Player:draw()
	local constants = Constants()
	-- transform the tile's position to an isometric screen coord
	local zOffset = constants.TILE_HEIGHT + self.image:getHeight()

	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local vecIso = iso:transform(self.pos)

	love.graphics.draw(self.image, constants.X_OFFSET + vecIso.x - self.image:getWidth()/2, constants.Y_OFFSET + vecIso.y + zOffset)
end

function Player:getDrawables()
	return { {drawable = self, component = "player"} }
end

function Player:handleEvent(event)
	Player.super:handleEvent(event)


end

-- 1 = LMB
-- 2 = RMB
function Player:mousepressed(x, y, button)
	if (button == 1) then
		self.moveQueue = {}
		local gameCoordMouse = Util():getGameCoordAt(Vec2(x, y), self.super.window)
		local cos, sin = Util():getUnitVectorPlayerToMouse(gameCoordMouse, self.pos)
		
		table.insert(self.moveQueue, {type = "move", obj = {direction = Vec2(cos, sin), target = gameCoordMouse}})
	end
end

function Player:isScalable()
	return true
end

function Player:move(direction, target, dt, eventIndex)
	--self.pos.x = self.speed * dt * direction.x + self.pos.x
	--self.pos.y = self.speed * dt * direction.y + self.pos.y
	self.pos.x = math.floor(target.x)
	self.pos.y = math.floor(target.y)

	if Util:getDistance(Vec2(math.floor(target.x), math.floor(target.y)), self.pos) < 0.1 then
		table.remove(self.moveQueue, eventIndex)
		return
	end
end



