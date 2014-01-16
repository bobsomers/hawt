local Editor = {}

function Editor:init()
    self.hotkey = "pause"
    self.active = false
    self.font = love.graphics.newFont("hawt/assets/days.ttf", 24)
end

function Editor:update(stockFunc, dt)
    if not self.active then
        stockFunc(dt)
    end
end

function Editor:draw(stockFunc)
    stockFunc()

    local ww = love.window.getWidth()
    local wh = love.window.getHeight()

    if self.active then
        love.graphics.setColor(0, 0, 0, 128)
        love.graphics.rectangle("fill", 0, 0, ww, wh)

        love.graphics.setColor(255, 255, 255)
        love.graphics.setFont(self.font)
        love.graphics.print("Hawt is active...", 50, 50)
    end
end

function Editor:keypressed(stockFunc, key, isrepeat)
    if not self.active and key ~= self.hotkey then return stockFunc(key, isrepeat) end

    if key == self.hotkey then
        self.active = not self.active
    end

    print("EDITOR PRESSED", key)
end

function Editor:keyreleased(stockFunc, key)
    if not self.active then return stockFunc(key) end

    print("EDITOR RELEASED", key)
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
