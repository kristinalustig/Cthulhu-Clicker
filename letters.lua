L = {}

local letters

function L.init()
  
  letters = 
  {
    "cth",
    "myt",
    "sho",
    "infe",
    "the",
    "absol",
    "gen",
    "terr",
    "hype",
    "egg"
    }

end

function L.getLetters(n)
  
  return letters[n]
  
end

return L