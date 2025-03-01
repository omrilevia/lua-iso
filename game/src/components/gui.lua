imgui = require "lib.imgui"
Gui = Component:extend()

local showTestWindow = false
local showAnotherWindow = false
local floatValue = 0;
local sliderFloat = { 0.1, 0.5 }
local clearColor = { 0.2, 0.2, 0.2 }
local comboSelection = 1
local textValue = "text"

function Gui:new(id, pos)
	Gui.super:new(id, pos)
	self.drag = {isDrag = false, dragMode = "add", Vec2(0, 0)}
end

function Gui:load(bus)
	Gui.super:load(bus)

	local constants = Constants()
	self.sprites = {} 

	for i = 1, constants.NUM_TILE_TYPES do
		if i == 6 then
			-- tile is broken
		else 
			table.insert(self.sprites, {id = i, img = love.graphics.newImage(constants.TILE_ASSET_PATH .. "tile-" .. i .. ".png") })
		end
	end

	
end

function Gui:update(dt)
	imgui.NewFrame()
end

function Gui:draw()
    imgui.Begin("Editor")

	local util = Util()
	local gameCoord = util:getGameCoordAt(Vec2(love.mouse:getX(), love.mouse:getY()))
	local gridCoord = Vec2(math.floor(gameCoord.x), math.floor(gameCoord.y))
	local constants = Constants() 

	if constants.HINTS then
		love.graphics.print("Mouse grid coordinate: " .. gridCoord.x .. " " .. gridCoord.y, 0, 25)
		love.graphics.print("L-click to select and place tiles.", 0, 45)
		love.graphics.print("R-click to discard selected or remove tiles from the board.", 0, 65)
	end

    local windowPos = imgui.GetWindowPos()
    local windowSize = imgui.GetWindowSize()
    local itemSpacing = imgui.ImGuiStyleVar_ItemSpacing

    local windowX2 = windowPos + windowSize
    for i, sprite in ipairs(self.sprites) do
        local spriteWidth = sprite.img:getWidth()
        local spriteHeight = sprite.img:getHeight()

        imgui.PushID(i)

        -- Using imageButton for sprite display
        if imgui.ImageButton(sprite.img, spriteWidth, spriteHeight) then
			local mouseX = love.mouse:getX()
			local mouseY = love.mouse:getY()
			self.super.bus:event(MouseTile(Sprite(sprite.id, Vec2(mouseX, mouseY), sprite.img)))
        end

        imgui.PopID()

        -- Get button position and calculate if next button should be on the same line
        local lastButtonPos = imgui.GetItemRectMax()
        local lastButtonX2 = lastButtonPos
        local nextButtonX2 = lastButtonX2 + itemSpacing + spriteWidth

        if i + 1 <= #self.sprites and nextButtonX2 < windowX2 then
            imgui.SameLine()
        end
    end

    imgui.End()

    imgui.Render()
end

function Gui:shutdown()
	imgui.ShutDown()
end

--
-- User inputs
--
function Gui:textinput(t)
    imgui.TextInput(t)
end

function Gui:keypressed(key)
    imgui.KeyPressed(key)
end

function Gui:keyreleased(key)
    imgui.KeyReleased(key)
end

function Gui:mousemoved(x, y)
	local util = Util()
	local pos = Vec2(x, y)
	local gridCoord = util:getGameCoordAt(pos)
	local gameCoord = Vec2(math.floor(gridCoord.x), math.floor(gridCoord.y))

	if self.drag.isDrag then
		if not (self.drag.pos.x == gameCoord.x and self.drag.pos.y == gameCoord.y) then
			if self.drag.dragMode == "add" then
				Gui.super.bus:event(DragAddTile(gameCoord))
			elseif self.drag.dragMode == "remove" then
				Gui.super.bus:event(RemoveTile(gameCoord))
			end
		end
	end

    imgui.MouseMoved(x, y)
end

-- LMB = 1
-- RMB = 2
function Gui:mousepressed(x, y, button)
	local util = Util()
	local pos = Vec2(x, y)
	local gridCoord = util:getGameCoordAt(pos)
	local gameCoord = Vec2(math.floor(gridCoord.x), math.floor(gridCoord.y))

	if button == 1 then
		self.drag = {isDrag = true, dragMode = "add", pos = gameCoord}
	elseif button == 2 then
		self.drag = {isDrag = true, dragMode = "remove", pos = gameCoord}
		Gui.super.bus:event(RemoveTile(gameCoord))
	end

	imgui.MousePressed(button)
end

function Gui:mousereleased(x, y, button)
	self.drag.isDrag = false
    imgui.MouseReleased(button)
end

function Gui:wheelmoved(x, y)
    imgui.WheelMoved(x, y)
end



