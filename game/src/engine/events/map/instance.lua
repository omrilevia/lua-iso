Instance = Event:extend()

function Instance:new(mapId)
	self.mapId = mapId
	self.super.new(self, "Instance")
end