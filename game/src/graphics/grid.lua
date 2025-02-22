Grid = Object:extend()

function Grid:new()
	self.grid = {}
end

function Grid:load(grid)
	local constants = Constants()
	if not grid then
		local numberGen = love.math.newRandomGenerator(os.time())
		for i = 1, constants.GRID_SIZE do
			local row = {}
			for j = 1, constants.GRID_SIZE do
				local randomTex = numberGen:random(1, constants.NUM_TILE_TYPES)
				local tile = Tile(randomTex, Vec(i, j))
				tile:load()
				table.insert(row, j, tile)
			end

		table.insert(self.grid, i, row)
		end
	else 
		self.grid = grid
	end 
end

function Grid:draw(dt)
	for i, row in ipairs(self.grid) do
		for j, tile in ipairs(row) do
			tile:draw(dt)
		end
	end
end

