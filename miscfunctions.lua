function round(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces>0 then
    local mult = 10^numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function ease_motive(mod, instant, silent)
    local _mod = function(mod)
        if math.abs(math.max(G.GAME.cur_motivation, mod)) == 0 then return end
        local motive_UI = G.HUD:get_UIE_by_ID('motive_UI_count')
        mod = mod or 0
        mod = math.max(-G.GAME.cur_motivation, mod)
        local text = '+'
        local col = G.C.GREEN
        if mod < 0 then
            text = ''
            col = G.C.RED
        end
        --Ease from current chips to the new number of chips
        G.GAME.cur_motivation = G.GAME.cur_motivation + mod
        --Popup text next to the chips in UI showing number of chips gained/lost
        motive_UI.config.object:update()
        G.HUD:recalculate()
        attention_text({
          text = text..mod,
          scale = 0.8, 
          hold = 0.7,
          cover = motive_UI.parent,
          cover_colour = col,
          align = 'cm',
          })
        --Play a chip sound
        if not silent then play_sound('weem_heal') end
    end
    if instant then
        _mod(mod)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod(mod)
            return true
        end
        }))
    end
end