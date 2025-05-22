local Pinumber = 3.14
-- There was a doom reference before
local Eulersnum = 2.72
-- It kills me to round this by 2 decimal places


SMODS.Rank {
    key = "pi",
    card_key = "P",
    pos = {x = 0},
    nominal = Pinumber,
    value = 'Pi',
    loc_txt = {
        name = 'Pi',
    },

    in_pool = function(self, args)
        return false
    end,

    lc_atlas = 'constsrank_lc', 
    hc_atlas = 'constsrank_hc',

    shorthand = 'Pi',

    next = { "weem_tau" },
    strength_effect = {fixed = 1},

    suit_map = { Hearts = 0, Clubs = 1, Diamonds = 2, Spades = 3 }
}

SMODS.Rank {
    key = "tau",
    card_key = "T",
    pos = {x = 1},
    nominal = Pinumber*2,
    value = 'Tau',
    loc_txt = {
        name = 'Tau',
    },

    in_pool = function(self, args)
        return false
    end,

    lc_atlas = 'constsrank_lc', 
    hc_atlas = 'constsrank_hc',

    shorthand = 'Tau',

    next = {"weem_E"},
    strength_effect = {fixed = 1},

    suit_map = { Hearts = 0, Clubs = 1, Diamonds = 2, Spades = 3 }
}

SMODS.Rank {
    key = "E",
    card_key = "E",
    pos = {x = 2},
    nominal = Eulersnum,
    value = "Euler's Number",
    loc_txt = {
        name = "Euler's Number",
    },

    in_pool = function(self, args)
        return false
    end,

    lc_atlas = 'constsrank_lc', 
    hc_atlas = 'constsrank_hc',

    shorthand = 'E',

    next = {},
    strength_effect = {ignore = true},

    suit_map = { Hearts = 0, Clubs = 1, Diamonds = 2, Spades = 3 }
}


SMODS.Booster:take_ownership_by_kind('Arcana', {
    create_card = function(self, card, i)
        local _card
        local _tarot = nil
        if (i == 1) then
            if (pseudorandom('PiAppear') < (1/3)) then
                _tarot = "c_weem_pitarot"
                _card = {
                    set = "Tarot",
                    area = G.pack_cards,
                    skip_materialize = true,
                    soulable = true,
                    key = _tarot,
                    key_append = "ta1"
                }
            else
                _card = { set = "Tarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ta1" }
            end
        else
            _card = { set = "Tarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ta1" }
        end
        return _card
    end,
    loc_vars = pack_loc_vars,
})

SMODS.Consumable {
    key = "pitarot",
    set = 'Tarot',
    loc_txt = {
        label = 'Pi',
        name = 'Pi',
        text = { 
            'Converts the rank of',
            'up to {C:attention}#1#{} selected cards', 
            'to {C:attention}Pi{}'
        },
    },
    config =  { select = 5 },
    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.select } }
    end,
    atlas = 'wtarots',
    pos = {x = 0, y = 0},
    use = function(self, card, area, copier)
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                local sel = G.hand.highlighted[i]
                play_sound('tarot2')
                SMODS.change_base(sel, sel.base.suit, 'weem_pi')
                sel:juice_up()
            return true end }))
        end  
    end,

    can_use = function(self, card)
        if #G.hand.highlighted <= card.ability.select then
            return true
        end
    end,

    in_pool = function(self, args)
        allow_duplicates = true
    end

}