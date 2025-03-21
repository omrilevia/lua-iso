Level = SystemMan:extend()

function Level:new()
	Level.super.new({ Scene(), Mouse() })
end
