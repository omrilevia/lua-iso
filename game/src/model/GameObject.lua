GameObject = Object:extend()

function GameObject:new(texId, pos)
	self.texId = texId
	-- Pos always in cartesian.
	self.pos = pos
	self.isDirty = true
end

function GameObject:load()
end

function GameObject:update(dt)
end

function GameObject:draw()
end

function GameObject:setDirty(isDirty)
	self.isDirty = isDirty
end

function GameObject:isDirty()
	return self.isDirty
end



