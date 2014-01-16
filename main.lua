local Gamestate = require "hump.gamestate"
local Editor = require "hawt.editor"

local BezierGame = require "bezier_game"

function love.load()
    Gamestate.registerEvents()
    Editor.registerEvents()
    Gamestate.switch(BezierGame)
end
