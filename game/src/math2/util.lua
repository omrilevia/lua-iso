Util = Object:extend()

function Util:getGameCoordAt(pos, window)
	local constants = Constants()

	if window then
		pos.x = math.floor((pos.x - window.translate.x) / window.scale + 0.5)
		pos.y = math.floor((pos.y - window.translate.y) / window.scale + 0.5)
	end

	pos.x = pos.x - constants.X_OFFSET
	pos.y = pos.y - constants.Y_OFFSET - constants.MAX_TILE_HEIGHT + constants.TILE_HEIGHT

	-- pos is isometric screen cord.
	-- perform inverse transform on pos, and reverse x and y offsets. 
	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local transformed = iso:inverse():transform(pos)
	
	return transformed
end

function Util:getGridCoordAt(pos, window)
	local gameCoord = self:getGameCoordAt(pos, window)

	return Vec2(math.floor(gameCoord.x), math.floor(gameCoord.y))
end

function Util:getUnitVectorPlayerToMouse(mousePos, objPos)
	local angle = math.atan2(mousePos.y - objPos.y, mousePos.x - objPos.x)
  
  	return math.cos(angle), math.sin(angle)
end

function Util:getDistance(vec1, vec2) 
	return math.sqrt((vec2.y - vec1.y)^2 + (vec2.x - vec1.x)^2)
end


