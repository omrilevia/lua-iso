EnterDialogArea = Event:extend()

-- set npc to nil if exiting dialogue area.
function EnterDialogArea:new(npc)
	self.npc = npc
	EnterDialogArea.super.new(self, "EnterDialogueArea")
end