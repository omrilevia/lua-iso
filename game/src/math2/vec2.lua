Vec2 = Object:extend()

function Vec2:new(x, y)
	self.x = x
	self.y = y
end

function Vec2:dot(vec)
	return self.x * vec.x + self.y * vec.y
end

function Vec2:scale(scalar)
	self.x = scalar * self.x
	self.y = scalar * self.y
	return self
end




