local Gamestate = require "hump.gamestate"

local BezierGame = {}

function BezierGame:init()
    self.grabbed = false
    self.curve = love.math.newBezierCurve()
    self.rotation = 0
end

function BezierGame:update(dt)
    self.rotation = (self.rotation + (dt * math.pi / 16)) % (math.pi / 2)
end

function BezierGame:draw()
    local wcx = love.window.getWidth() / 2
    local wcy = love.window.getHeight() / 2

    love.graphics.setBackgroundColor(25, 25, 35)

    love.graphics.push()
    love.graphics.translate(wcx, wcy)
    love.graphics.rotate(self.rotation)
    love.graphics.translate(-wcx, -wcy)
    love.graphics.setColor(50, 25, 25)
    love.graphics.rectangle("fill", wcx - 200, wcy - 200, 400, 400)
    love.graphics.pop()

    if self.curve:getControlPointCount() > 1 then
        love.graphics.setColor(100, 100, 100)
        love.graphics.setLineWidth(1)
        love.graphics.line(self.curve:render(0))

        love.graphics.setColor(200, 200, 200)
        love.graphics.setLineWidth(2)
        love.graphics.line(self.curve:render(5))
    end

    for i = 1, self.curve:getControlPointCount() do
        local x, y

        if i == self.grabbed then
            x, y = love.mouse.getPosition()
            self.curve:setControlPoint(i, x, y)
            love.graphics.setColor(255, 0, 0)
        else
            x, y = self.curve:getControlPoint(i)
            love.graphics.setColor(0, 255, 0)
        end

        love.graphics.rectangle("fill", x - 7, y - 7, 15, 15)
    end
end

function BezierGame:keypressed(key, isrepeat)
    print("PRESSED", key)
end

function BezierGame:keyreleased(key)
    print("RELEASED", key)
end

function BezierGame:mousepressed(x, y, button)
    if button == "l" then
        for i = 1, self.curve:getControlPointCount() do
            local cx, cy = self.curve:getControlPoint(i)
            if x < cx + 15 and x > cx - 15 and y < cy + 15 and y > cy - 15 then
                self.grabbed = i
            end
        end

        if not self.grabbed then
            self.curve:insertControlPoint(x, y)
        end
    end
end

function BezierGame:mousereleased(x, y, button)
    if button == "l" then
        self.grabbed = false
    end
end

return BezierGame
