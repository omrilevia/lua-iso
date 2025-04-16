RemoveTile = Event:extend()

-- Convention is to supply game grid coordinates
function RemoveTile:new(pos)
	self.name = "RemoveTile"
	self.pos = pos
	RemoveTile.super:new(self.name)
end

