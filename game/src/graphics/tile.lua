require "src.model.GameObject"
require "src.math2d.iso"
Tile = GameObject:extend()

function Tile:new(texId, pos)
	--texId 7 is broken
	if texId == 6 then
		texId = texId + 1
	end
	local constants = Constants()
	Tile.super.new(self, texId, pos)
	self.tilePath = constants.TILE_ASSET_PATH .. "tile-" .. texId .. ".png"
end

function Tile:load()
	self.image = love.graphics.newImage(self.tilePath)
end

function Tile:draw()
	local constants = Constants()
	-- transform the tile's position to isometric coords
	local zOffset = constants.MAX_TILE_HEIGHT - self.image:getHeight()

	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local vecIso = iso:transform(self.pos)

	love.graphics.draw(self.image, constants.X_OFFSET + vecIso.x, constants.Y_OFFSET + vecIso.y + zOffset)
end






