imgui = require "lib.imgui"
require "src.components.sprite"
Gui = GameObject:extend()

local showTestWindow = false
local showAnotherWindow = false
local floatValue = 0;
local sliderFloat = { 0.1, 0.5 }
local clearColor = { 0.2, 0.2, 0.2 }
local comboSelection = 1
local textValue = "text"

function Gui:new()
end

function Gui:load()
	sprites = {}
	table.insert(sprites, Sprite(64, 64)) 
    table.insert(sprites, Sprite(64, 64))
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
    for i, sprite in ipairs(sprites) do
        local spriteWidth = sprite.width 
        local spriteHeight = sprite.height

        imgui.PushID(i)

        -- Using imageButton for sprite display
        if imgui.ImageButton(sprite.image, spriteWidth, spriteHeight) then
            -- Handle object pickup here, like generating a new object for the level editor
            pickedObject = {sprite = sprite, x = 100, y = 100}  -- Example of picking up an object
        end

        imgui.PopID()

        -- Get button position and calculate if next button should be on the same line
        local lastButtonPos = imgui.GetItemRectMax()
        local lastButtonX2 = lastButtonPos
        local nextButtonX2 = lastButtonX2 + itemSpacing + spriteWidth

        if i + 1 <= #sprites and nextButtonX2 < windowX2 then
            imgui.SameLine()
        end
    end

    -- Handle picked object and its movement (just a simple example here)
    if pickedObject then
        -- Here, you could add logic to update the picked object position based on mouse movement
        pickedObject.x = love.mouse.getX() - pickedObject.sprite.width / 2
        pickedObject.y = love.mouse.getY() - pickedObject.sprite.height / 2
    end

    -- Draw the picked object
    if pickedObject then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(pickedObject.sprite.image, pickedObject.x, pickedObject.y)
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
    imgui.MousePressed(button)
end

function Gui:mousereleased(x, y, button)
    imgui.MouseReleased(button)
end

function Gui:wheelmoved(x, y)
    imgui.WheelMoved(x, y)
end



