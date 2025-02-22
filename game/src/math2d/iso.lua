Iso = Mat2d:extend()

function Iso:new(tileWidth, tileHeight)
	Iso.super:new(Vec(1/2, -1/2):scale(tileWidth), Vec(1/2, 1/2):scale(tileHeight))
end

function Iso:transform(vec)
	return Iso.super:transform(vec)
end

function Iso:scale(scalar)
	return Iso.super:scale(scalar)
end
