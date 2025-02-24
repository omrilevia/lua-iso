Mat2 = Object:extend()

function Mat2:new(vec1, vec2)
	self.vec1 = vec1
	self.vec2 = vec2
end

function Mat2:transform(vec)
	local xPrime = self.vec1:dot(vec)
	local yPrime = self.vec2:dot(vec)

	return Vec2(xPrime, yPrime)
end

function Mat2:scale(scalar)
	self.vec1 = self.vec1:scale(scalar)
	self.vec2 = self.vec2:scale(scalar)
	return self
end

function Mat2:inverse()
	--[[d    -b]]
	--[[-c    a]] 
	return Mat2(Vec2(self.vec2.y, -self.vec1.y), Vec2(-self.vec2.x, self.vec1.x))
		:scale(1 / ((self.vec1.x * self.vec2.y) - (self.vec1.y * self.vec2.x)))
end

