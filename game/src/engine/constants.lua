Constants = Object:extend()

function Constants:new()
	self.TILE_WIDTH = 64
	self.TILE_HEIGHT = 32
	self.TILE_ASSET_PATH = "assets/tiles/"
	self.GRID_SIZE = 8
	self.NUM_TILE_TYPES = 34
	self.MAX_TILE_HEIGHT = 32
	self.X_OFFSET = 64
	self.Y_OFFSET = 64
	self.SCALE_FACTOR = 2
	self.HINTS = true
	self.SCROLL_SCALE_FACTOR = 2^(1/12)
end

