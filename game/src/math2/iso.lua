Iso = Mat2:extend()

function Iso:new(tileWidth, tileHeight)
	Iso.super:new(Vec2(1/2, -1/2):scale(tileWidth), Vec2(1/2, 1/2):scale(tileHeight))
end

function Iso:transform(vec)
	return Iso.super:transform(vec)
end

function Iso:scale(scalar)
	return Iso.super:scale(scalar)
end

function Iso:inverse()
	return Iso.super:inverse()
end

