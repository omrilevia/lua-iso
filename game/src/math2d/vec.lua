Vec = Object:extend()

function Vec:new(x, y)
	self.x = x
	self.y = y
end

function Vec:dot(vec)
	return self.x * vec.x + self.y * vec.y
end

function Vec:scale(scalar)
	self.x = scalar * self.x
	self.y = scalar * self.y
	return self
end




