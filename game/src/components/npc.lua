NPC = Actor:extend()

function NPC:new(npcdata)
	NPC.super.new(self, npcdata)
end

function NPC:setDialogArea(area)
	self.dialogArea = area
end

function NPC:draw()
	NPC.super.draw(self)

	love.graphics.polygon("line", unpack(self.dialogArea.getScreenPoly()))
end
