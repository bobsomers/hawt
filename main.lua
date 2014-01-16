local grabbed = false
local curve = love.math.newBezierCurve()
local dr = 0

function love.load()

end

function love.update(dt)
    dr = dt * math.pi / 16
end

function love.draw()
    love.graphics.setBackgroundColor(25, 25, 35)
    curve:rotate(dr, love.window.getWidth() / 2, love.window.getHeight() / 2)

    if curve:getControlPointCount() > 1 then
        love.graphics.setColor(100, 100, 100)
        love.graphics.setLineWidth(1)
        love.graphics.line(curve:render(0))

        love.graphics.setColor(200, 200, 200)
        love.graphics.setLineWidth(2)
        love.graphics.line(curve:render(5))
    end

    for i = 1, curve:getControlPointCount() do
        local x, y

        if i == grabbed then
            x, y = love.mouse.getPosition()
            curve:setControlPoint(i, x, y)
            love.graphics.setColor(255, 0, 0)
        else
            x, y = curve:getControlPoint(i)
            love.graphics.setColor(0, 255, 0)
        end

        love.graphics.rectangle("fill", x - 7, y - 7, 15, 15)
    end
end

function love.mousepressed(x, y, button)
    if button == "l" then
        for i = 1, curve:getControlPointCount() do
            local cx, cy = curve:getControlPoint(i)
            if x < cx + 15 and x > cx - 15 and y < cy + 15 and y > cy - 15 then
                grabbed = i
            end
        end

        if not grabbed then
            curve:insertControlPoint(x, y)
        end
    end
end

function love.mousereleased(x, y, button)
    if button == "l" then
        grabbed = false
    end
end
