local Ui = require "hawt.ui.globals"
local Panel = require "hawt.ui.panel"
local HLayout = require "hawt.ui.hlayout"
local VLayout = require "hawt.ui.vlayout"

local Editor = {}

function Editor:init()
    self.hotkey = "`"
    self.active = false
    self.playing = true
    self.font = love.graphics.newFont("hawt/assets/days.ttf", 24)

    self.panels = {
        Panel {
            border = 2,
            padding = 4,
            margin = 4,
--            border = {0, 1, 2, 3},
--            margin = {0, 1, 2, 3},
--            padding = {0, 1, 2, 3}
        },
        Panel {
            border = 2,
            padding = 4,
            margin = 4,
--            border = {4, 5, 6, 7},
--            margin = {4, 5, 6, 7},
--            padding = {4, 5, 6, 7}
        },
        Panel {
            border = 2,
            padding = 4,
            margin = 4,
--            border = {8, 9, 10, 11},
--            margin = {8, 9, 10, 11},
--            padding = {8, 9, 10, 11}
        },
        Panel {
            border = 2,
            padding = 4,
            margin = 4,
--            border = {12, 13, 14, 15},
--            margin = {12, 13, 14, 15},
--            padding = {12, 13, 14, 15}
        }
    }

    self.innerLayout = VLayout {
        background = {0, 0, 0, 0}
--        border = {2, 4, 6, 8},
--        margin = {2, 4, 6, 8},
--        padding = {2, 4, 6, 8}
    }
    self.innerLayout:add {
        self.panels[1],
        self.panels[2]
    }

    self.outerLayout = HLayout {
        background = {0, 0, 0, 0}
--        border = {3, 5, 7, 9},
--        margin = {3, 5, 7, 9},
--        padding = {3, 5, 7, 9}
    }
    self.outerLayout:add {
        self.innerLayout,
        self.panels[3],
        self.panels[4]
    }

    self.t = 0
end

function Editor:update(stockFunc, dt)
    if not self.active or (self.active and self.playing) then stockFunc(dt) end

    self.t = self.t + dt
    local width = (400 * (math.sin(self.t) + 1)) + 400
    local height = (200 * (math.sin(self.t * 0.9) + 1)) + 200
    self.outerLayout:computeLayout(50, 50, width, height)
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

        self.outerLayout:draw()
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
