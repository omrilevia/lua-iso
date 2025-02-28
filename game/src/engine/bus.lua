Bus = Object:extend()

function Bus:new()

end

function Bus:event(event)
	if self.broadcaster then 
		self.broadcaster:event(event)
	end
end

function Bus:setBroadcaster(broadcaster)
	self.broadcaster = broadcaster
end


