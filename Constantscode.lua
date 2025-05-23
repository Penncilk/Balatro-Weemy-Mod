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
    value = "E",
    loc_txt = {
        name = "Euler's Number"
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
    atlas = 'consume',
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
        if (#G.hand.highlighted <= card.ability.select) and (#G.hand.highlighted > 0) then
            return true
        end
    end,

    in_pool = function(self, args)
        allow_duplicates = true
    end

}

SMODS.Consumable {
    key = "espectral",
    set = 'Spectral',
    loc_txt = {
        label = 'espec',
        name = "It's E-verywhere!",
        text = { 
            'Converts the rank of',
            'up to {C:attention}#1#{} selected cards', 
            "to {C:attention}Euler's Number{}",
            " ",
            "{C:inactive}It's looks like just a worse two!{}",
            "{C:inactive}There must be SOME reason to get it...{}"
        },
    },
    config =  { select = 2 },
    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.select } }
    end,
    atlas = 'consume',
    pos = {x = 2, y = 0},
    use = function(self, card, area, copier)
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                local sel = G.hand.highlighted[i]
                play_sound('tarot2')
                SMODS.change_base(sel, sel.base.suit, 'weem_E')
                sel:juice_up()
            return true end }))
        end  
    end,

    can_use = function(self, card)
        if (#G.hand.highlighted <= card.ability.select) and (#G.hand.highlighted > 0) then
            return true
        end
    end,

    in_pool = function(self, args)
        allow_duplicates = true
    end

}

SMODS.Back {
    key = "mathback",
    config = {pirank = 'weem_pi', taurank = 'weem_tau', erank = 'weem_E'},
    loc_txt = {
        name = "Mathematical Deck",
        text = {
            "All {C:attention}Even Ranks{} are",
            "replaced with {C:attention}Pi{}"
        }
    },
    atlas = 'backs', 
    pos = { x = 0, y = 0 },

    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    local values = {'2', '4', '6', '8', '10'}
                    for _, i in ipairs(values) do
                        if card.base.value == i then
                            assert(SMODS.change_base(card, nil, self.config.pirank))
                        end
                    end
                end
                return true
            end
        }))
    end
}

-- The Original
--[[
SMODS.Back {
    key = "mathback",
    config = {pirank = 'weem_pi', taurank = 'weem_tau', erank = 'weem_E'},
    loc_txt = {
        name = "Mathematical Deck",
        text = {
            "All {C:attention}6's{} are replaced with {C:attention}Tau{}",
            "All {C:attention}3's{} are replaced with {C:attention}Pi{}",
            "All {C:attention}2's{} are replaced",
            "with {C:attention}Euler's Number{}"
        }
    },
    atlas = 'backs', 
    pos = { x = 0, y = 0 },

    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    if card.base.value == '2' then
                        assert(SMODS.change_base(card, nil, self.config.erank))
                    end
                    if card.base.value == '3' then
                        assert(SMODS.change_base(card, nil, self.config.pirank))
                    end
                    if card.base.value == '6' then
                        assert(SMODS.change_base(card, nil, self.config.taurank))
                    end
                    
                end
                return true
            end
        }))
    end
}
]]--

-- TODO
--[[
SMODS.Consumable {
    key = "imagtarot",
    set = 'Tarot',
    loc_txt = {
        label = 'Imaginary',
        name = 'The Lateral',
        text = { 
            'Converts {C:attention}#1#{} of your',
            'cards into {C:attention}Imaginary Cards{}', 
        },
    },
    config =  { select = 2 },
    loc_vars = function(self, info_queue, card) 
        return { vars = { card.ability.select } }
    end,
    atlas = 'consume',
    pos = {x = 1, y = 0},
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
}
]]--

--[[
SMODS.Enhancement {
    key = "imagcard",
    loc_txt = {
        name = "Imaginary Card",
        description = {
            "Played card will give mult",
            "Instead of chips"
        }
    },
    atlas = "enhance",
    replace_base_card = true,
    pos = {x = 0, y = 0},
    calculate = function(self, card, context)
        local value = card.base.nominal
        return {
            mult = card.base.nominal
        }
    end,
}
]]--