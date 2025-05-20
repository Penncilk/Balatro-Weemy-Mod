-- Saves lookup time
local frame = 0
local thegiftobj = nil

-- Hooks into the update code
local upd = Game.update
function Game:update(dt)
    upd(self, dt)
    frame = math.fmod(frame + 1, 8)
    if (frame == 0) then 
        Gift_animate:f(Gift_animate["frame"] + 1)
    end
    if thegiftobj == nil then
        thegiftobj = G.P_CENTERS.j_weem_thegift
    end
    thegiftobj.pos.x = Gift_animate["frame"] 
end