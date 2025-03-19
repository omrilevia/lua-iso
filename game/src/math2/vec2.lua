Vec2 = Object:extend()

function Vec2:new(x, y)
	self.x = x
	self.y = y
end

function Vec2:fromKey(key)
	local x, y = key:match("(%d+),(%d+)")
	return Vec2(tonumber(x), tonumber(y))
end

function Vec2:dot(vec)
	return self.x * vec.x + self.y * vec.y
end

function Vec2:scale(scalar)
	self.x = scalar * self.x
	self.y = scalar * self.y
	return self
end

function Vec2:key()
	return self.x .. "," .. self.y
end





