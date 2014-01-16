local Ui = require "hawt.ui.globals"
local Panel = require "hawt.ui.panel"

local Editor = {}

function Editor:init()
    self.hotkey = "pause"
    self.active = false
    self.playing = true
    self.font = love.graphics.newFont("hawt/assets/days.ttf", 24)

    self.panel = Panel {
        background = Ui.panelBackground,
        borderColor = Ui.panelBorderColor,
        border = {10, 20, 30, 40},
        margin = {10, 20, 30, 40},
        padding = {10, 20, 30, 40}
    }
end

function Editor:update(stockFunc, dt)
    if not self.active or (self.active and self.playing) then stockFunc(dt) end
end

function Editor:draw(stockFunc)
    stockFunc()

    local ww = love.window.getWidth()
    local wh = love.window.getHeight()

    if self.active then
        love.graphics.setColor(
            Ui.overlayBackground[1],
            Ui.overlayBackground[2],
            Ui.overlayBackground[3],
            Ui.overlayBackground[4]
        )
        love.graphics.rectangle("fill", 0, 0, ww, wh)

        love.graphics.setColor(
            Ui.panelColor[1],
            Ui.panelColor[2],
            Ui.panelColor[3],
            Ui.panelColor[4]
        )
        love.graphics.setFont(self.font)
        love.graphics.print("Hawt is active...", 50, 50)

        self.panel:draw()
    end
end

function Editor:keypressed(stockFunc, key, isrepeat)
    if not self.active and key ~= self.hotkey then return stockFunc(key, isrepeat) end

    if key == self.hotkey then
        self.active = not self.active
    end

    if key == " " then
        self.playing = not self.playing
    end
end

function Editor:keyreleased(stockFunc, key)
    if not self.active and key ~= self.hotkey then return stockFunc(key) end
end

function Editor:mousepressed(stockFunc, x, y, button)
    if not self.active then return stockFunc(x, y, button) end
end

function Editor:mousereleased(stockFunc, x, y, button)
    if not self.active then return stockFunc(x, y, button) end
end

function Editor.registerEvents()
    local function nullFunc() end
    local callbacks = {
        "draw",
        "keypressed",
        "keyreleased",
        "mousepressed",
        "mousereleased",
        "update"
    }

    -- Patch callbacks that the editor wants to catch, passing the original
    -- function as a continuation to our hijacked version. This allows the
    -- patched function to control when the callback actually gets invoked.
    for _, f in ipairs(callbacks) do
        local stockFunc = love[f] or nullFunc
        if Editor[f] then
            love[f] = function(...)
                return Editor[f](Editor, stockFunc, ...)
            end
        end
    end

    Editor.init(Editor)
end

return Editor
