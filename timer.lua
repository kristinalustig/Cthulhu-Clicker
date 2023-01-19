T = {}

local timeStart
local prevTime
local incrPerSec
local currentTotal

function T.init()
  
  timeStart = love.timer.getTime()
  prevTime  = timeStart
  
  currentTotal = 0
  
end

function T.update()
  
  if T.getTick() then
    HappenOnTick()
  end
  
end

function T.getTick()
  
  --every time the timer increments 1 second, things happen, so let's create 'ticks' that make that happen
  --we may need to increment by half seconds as well
  local t = love.timer.getTime()
  if math.floor(t) > math.floor(prevTime) then
    prevTime = t
    
    return true
  end
  
end

function HappenOnTick()
  
  currentTotal = currentTotal + incrPerSec
  
end

function T.setIncrPerSec(n)
  
  incrPerSec = n
  
  return n
  
end

function T.getTotal()
  
  return currentTotal
  
end

function T.addToTotal(n)
  
  currentTotal = currentTotal + n
  
end

return T