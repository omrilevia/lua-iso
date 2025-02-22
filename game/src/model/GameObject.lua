GameObject = Object:extend()

function GameObject:new(texId, pos)
	self.texId = texId
	-- Pos always in cartesian.
	self.pos = pos
end

function GameObject:load()
end

function GameObject:update(dt)
end

function GameObject:draw()
end

