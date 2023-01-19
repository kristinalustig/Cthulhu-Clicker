local T = require "timer"
local C = require "content"

local ticks

DEBUG = false

lg = love.graphics

function love.load()
  
  ticks = {}
  
  C.init()
  T.init()
  
end

function love.update()
  
  if DEBUG then
    if T.getTick() then
      table.insert(ticks, "I")
    end
  end

  T.update()
  C.update()
  
end

function love.draw()
  
  C.draw()
  
  if DEBUG then
    for k, v in ipairs(ticks) do
      lg.printf(v, 10*k, 20, 10, "left")
    end
  
    local mx = love.mouse.getX()
    local my = love.mouse.getY()
    lg.printf("("..mx..", "..my..")", mx, my-14, 100, "left")
  end
  
end

function love.mousepressed(x, y, b, t, p)
  
  C.mousePressed(x, y)

end

function love.mousemoved(x, y, dx, dy)
  
  C.mouseMoved(x, y)
  
end