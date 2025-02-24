Level = Scene:extend()

function Level:new()
	Level.super.new({ Grid(), Mouse() })
end
