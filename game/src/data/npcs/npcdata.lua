NPCData = Object:extend()

function NPCData:new()
	self.data = {
		trader = {
			id = "trader",
			speed = 2,
			walkAnimationId = "assets/npcs/trader/wandering_trader1.png",
			idleAnimationId = "assets/npcs/trader/wandering_trader1.png",
			width = 32,
			height = 64,
			walkAnimationFrames = "1-8", 
			idleAnimationFrames = "1-12" 
		}
	}
end