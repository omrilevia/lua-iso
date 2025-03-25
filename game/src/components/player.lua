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
			self:move(event.obj.direction, event.obj.target, event.obj.world, dt, i)
		end
	end

	self.sortPos = Vec2(math.floor(self.pos.x), math.floor(self.pos.y))
end

function Player:draw()
	local constants = Constants()
	-- transform the tile's position to an isometric screen coord
	local xOffset = constants.GRID_SIZE * constants.TILE_WIDTH / 2 - self.image:getWidth()/2
	local yOffset = constants.Y_OFFSET - self.image:getHeight()
	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local vecIso = iso:transform(self.pos)

	local pos = Util():getGameCoordAt(Vec2(love.mouse:getX(), love.mouse:getY()), self.super.window)
	
	local screen = Util():getScreenCoordAt(pos)
	screen.x = screen.x + xOffset
	screen.y = screen.y + yOffset

	love.graphics.print("Screen: " .. screen.x .. " " .. screen.y, 0, 100)
	love.graphics.print("Mouse: " .. pos.x .. " " .. pos.y)

	love.graphics.draw(self.image, vecIso.x + xOffset, vecIso.y + yOffset)
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
	
end

function Player:isScalable()
	return true
end

function Player:move(direction, target, world, dt)
	local testX = (self.speed * dt * direction.x + self.pos.x) 
	local testY = (self.speed * dt * direction.y + self.pos.y) 

	--[[ local screenPos = Util():getScreenCoordAt(Vec2(testX, testY))
	screenPos.x = screenPos.x + constants.GRID_SIZE * constants.TILE_WIDTH / 2 - self.image:getWidth()/2
	screenPos.y = screenPos.y + constants.Y_OFFSET - self.image:getHeight()


	print("testx, testy: " .. testX .. " " .. testY)
	print("ScreenPos: " .. screenPos.x .. " " .. screenPos.y)

	local x, y, cols, len = world:move(self, screenPos.x, screenPos.y)

	if len > 0 then
		x = x + self.image:getWidth()/2
		y = y + self.image:getHeight()
		local gridCoord = Util():getGameCoordAt(Vec2(x, y), self.super.window)
		self.pos.x = gridCoord.x
		self.pos.y = gridCoord.y
		self.moveQueue = {}
		return
	else
		self.pos.x = testX
		self.pos.y = testY
	end ]]

	self.pos.x = testX
	self.pos.y = testY

	local distance = Util:getDistance(Vec2(target.x, target.y), self.pos)

	if distance < 0.1 then
		self.moveQueue = {}
		return
	end

end



