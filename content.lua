C = {}

local buttonSprites
local powerBackground
local titleScreen
local symbolFont
local gameFont
local gameFontSm
local labelFont
local labelFontSm
local cthulhuBar
local scrollBar
local frame
local background

local buttonQuads
local progressQuads
local powerQuads
local buttonWidth
local buttonHeight

local actions

local animCounter

local pointTotal
local incrPerSec
local cthulhuBarProgress
local scrollBarXPosition
local pqAnim
local cbAnim

local goalNum
local cbIncr
local percentIncr

function C.init()
  
  buttonSprites = lg.newImage("/assets/buttons.png")
  cthulhuBar = lg.newImage("/assets/cthulhu-bar.png")
  frame = lg.newImage("/assets/frame.png")
  background = lg.newImage("/assets/background.png")
  titleScreen = lg.newImage("/assets/cthulhu-title.png")
  powerBackground = lg.newImage("/assets/power-bg.png")
  scrollBar = lg.newImage("/assets/scrollbar.png")
  symbolFont = lg.newImageFont("/assets/symbol-font.png", "abcdefghijklmnopqrstuvwxyz ")
  gameFont = lg.newFont("/assets/Marhey-Bold.ttf", 26)
  gameFontSm = lg.newFont("/assets/Marhey-Bold.ttf", 14)
  labelFont = lg.newFont("/assets/TitilliumWeb-Bold.ttf", 20)
  labelFontSm = lg.newFont("/assets/TitilliumWeb-Regular.ttf", 13)
  
  InitButtonQuads()
  InitProgressQuads()
  InitPowerQuads()
  
  buttonWidth = 288
  buttonHeight = 144
  
  scrollBarXPosition = 0
  pqAnim = 1
  cbAnim = 0
  animCounter = 1
  pointTotal = 0
  incrPerSec = 0
  cthulhuBarProgress = 1
  goalNum = 10000
  cbIncr = goalNum / 40
  percentIncr = .1
  
  actions = {}
  
  actions.read = {
    quad = 1,
    x = 20,
    y = 120,
    incr = 1,
    cost = 0,
    isHover = false,
    isEnabled = true,
    numInPlay = 0,
    modValue = 0
    }
  actions.recruit = {
    quad = 7,
    x = 500,
    y = 120,
    incr = 5,
    cost = 100,
    isHover = false,
    isEnabled = false,
    numInPlay = 0,
    modValue = 0
    }
  actions.dig = {
    quad = 4,
    x = 20,
    y = 360,
    incr = 1,
    cost = 20,
    isHover = false,
    isEnabled = false,
    numInPlay = 0,
    modValue = 0
    }
  actions.summon = {
    quad = 10,
    x = 500,
    y = 360,
    incr = 10,
    cost = 1000,
    isHover = false,
    isEnabled = false,
    numInPlay = 0,
    modValue = 0
    }
  
end

function C.update()
  
  local incrPerSecTemp = 0
  
  for k, v in pairs(actions) do
    if pointTotal >= v.cost then
      v.isEnabled = true
    else
      v.isEnabled = false
    end
    if not v.isEnabled then
      v.modValue = 2
    elseif v.isHover then
      v.modValue = 1
    else
      v.modValue = 0
    end
    incrPerSecTemp = incrPerSecTemp + (v.incr * v.numInPlay)
  end
  
  incrPerSec = T.setIncrPerSec(incrPerSecTemp)
  
  pointTotal = T.getTotal()
  
  cthulhuBarProgress = 1 + (2*math.floor(pointTotal/cbIncr))
  print(cthulhuBarProgress)
  
  --ANIMATION UPDATES
  
  scrollBarXPosition = scrollBarXPosition - 1
  if scrollBarXPosition <= -800 then
    scrollBarXPosition = 0
  end
  
  if animCounter % 50 == 0 then
    if pqAnim == 1 then
      pqAnim = 2
    else
      pqAnim = 1
    end
  elseif animCounter % 40 == 0 then
    if cbAnim == 0 then
      cbAnim = 1
    else
      cbAnim = 0
    end
  end
  
  animCounter = animCounter + 1
  
end

function C.draw()
  
  lg.draw(background)
  
  for k, v in pairs(actions) do
    lg.draw(buttonSprites, buttonQuads[v.quad + v.modValue], v.x, v.y)
    if v.isEnabled and v.quad ~= 1 then
      local modifier = 0
      if v.quad == actions.dig.quad then
        modifier = 4
      end
      lg.setFont(labelFontSm)
      lg.printf(math.floor(0-v.cost), v.x + 220 + modifier, v.y + 82, 50, "left")
    elseif v.quad ~= 1 then
      lg.setFont(labelFont)
      lg.printf("unlock at "..math.ceil(v.cost).. " influence", v.x, v.y+50, 288, "center")
    end
  end
  
  lg.draw(powerBackground, powerQuads[pqAnim], 260, 240)
  lg.setFont(gameFont)
  lg.setColor(131/255, 49/255, 33/455)
  lg.printf("influence: "..math.floor(pointTotal), 260, 270, 268, "center")
  lg.setFont(gameFontSm)
  lg.printf("+ "..incrPerSec.." per second", 260, 300, 268, "center")
  lg.reset()
  --lg.printf(pointTotal, 454, 272, 268, "left")
  
  lg.draw(scrollBar, scrollBarXPosition, 30)
  lg.draw(scrollBar, scrollBarXPosition+800, 30)
  
  lg.draw(cthulhuBar, progressQuads[cthulhuBarProgress+cbAnim], 50, 510)
  
  lg.draw(frame)
  
end


function C.mousePressed(mx, my)
  
  for k, v in pairs(actions) do
    if CheckOverlap(mx, my, v.x, v.y, buttonWidth, buttonHeight) and v.isEnabled then
      T.addToTotal(0-v.cost)
      if v.quad ~= 1 then
        v.numInPlay = v.numInPlay + 1
        v.cost = v.cost + (v.cost * percentIncr)
      else
        T.addToTotal(v.incr)
      end
    else
      v.isHover = false
    end
  end
  
end

function C.mouseMoved(x, y)
  
  for k, v in pairs(actions) do
    if CheckOverlap(x, y, v.x, v.y, buttonWidth, buttonHeight) and v.isEnabled then
      v.isHover = true
    else
      v.isHover = false
    end
  end
  
end

-------MISC HELPER METHODS BELOW

function CheckOverlap(mx, my, x, y, w, h)
  
  if mx > x and mx < x + w and my > y and my < y + h then
    return true
  else
    return false
  end
  
end


-------INIT METHODS BELOW

function InitButtonQuads()
  
  buttonQuads = QuadExtractor(0, 0, 288, 144, 4, 3, 864, 576)
  
end

function InitProgressQuads()
  
  progressQuads  = QuadExtractor(0, 0, 700, 68, 40, 2, 1400, 2720)
  
end

function InitPowerQuads()
  
  powerQuads = QuadExtractor(0, 0, 268, 100, 1, 2, 536, 100)
  
end

function QuadExtractor(x, y, w, h, r, c, sw, sh)
  
  local quads = {}
  
  for i=0, r-1, 1 do
    for j=0, c-1, 1 do
      table.insert(quads, lg.newQuad(x+(j*w), y+(i*h), w, h, sw, sh))
    end
  end

  return quads
  
end

return C