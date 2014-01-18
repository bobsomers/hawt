local Class = require "hawt.hump.class"

local Ui = require "hawt.ui.globals"
local Panel = require "hawt.ui.panel"

local VLayout = Class { __includes = Panel,
    children = {}
}

function VLayout:init(opts)
    Panel.init(self, opts)
end

function VLayout:draw()
    Panel.draw(self)
    for _, child in ipairs(self.children) do
        child:draw()
    end
end

function VLayout:add(panels)
    for _, panel in ipairs(panels) do
        table.insert(self.children, panel)
    end
end

function VLayout:getMinWidth()
    local minWidth = self.margin[4] + self.border[4] + self.padding[4] +
                     self.margin[2] + self.border[2] + self.padding[2]
    local maxChildWidth = 0
    for _, child in ipairs(self.children) do
        maxChildWidth = math.max(maxChildWidth, child:getMinWidth())
    end
    return minWidth + maxChildWidth
end

function VLayout:getMinHeight()
    local minHeight = self.margin[1] + self.border[1] + self.padding[1] +
                      self.margin[3] + self.border[3] + self.padding[3]
    local maxChildHeight = 0
    for _, child in ipairs(self.children) do
        minHeight = minHeight + child:getMinHeight()
    end
    return minHeight
end

function VLayout:computeLayout(x, y, width, height)
    local minHeight = self:getMinHeight()
    local leftover = height - minHeight -
                     self.margin[1] - self.border[1] - self.padding[1] -
                     self.margin[3] - self.border[3] - self.padding[3]

    -- TODO
--    if leftover > 0 then
--        -- Handle expanding panels.
--    else
        -- Distribute evenly to all children.
        local allocatedWidth = width - self.margin[4] - self.border[4] - self.padding[4] -
                                       self.margin[2] - self.border[2] - self.padding[2]
        local allocatedHeight = (minHeight + leftover) / #self.children
        for i, child in ipairs(self.children) do
            local cx = x + self.margin[4] + self.border[4] + self.padding[4]
            local cy = y + self.margin[1] + self.border[1] + self.padding[1] + (allocatedHeight * (i - 1))
            child:computeLayout(cx, cy, allocatedWidth, allocatedHeight)
        end
--    end
    
    Panel.computeLayout(self, x, y, width, height)
end

return VLayout
