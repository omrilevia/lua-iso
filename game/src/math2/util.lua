Util = Object:extend()

-- pos is isometric screen cord.
-- perform inverse transform on pos, and reverse x and y offsets. 
function Util:getGameCoordAt(pos, window)
	local constants = Constants()

	local vec = Vec2(pos.x, pos.y)


	if window then
		vec.x = math.floor((vec.x - window.translate.x) / window.scale + 0.5)
		vec.y = math.floor((vec.y - window.translate.y) / window.scale + 0.5)
	end

	--local offsetX = mapH * tileW / 2
	vec.x = vec.x - constants.GRID_SIZE * constants.TILE_WIDTH/2
	vec.y = vec.y

	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local transformed = iso:inverse():transform(vec)
	
	return transformed
end

function Util:getGridCoordAt(pos, window)
	local gameCoord = self:getGameCoordAt(pos, window)

	return Vec2(math.floor(gameCoord.x), math.floor(gameCoord.y))
end

-- Pos is a gameCoord example: (1.2, 2.2)
function Util:getScreenCoordAt(pos)
	local screenPos = Vec2(pos.x, pos.y)
	
	local constants = Constants()
	local transformed = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT):transform(screenPos)

	transformed.x = transformed.x + constants.ORIGIN
	transformed.y = transformed.y

	return transformed
end

function Util:getRectangleScreenPos(pos, w, h)
	local sc = self:getScreenCoordAt(pos)

	local xOffset = - w / 2
	local yOffset = - h

	return sc:add(Vec2(xOffset, yOffset))
end

function Util:getUnitVectorObjToMouse(mousePos, objPos)
	local angle = math.atan2(mousePos.y - objPos.y, mousePos.x - objPos.x)
  
  	return math.cos(angle), math.sin(angle)
end

function Util:getDistance(vec1, vec2) 
	return math.sqrt((vec2.y - vec1.y)^2 + (vec2.x - vec1.x)^2)
end

-- returns one of [n, w, e, s, ne, se, nw, sw]
-- vec is unit vector (cos, sin)
function Util:getCardinal(vec, tolerance)
	local t = tolerance or 0

	local direction = ''

	if vec.y < -t then 
		direction = direction .. 'n'
	elseif vec.y > t then
		direction = direction .. 's'
	end

	if vec.x > t then 
		direction = direction .. 'e'
	elseif vec.x < -t then
		direction = direction .. 'w'
	end

	if direction == '' then 
		return self:getCardinal(vec, 0) 
	end

	return direction
end


