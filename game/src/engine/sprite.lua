Sprite = Component:extend()

function Sprite:new(id, pos, image)
	self.image = image
	self.id = id
	self.pos = pos
	Sprite.super:new(id, pos)
end
