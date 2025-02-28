Event = Object:extend()

function Event:new(name, payload)
	self.name = name
	self.payload = payload
end

