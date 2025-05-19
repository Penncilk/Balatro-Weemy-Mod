local Pinumber = 3.141592657
-- If you get the reference, I'm proud of you :)

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


--[[
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
	path = "pirank_lc.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}


SMODS.Rank {
    key = "pi",
    card_key = "pi",
    pos = {x = 0},
    nominal = Pinumber,
    loc_text = "Pi",

    lc_atlas = 'pirank_lc', 
    hc_atlas = 'pirank_lc',

    suit_map = { Hearts = 0, Clubs = 1, Diamonds = 2, Spades = 3 }
}
]]--

SMODS.Consumable {
    key = "pitarot",
    set = 'Tarot',
    loc_txt = {
        label = 'Pi',
        name = 'Pi',
        text = { 
            'Converts the rank of',
            'up to {C:attention}3{} selected cards', 
            'to {C:attention}Pi{}'
        },
    },
    atlas = 'wtarots',
    pos = {x = 0, y = 0},
}