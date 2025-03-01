PlaceTile = Event:extend()

function PlaceTile:new(sprite)
	self.sprite = sprite
	self.name = "PlaceTile"
	PlaceTile.super:new(self.name)
end
