local Class = require "hawt.hump.class"

local Ui = require "hawt.ui.globals"
local Panel = require "hawt.ui.panel"

local HLayout = Class { __includes = Panel,
    children = {}
}

function HLayout:init(opts)
    Panel.init(self, opts)
end

function HLayout:draw()
    Panel.draw(self)
    for _, child in ipairs(self.children) do
        child:draw()
    end
end

function HLayout:add(panels)
    for _, panel in ipairs(panels) do
        table.insert(self.children, panel)
    end
end

function HLayout:getMinWidth()
    local minWidth = self.margin[4] + self.border[4] + self.padding[4] +
                     self.margin[2] + self.border[2] + self.padding[2]
    for _, child in ipairs(self.children) do
        minWidth = minWidth + child:getMinWidth()
    end
    return minWidth
end

function HLayout:getMinHeight()
    local minHeight = self.margin[1] + self.border[1] + self.padding[1] +
                      self.margin[3] + self.border[3] + self.padding[3]
    local maxChildHeight = 0
    for _, child in ipairs(self.children) do
        maxChildHeight = math.max(maxChildHeight, child:getMinHeight())
    end
    return minHeight + maxChildHeight
end

function HLayout:computeLayout(x, y, width, height)
    local minWidth = self:getMinWidth()
    local leftover = width - minWidth -
                     self.margin[4] - self.border[4] - self.padding[4] -
                     self.margin[2] - self.margin[2] - self.margin[2]

    -- TODO
--    if leftover > 0 then
--        -- Handle expanding panels.
--    else
        -- Distribute evenly to all children.
        local allocatedWidth = (minWidth + leftover) / #self.children
        local allocatedHeight = height - self.margin[1] - self.border[1] - self.padding[1] -
                                         self.margin[3] - self.border[3] - self.padding[3]
        for i, child in ipairs(self.children) do
            local cx = x + self.margin[4] + self.border[4] + self.padding[4] + (allocatedWidth * (i - 1))
            local cy = y + self.margin[1] + self.border[1] + self.padding[1]
            child:computeLayout(cx, cy, allocatedWidth, allocatedHeight)
        end
--    end

    Panel.computeLayout(self, x, y, width, height)
end

return HLayout
