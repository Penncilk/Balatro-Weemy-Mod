local Pinumber = 3.14
-- There was a doom reference before

SMODS.Atlas {
	-- Key for code to find it with
	key = "wtarots",
	-- The name of the file, for the code to pull the atlas from
	path = "Tarots.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}


SMODS.Atlas {
	-- Key for code to find it with
	key = "pirank_lc",
	-- The name of the file, for the code to pull the atlas from
	path = "pirank_lc.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}



SMODS.Atlas {
	-- Key for code to find it with
	key = "pirank_hc",
	-- The name of the file, for the code to pull the atlas from
	path = "pirank_hc.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Atlas {
	-- Key for code to find it with
	key = "taurank_lc",
	-- The name of the file, for the code to pull the atlas from
	path = "taurank_lc.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}



SMODS.Atlas {
	-- Key for code to find it with
	key = "taurank_hc",
	-- The name of the file, for the code to pull the atlas from
	path = "taurank_hc.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}


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

    

    lc_atlas = 'pirank_lc', 
    hc_atlas = 'pirank_hc',

    shorthand = 'Pi',

    next = { "weem_tau" },
    strength_effect = {fixed = 1},

    suit_map = { Hearts = 0, Clubs = 1, Diamonds = 2, Spades = 3 }
}

SMODS.Rank {
    key = "tau",
    card_key = "T",
    pos = {x = 0},
    nominal = Pinumber*2,
    value = 'Tau',
    loc_txt = {
        name = 'Tau',
    },

    in_pool = function(self, args)
        return false
    end,

    

    lc_atlas = 'taurank_lc', 
    hc_atlas = 'taurank_hc',

    shorthand = 'Tau',

    next = {},
    strength_effect = {ignore = true},

    suit_map = { Hearts = 0, Clubs = 1, Diamonds = 2, Spades = 3 }
}


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
    end
}