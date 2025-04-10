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

-- In tiled the position of image is centered around the middle of the base
-- Have draw the image with reference to its left corner (-width/2, -tileheight)
function Sprite:draw(highlight)
	-- transform the tile's position to an isometric screen coord
	local zOffset = constants.MAX_TILE_HEIGHT - constants.TILE_HEIGHT
	local yOffset = - constants.TILE_HEIGHT
	local xOffset = - constants.TILE_WIDTH / 2

	local vecIso = util:getScreenCoordAt(self.pos)

	love.graphics.draw(self.drawable.image, self.drawable.quad, xOffset + vecIso.x, yOffset + vecIso.y + zOffset)
end

function Sprite:highlight()
	--self:draw(true)
end





