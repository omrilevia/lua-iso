Constants = Object:extend()

function Constants:new()
	self.TILE_WIDTH = 64
	self.TILE_HEIGHT = 32
	self.TILE_ASSET_PATH = "assets/tiles/"
	self.GRID_SIZE = 8
	self.NUM_TILE_TYPES = 34
	self.MAX_TILE_HEIGHT = 32
	self.X_OFFSET = (love.graphics.getWidth() - self.GRID_SIZE * self.TILE_WIDTH)/2
	--self.X_OFFSET = 0
	self.Y_OFFSET = 0
	self.HINTS = true
	self.SCROLL_SCALE_FACTOR = 2^(1/8)
end

