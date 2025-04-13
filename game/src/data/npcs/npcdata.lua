NPCData = Object:extend()

function NPCData:new()
	self.data = {
		trader = {
			id = "trader",
			speed = 2,
			width = 32,
			height = 64,
			animationData = {
				walkAnimationId = "assets/npcs/trader/wandering_trader1.png",
				idleAnimationId = "assets/npcs/trader/wandering_trader1.png",
				walkDuration = 0.1,
				idleDuration = 0.25,
				width = 32,
				height = 64,
				walkAnimationFrames = "1-6", 
				idleAnimationFrames = "1-6",
				animationDirections = {'se'},
				startDirection = 'se'
			}
		}
	}
end