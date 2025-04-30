-- Saves lookup time
local thegiftobj = nil
local frame = 0

-- Hooks into the INIT code
local init = SMODS["INIT"]
function init.Weemy()
    local thegiftobj = G.P_CENTERS.j_mvan_thegift
end

-- Hooks into the update code
local upd = Game.update
function Game:update(dt)
    upd(self, dt)
    frame = math.fmod(frame + 1, 8)
    if (frame == 0) then 
        Gift_animate:f(Gift_animate["frame"] + 1)
    end
    thegiftobj.pos.x = Gift_animate["frame"] 
end