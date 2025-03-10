Tile = Component:extend()

function Tile:new(texId, pos)
	self.id = texId
	self.pos = pos
	Tile.super:new(texId, pos)
end

function Tile:load()
	self.image = love.graphics.newImage(self.id)
end

function Tile:update(dt)
end

function Tile:draw()
	local constants = Constants()
	-- transform the tile's position to an isometric screen coord
	local zOffset = constants.MAX_TILE_HEIGHT - self.image:getHeight()

	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local vecIso = iso:transform(self.pos)
	assert(iso:inverse():transform(vecIso).x == self.pos.x)
	assert(iso:inverse():transform(vecIso).y == self.pos.y)

	-- scoot the image to the left by TILE_WIDTH/2, so that the center of the image lies on the origin. 
	love.graphics.draw(self.image, constants.X_OFFSET + vecIso.x - constants.TILE_WIDTH/2, constants.Y_OFFSET + vecIso.y + zOffset)
end






