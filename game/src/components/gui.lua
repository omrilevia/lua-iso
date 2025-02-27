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
end

function Gui:load(scene)
	local constants = Constants()
	self.sprites = {} 

	for i = 1, constants.NUM_TILE_TYPES do
		if i == 6 then
			-- tile is broken
		else 
			table.insert(self.sprites, {id = i, img = love.graphics.newImage(constants.TILE_ASSET_PATH .. "tile-" .. i .. ".png") })
		end
	end

	Gui.super:load(scene)
end

function Gui:update(dt)
	imgui.NewFrame()
end

function Gui:draw()
    imgui.Begin("Editor")

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
			self.super.scene:getComponent("mouse"):attachSprite(Sprite(sprite.id, Vec2(mouseX, mouseY), sprite.img))
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
    imgui.MouseMoved(x, y)
end

function Gui:mousepressed(x, y, button)
	if self.scene:getComponent("mouse"):getSpriteAttached() then
		self.scene:getComponent("mouse"):place()
	end
    imgui.MousePressed(button)
end

function Gui:mousereleased(x, y, button)
    imgui.MouseReleased(button)
end

function Gui:wheelmoved(x, y)
    imgui.WheelMoved(x, y)
end



