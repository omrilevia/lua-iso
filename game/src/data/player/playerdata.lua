PlayerData = Object:extend()

function PlayerData:new()
	self.id = "player"
	self.speed = 2
	self.width = 32
	self.height = 32
	self.animationData = {
		walkAnimationId = "assets/player/player_walk.png",
		idleAnimationId = "assets/player/player_idle.png", 
		walkDuration = 0.1,
		idleDuration = 0.1,
		width = 32,
		height = 32,
		walkAnimationFrames = "1-8",
		idleAnimationFrames = "1-12",
		animationDirections = {'n', 'nw', 'w', 'sw', 's', 'se', 'e', 'ne'},
		startDirection = 's'
	}
end