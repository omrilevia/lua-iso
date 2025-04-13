PlayerData = Object:extend()

function PlayerData:new()
	self.id = "player"
	self.speed = 2
	self.walkAnimationId = "assets/player/player_walk.png"
	self.idleAnimationId = "assets/player/player_idle.png" 
	self.width = 32
	self.height = 32
	self.walkAnimationFrames = "1-8" 
	self.idleAnimationFrames = "1-12" 
	
end