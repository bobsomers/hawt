local Editor = {}

local hotkey = "pause"
local active = false

function Editor.update(stockFunc, dt)
    if not active then
        stockFunc(dt)
    end
end

function Editor.draw(stockFunc)
    stockFunc()

    if active then
        love.graphics.print("HAWT IS ACTIVE", 50, 50)
    end
end

function Editor.keypressed(stockFunc, key, isrepeat)
    if key == hotkey then
        active = not active
    else
        if active then
            print("EDITOR PRESSED", key)
        else
            stockFunc(key, isrepeat)
        end
    end
end

function Editor.keyreleased(stockFunc, key)
    if key ~= hotkey then
        if active then
            print("EDITOR RELEASED", key)
        else
            stockFunc(key)
        end
    end
end

function Editor.registerEvents()
    local function nullFunc() end
    local callbacks = {"draw", "keypressed", "keyreleased", "update"}

    -- Patch callbacks that the editor wants to catch, passing the original
    -- function as a continuation to our hijacked version. This allows the
    -- patched function to control when the callback actually gets invoked.
    for _, f in ipairs(callbacks) do
        local stockFunc = love[f] or nullFunc
        if Editor[f] then
            love[f] = function(...)
                return Editor[f](stockFunc, ...)
            end
        end
    end
end

return Editor
