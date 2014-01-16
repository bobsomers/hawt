local Class = require "hawt.hump.class"

local Ui = require "hawt.ui.globals"

local Panel = Class {
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    minWidth = 50,
    minHeight = 50,
    expanding = false,
    background = Ui.panelBackground,
    border = {0, 0, 0, 0},
    borderColor = Ui.panelBorderColor,
    margin = {0, 0, 0, 0},
    padding = {0, 0, 0, 0}
}

function Panel:init(opts)
    if not opts then return end

    self.x = opts.x or self.x
    self.y = opts.y or self.y
    self.width = opts.width or self.width
    self.height = opts.height or self.height
    self.background = opts.background or self.background
    self.background[3] = self.background[3] or 255
    self.borderColor = opts.borderColor or self.borderColor
    self.borderColor[3] = self.borderColor[3] or 255

    if opts.border then
        if type(opts.border) == "table" then
            self.border = opts.border
        elseif type(opts.border) == "number" then
            self.border = {opts.border, opts.border, opts.border, opts.border}
        end
    end

    if opts.margin then
        if type(opts.margin) == "table" then
            self.margin = opts.margin
        elseif type(opts.margin) == "number" then
            self.margin = {opts.margin, opts.margin, opts.margin, opts.margin}
        end
    end

    if opts.padding then
        if type(opts.padding) == "table" then
            self.padding = opts.padding
        elseif type(opts.padding) == "number" then
            self.padding = {opts.padding, opts.padding, opts.padding, opts.padding}
        end
    end
end

function Panel:getMinWidth()
    local minWidth = self.margin[4] + self.border[4] + self.padding[4] +
                     self.margin[2] + self.border[2] + self.padding[2] +
                     self.minWidth
    return minWidth
end

function Panel:getMinHeight()
    local minHeight = self.margin[1] + self.border[1] + self.padding[1] +
                      self.margin[3] + self.border[3] + self.padding[3] +
                      self.minHeight
    return minHeight
end

function Panel:computeLayout(x, y, width, height)
    self.x = x + self.margin[4] + self.border[4] + self.padding[4]
    self.y = y + self.margin[1] + self.border[1] + self.padding[1]
    self.width = width - self.margin[4] - self.border[4] - self.padding[4] -
                         self.margin[2] - self.border[2] - self.padding[2]
    self.height = height - self.margin[1] - self.border[1] - self.padding[1] -
                           self.margin[3] - self.border[3] - self.padding[3]
end

function Panel:draw()
    if Ui.debug then
        -- Draw margin.
        love.graphics.setColor(255, 0, 0)
        love.graphics.rectangle("fill",
            self.x - self.padding[4] - self.border[4] - self.margin[4],
            self.y - self.padding[1] - self.border[1] - self.margin[1],
            self.margin[4] + self.border[4] + self.padding[4] + self.width + self.padding[2] + self.border[2] + self.margin[2],
            self.margin[1] + self.border[1] + self.padding[1] + self.height + self.padding[3] + self.border[3] + self.margin[3]
        )
    end

    -- Draw borders.
    if Ui.debug then
        love.graphics.setColor(0, 255, 0)
    else
        love.graphics.setColor(
            self.borderColor[1],
            self.borderColor[2],
            self.borderColor[3],
            self.borderColor[4]
        )
    end
    if self.border[1] > 0 then
        love.graphics.setLineWidth(self.border[1])
        love.graphics.line(
            self.x - self.padding[4] - self.border[4] + 0.5,
            self.y - self.padding[1] - (self.border[1] / 2),
            self.x + self.width + self.padding[2] + self.border[2] - 0.5,
            self.y - self.padding[1] - (self.border[1] / 2)
        )
    end
    if self.border[2] > 0 then
        love.graphics.setLineWidth(self.border[2])
        love.graphics.line(
            self.x + self.width + self.padding[2] + (self.border[2] / 2),
            self.y - self.padding[1] - self.border[1] + 0.5,
            self.x + self.width + self.padding[2] + (self.border[2] / 2),
            self.y + self.height + self.padding[3] + self.border[3] - 0.5
        )
    end
    if self.border[3] > 0 then
        love.graphics.setLineWidth(self.border[3])
        love.graphics.line(
            self.x - self.padding[4] - self.border[4] + 0.5,
            self.y + self.height + self.padding[3] + (self.border[3] / 2),
            self.x + self.width + self.padding[2] + self.border[2] - 0.5,
            self.y + self.height + self.padding[3] + (self.border[3] / 2)
        )
    end
    if self.border[4] > 0 then
        love.graphics.setLineWidth(self.border[4])
        love.graphics.line(
            self.x - self.padding[4] - (self.border[4] / 2),
            self.y - self.padding[1] - self.border[1] + 0.5,
            self.x - self.padding[4] - (self.border[4] / 2),
            self.y + self.height + self.padding[3] + self.border[3] - 0.5
        )
    end

    if Ui.debug then
        -- Draw padding.
        love.graphics.setColor(0, 0, 255)
        love.graphics.rectangle("fill",
            self.x - self.padding[4],
            self.y - self.padding[1],
            self.padding[4] + self.width + self.padding[2],
            self.padding[1] + self.height + self.padding[3]
        )
    end

    -- Draw content background.
    if Ui.debug then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    else
        love.graphics.setColor(
            self.background[1],
            self.background[2],
            self.background[3],
            self.background[4]
        )
        love.graphics.rectangle("fill",
            self.x - self.padding[4], self.y - self.padding[1],
            self.padding[4] + self.width + self.padding[2],
            self.padding[1] + self.height + self.padding[3])
    end
end

return Panel
