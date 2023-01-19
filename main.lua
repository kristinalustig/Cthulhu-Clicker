local T = require "timer"
local C = require "content"
local L = require "letters"

local ticks
local bgMusic

DEBUG = false

SCENES = {
  TitleScene = 1,
  IntroScene = 2,
  MainScene = 3,
  GameOverScene = 4
  }

lg = love.graphics

currentScene = SCENES.TitleScene

function love.load()
  
  bgMusic = love.audio.newSource("/assets/bg.mp3", "stream")
  bgMusic:setLooping(true)
  bgMusic:play()
  
  ticks = {}
  
  C.init()
  T.init()
  L.init()
  
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
  
  if currentScene == SCENES.MainScene then
    C.mousePressed(x, y)
  end

end

function love.mousemoved(x, y, dx, dy)
  
  C.mouseMoved(x, y)
  
end

function love.keypressed(key, s, r)
  
  if key == "return" and currentScene == SCENES.TitleScene then
    currentScene = SCENES.IntroScene
  elseif key == "return" and currentScene == SCENES.IntroScene then
    currentScene = SCENES.MainScene
  end
  
end