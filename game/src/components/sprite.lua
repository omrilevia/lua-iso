Sprite = Object:extend()

function Sprite:new(width, height)
	local constants = Constants()
    self.texCoords = {{0, 0}, {1, 1}, {0, 1}, {1, 0}}
    self.width = width
    self.height = height
	self.image = love.graphics.newImage(constants.TILE_ASSET_PATH .. "water.png")
end


