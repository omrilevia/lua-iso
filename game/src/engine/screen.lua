Screen = Object:extend()

function Screen:new()
end

function Screen:getGameCoordAt(pos)
	local constants = Constants()
	-- pos is isometric screen cord.
	-- perform inverse transform on pos, and reverse x and y offsets. 
	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local transformed = iso:inverse():transform(Vec2(pos.x - constants.X_OFFSET, pos.y - constants.Y_OFFSET - 
		constants.MAX_TILE_HEIGHT + constants.TILE_HEIGHT))
	return Vec2(transformed.x, transformed.y)
end


