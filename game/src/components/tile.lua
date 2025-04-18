Tile = Component:extend()

function Tile:new(texId, pos, drawable)
	self.id = texId
	self.pos = pos
	self.drawable = drawable
	Tile.super:new(texId, pos)
end

function Tile:load()
	--self.drawable = love.graphics.newImage(self.id)
end

function Tile:update(dt)
end

-- In tiled the position of image is centered around the middle of the base
-- Have draw the image with reference to its left corner (-width/2, -tileheight)
function Tile:draw(highlight)
	-- transform the tile's position to an isometric screen coord
	local zOffset = constants.MAX_TILE_HEIGHT - constants.TILE_HEIGHT
	local yOffset = - constants.TILE_HEIGHT
	local xOffset = - constants.TILE_WIDTH / 2

	local vecIso = util:getScreenCoordAt(self.pos)

	love.graphics.draw(self.drawable.image, self.drawable.quad, xOffset + vecIso.x, yOffset + vecIso.y + zOffset)

	-- draw footprint
	love.graphics.polygon("line", unpack(self.footprint.bbox))
end

function Tile:setFootprint(collider, polygon)
	self.sortPos = polygon.gridPos
	self.footprint = {shape = collider:polygon(unpack(polygon.getScreenPoly())), bbox = polygon.getScreenPoly()}
	self.footprint.shape.tag = "footprint"
end

function Tile:highlight()
	--self:draw(true)
end





