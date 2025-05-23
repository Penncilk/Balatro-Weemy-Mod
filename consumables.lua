SMODS.Consumable {
    key = "wctrlz",
    set = 'Tarot',
    loc_txt = {
        label = 'wctrlz',
        name = 'Control + Z',
        text = { 
            'Removes an enhancement from',
            'up to {C:attention}#1#{} selected cards', 
            'Gives back {C:money}$#2#{} per card',
            ' ',
            '{C:inactive}Turns a mathmatical constant into the{}',
            '{C:inactive}integer part of the value{}',
            '{C:inactive}eg. pi -> 3, e -> 2 etc...{}'
        },
    },
    config =  { select = 2, money = 5 },
    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.select, card.ability.money } }
    end,
    atlas = 'consume',
    pos = {x = 3, y = 0},
    use = function(self, card, area, copier)
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.5,func = function()
                local sel = G.hand.highlighted[i]
                local givemoney = true
                if not next(SMODS.get_enhancements(sel)) then
                    if  (not ((sel.base.value == 'weem_pi') or 
                        (sel.base.value == 'weem_tau') or 
                        (sel.base.value == 'weem_E')))  then
                        givemoney = false
                    end 
                end
                play_sound('tarot2')
                sel:set_ability(G.P_CENTERS.c_base, nil, true)
                sel:juice_up()
                if sel.base.value == 'weem_pi' then
                    assert(SMODS.change_base(sel, nil, '3'))
                end
                if sel.base.value == 'weem_tau' then
                    assert(SMODS.change_base(sel, nil, '6'))
                end
                if sel.base.value == 'weem_E' then
                    assert(SMODS.change_base(sel, nil, '2'))
                end
                if givemoney == true then 
                    ease_dollars(card.ability.money) 
                end
            return true end }))
        end  
    end,

    can_use = function(self, card)
        if (#G.hand.highlighted <= card.ability.select) and (#G.hand.highlighted >= 0) then
            return true
        end
    end,

    in_pool = function(self, args)
        allow_duplicates = true
    end

}