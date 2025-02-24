Component = Object:extend()

function Component:new(id, pos)
	self.id = id
	-- Pos always in cartesian.
	self.pos = pos
end

function Component:load()
end

function Component:update(dt)
end

function Component:draw()
end

function Component:getGameCoord()
	local constants = Constants()
	-- pos is isometric screen cord.
	-- perform inverse transform on pos, and reverse x and y offsets. 
	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local transformed = iso:inverse():transform(Vec2(self.pos.x - constants.X_OFFSET, self.pos.y - constants.Y_OFFSET - 
		constants.MAX_TILE_HEIGHT + constants.TILE_HEIGHT))
	return Vec2(transformed.x, transformed.y)
end



