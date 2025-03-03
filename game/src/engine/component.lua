Component = Object:extend()

function Component:new(id, pos)
	self.id = id
	-- Pos always in cartesian game coordinates.
	self.pos = pos
end

function Component:load(bus)
	self.bus = bus
end

function Component:save()
end

function Component:update(dt)
end

function Component:draw()
end

function Component:handleEvent(event)

end

function Component:shutdown()

end

--
-- User inputs
--
function Component:textinput(t)
   
end

function Component:keypressed(key)
  
end

function Component:keyreleased(key)
    
end

function Component:mousemoved(x, y)

end

function Component:mousepressed(x, y, button)

end

function Component:mousereleased(x, y, button)

end

function Component:wheelmoved(x, y)
 
end

function Component:getGameCoord()
	local constants = Constants()
	-- pos is isometric game cord.
	-- perform inverse transform on pos, and reverse x and y offsets. 
	local iso = Iso(constants.TILE_WIDTH, constants.TILE_HEIGHT)
	local transformed = iso:inverse():transform(Vec2(self.pos.x - constants.X_OFFSET, self.pos.y - constants.Y_OFFSET - 
		constants.MAX_TILE_HEIGHT + constants.TILE_HEIGHT))
	return Vec2(transformed.x, transformed.y)
end



