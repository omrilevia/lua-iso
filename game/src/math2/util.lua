Util = Object:extend()

function Util:getGameCoordAt(pos, window)
	local constants = Constants()

	local posX = pos.x - constants.X_OFFSET
	local posY = pos.y - constants.Y_OFFSET - constants.MAX_TILE_HEIGHT + constants.TILE_HEIGHT
	pos = Vec2(posX, posY)

	if window then
		posX = math.floor((posX - window.translate.x) / window.scale + 0.5)
		posY = math.floor((posY - window.translate.y) / window.scale + 0.5)
		pos = Vec2(posX, posY)
	end

	-- pos is cartesian screen cord.
	-- perform inverse transform on pos, and reverse x and y offsets. 
	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local transformed = iso:inverse():transform(pos)
	
	return transformed
end

function Util:getGridCoordAt(pos, window)
	local gameCoord = self:getGameCoordAt(pos, window)

	return Vec2(math.floor(gameCoord.x), math.floor(gameCoord.y))
end
