MouseTile = Event:extend()

function MouseTile:new(sprite)
	self.sprite = sprite
	self.name = "MouseTile"
	MouseTile.super:new(self.name)
end
