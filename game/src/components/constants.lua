Constants = Object:extend()

function Constants:new()
	self.TILE_WIDTH = 100
	self.TILE_HEIGHT = 50
	self.TILE_ASSET_PATH = "assets/tiles/"
	self.GRID_SIZE = 10
	self.NUM_TILE_TYPES = 34
	self.MAX_TILE_HEIGHT = 150
	self.X_OFFSET = love.graphics.getWidth() / 2
	self.Y_OFFSET = 50
end
