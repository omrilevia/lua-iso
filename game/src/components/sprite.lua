Sprite = Component:extend()

function Sprite:new(texId, pos, drawable)
	self.id = texId
	self.pos = pos
	self.drawable = drawable
	Sprite.super:new(texId, pos)
end

function Sprite:load()
	--self.drawable = love.graphics.newImage(self.id)
end

function Sprite:update(dt)
end

function Sprite:draw(highlight)
	local constants = Constants()
	-- transform the tile's position to an isometric screen coord
	local zOffset = constants.MAX_TILE_HEIGHT - constants.TILE_HEIGHT
	local yOffset = constants.Y_OFFSET - constants.TILE_HEIGHT
	local xOffset = constants.GRID_SIZE * constants.TILE_WIDTH / 2

	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local vecIso = iso:transform(self.pos)
	assert(iso:inverse():transform(vecIso).x == self.pos.x)
	assert(iso:inverse():transform(vecIso).y == self.pos.y)

	-- in tiled the center of the top is drawn at pos
	-- translate right corner to center base
	xOffset = xOffset - constants.TILE_WIDTH/2

	love.graphics.draw(self.drawable.image, self.drawable.quad, xOffset + vecIso.x, yOffset + vecIso.y + zOffset)
end

function Sprite:highlight()
	--self:draw(true)
end





