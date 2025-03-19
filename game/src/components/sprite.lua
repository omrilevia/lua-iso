Sprite = Component:extend()

function Sprite:new(texId, pos, drawable)
	self.id = texId
	self.pos = pos
	self.drawable = drawable
	Sprite.super:new(texId, pos)
end

function Sprite:load()
	self.drawable = love.graphics.newImage(self.id)

	if self.id == "assets/tiles/tile-8.png" then
		self.index = 1
	else
		self.index = 0
	end
end

function Sprite:update(dt)
end

function Sprite:draw(highlight)
	local constants = Constants()
	-- transform the tile's position to an isometric screen coord
	local zOffset = constants.MAX_TILE_HEIGHT - constants.TILE_HEIGHT
	local yOffset = constants.Y_OFFSET
	local xOffset = constants.X_OFFSET + constants.GRID_SIZE * constants.TILE_WIDTH / 2

	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local vecIso = iso:transform(self.pos)
	assert(iso:inverse():transform(vecIso).x == self.pos.x)
	assert(iso:inverse():transform(vecIso).y == self.pos.y)

	-- in tiled the center of the base is drawn at pos
	-- translate right corner to center base
	xOffset = xOffset - constants.TILE_WIDTH/2
	yOffset = yOffset - constants.TILE_HEIGHT

	-- scoot the image to the left by TILE_WIDTH/2, so that the center of the image lies on the origin. 
	love.graphics.draw(self.drawable.image, self.drawable.quad, xOffset + vecIso.x, yOffset + vecIso.y + zOffset)
end

function Sprite:highlight()
	--self:draw(true)
end





