assert(SMODS.load_file('luts.lua'))()
assert(SMODS.load_file('Animation.lua'))()
assert(SMODS.load_file('Constantscode.lua'))()

--Creates an atlas for cards to use
SMODS.Atlas {
	-- Key for code to find it with
	key = "KRis",
	-- The name of the file, for the code to pull the atlas from
	path = "Jokers.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Atlas {
	-- Key for code to find it with
	key = "TheGiftAtlas",
	-- The name of the file, for the code to pull the atlas from
	path = "TheGiftAtlas.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Sound {
	key = "slash",
	path = {
		['default'] = "e_the_gift_slash.ogg",
	}
}


SMODS.Joker {
	-- How the code refers to the joker.
	key = 'skris',
	-- loc_text is the actual name and description that show in-game for the card.
	loc_txt = {
		name = 'Exposed Heart',
		text = {
			--[[
			The #1# is a variable that's stored in config, and is put into loc_vars.
			The {C:} is a color modifier, and uses the color "mult" for the "+#1# " part, and then the empty {} is to reset all formatting, so that Mult remains uncolored.
				There's {X:}, which sets the background, usually used for XMult.
				There's {s:}, which is scale, and multiplies the text size by the value, like 0.8
				There's one more, {V:1}, but is more advanced, and is used in Castle and Ancient Jokers. It allows for a variable to dynamically change the color. You can find an example in the Castle joker if needed.
				Multiple variables can be used in one space, as long as you separate them with a comma. {C:attention, X:chips, s:1.3} would be the yellow attention color, with a blue chips-colored background,, and 1.3 times the scale of other text.
				You can find the vanilla joker descriptions and names as well as several other things in the localization files.
				]]
			"If played hand is a flush of {C:mult}hearts{}",
			"retrigger all played cards"
			}
	},
	--[[
		Config sets all the variables for your card, you want to put all numbers here.
		This is really useful for scaling numbers, but should be done with static numbers -
		If you want to change the static value, you'd only change this number, instead
		of going through all your code to change each instance individually.
		]]
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { repetitions = 1 } },
	-- loc_vars gives your loc_text variables to work with, in the format of #n#, n being the variable in order.
	-- #1# is the first variable in vars, #2# the second, #3# the third, and so on.
	-- It's also where you'd add to the info_queue, which is where things like the negative tooltip are.
	-- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
	rarity = 2,
	-- Which atlas key to pull from.
	atlas = 'KRis',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 0, y = 0 },
	-- Cost of card in shop.
	cost = 6,
	
	-- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
	calculate = function(self, card, context)

	
		if context.repetition and context.cardarea == G.play and next(context.poker_hands['Flush']) then

			-- context.other_card is something that's used when either context.individual or context.repetition is true
			-- It is each card 1 by 1, but in other cases, you'd need to iterate over the scoring hand to check which cards are there.
			if (context.other_card.base.suit == "Hearts" or SMODS.has_any_suit(context.other_card)) then
				return {
					repetitions = card.ability.extra.repetitions,
				-- The card the repetitions are applying to is context.other_card
					
					card = context.other_card,
				-- This is a localize function. Localize looks through the localization files, and translates it. It ensures your mod is able to be translated. I've left it out in most cases for clarity reasons, but this one is required, because it has a variable.
				-- This specifically looks in the localization table for the 'variable' category, specifically under 'v_dictionary' in 'localization/en-us.lua', and searches that table for 'a_mult', which is short for add mult.
				-- In the localization file, a_mult = "+#1#". Like with loc_vars, the vars in this message variable replace the #1#.

					message = 'Again!',
				-- Without this, the mult will stil be added, but it'll just show as a blank red square that doesn't have any text.
				}
			end
		end
	end
}

SMODS.Joker {

	key = 'Clover',

	loc_txt = {
		name = '3 Leaf Clover',
		text = {
			"{C:green}#1# in #2#{} chance to",
			"to give {X:mult,C:white}x#3#{} {C:mult}mult{}",
			"per card played"
			}
	},

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { xmult = 2, odds = 4 } },
	rarity = 3,

	atlas = 'KRis',

	pos = { x = 1, y = 0 },

	cost = 8,

	loc_vars = function(self, info_queue, card)
		return { vars = { (G.GAME.probabilities.normal), card.ability.extra.odds, card.ability.extra.xmult  } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if pseudorandom('Clover') < G.GAME.probabilities.normal / card.ability.extra.odds then
				return {
				Xmult = card.ability.extra.xmult,
				message = 'Lucky!'
				}
			end

		end
	end
}

SMODS.Joker {

	key = 'DSine',

	loc_txt = {
		name = 'Dead-Line',
		text = {
			"Give {X:mult,C:white}x#1#{} mult",
			"on last hand of round", 
			"if there's {C:attention}no discards{} remaining",
			}
	},

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { xmult = 10 },
	rarity = 2,

	atlas = 'KRis',

	pos = { x = 2, y = 0 },

	cost = 5,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,                                             
	calculate = function(self, card, context)
			if context.joker_main and G.GAME.current_round.hands_left == 0 and G.GAME.current_round.discards_left == 0 then
				return {
					message = 'still made it!!-',
					xmult = card.ability.xmult,
				}
		end
	end
}

SMODS.Joker {

	key = 'Sine',

	loc_txt = {
		name = 'Coding Oversight',
		text = {
			"Cards give their total chips value",
			"as {C:mult}+mult{} and {C:money}$money{}"
			}
	},

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,


	atlas = 'KRis',

	pos = { x = 3, y = 0 },

	cost = 10,

	loc_vars = function(self, info_queue, card)  
	return { vars = { card.ability.money, card.ability.mult } }
	end,	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
				-- Checks to see if the id is an ace or face card,
				-- Otherwise return the id, as it is equal to the card's value
				local give_amount = context.other_card.base.nominal
				local possible_messages = {
					'Haha yeah!!',
					'Integer overflow!!',
					'Memory Leak??',
					'How has this not crashed...',
					'Hell yeah, Exploitation',
					'Arbitrary Code Execution',
					'We love luajit',
					'lua 5.1 lets goooo'
				}
				if (context.other_card.ability.effect == 'Stone Card') then
					give_amount = 0
				end
				-- Adds bonus chips either from bonus cards or perma_bonus
				give_amount = give_amount + context.other_card.ability.bonus + context.other_card.ability.perma_bonus
			return {
				mult = give_amount,
				dollars = give_amount,

				message = possible_messages[math.random(1, 8)]
			}
		end
	end
}


SMODS.Joker {

	key = 'siffrin',

	loc_txt = {
		name = 'Gambling loop',
		text = {
			"{C:green}#1# in #2#{} chance to retrigger",
			"played spade cards {C:attention}#3#{} times"
			}
	},

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true, 
	rarity = 1,
	config =  { repetitions = 4, odds = 8 },

	atlas = 'KRis',

	pos = { x = 4, y = 0 },

	cost = 8,

	loc_vars = function(self, info_queue, card)  
	return { vars = { (G.GAME.probabilities.normal), card.ability.odds, card.ability.repetitions } }
	end,	
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			if (context.other_card.base.suit == "Spades" or SMODS.has_any_suit(context.other_card)) then
				if pseudorandom('siffrin') < G.GAME.probabilities.normal / card.ability.odds then
					return {
						repetitions = card.ability.repetitions,
						card = context.other_card,

						message = 'again...'
					}
				end
			end

		end
	end
}

SMODS.Joker {

	key = 'Fish',

	loc_txt = {
		name = 'Cat Fish',
		text = {
			"{C:mult}+#1#{} mult per {C:money}$#2#{} you have",
			"lose {C:money}$#4#{} at the end of round",
			"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
			}
	},

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,
	-- Nerfed it a bit -Lena
	config =  { mult = 15, money = 20, money_loss = 20 },


	atlas = 'KRis',

	pos = { x = 6, y = 0 },

	cost = 10,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.mult, card.ability.money, (card.ability.mult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.money)), card.ability.money_loss } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and to_number(math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.money)) >= 1 then
        	return {
				mult = to_number(card.ability.mult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/card.ability.money))
			}
        end
		if context.end_of_round and context.cardarea == G.jokers then 
			return {
				dollars = ((-1)*card.ability.money_loss),
			}
		end
	end
}


SMODS.Joker {

	key = 'Azzy',

	loc_txt = {
		name = 'Flushed?~',
		text = {
			"If hand is a {C:attention}flush{}",
			"give {X:blue,C:white}x#1#{} chips",
			}
	},

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,
	config = { chips = 5 },


	atlas = 'KRis',

	pos = { x = 5, y = 0 },

	cost = 8,

	loc_vars = function(self, info_queue, card)  
	return { vars = { card.ability.chips } }
	end,	
	calculate = function(self, card, context)
		if context.joker_main then
			if context.cardarea == G.jokers and next(context.poker_hands['Flush']) and hand_chips then
				return {
					x_chips = card.ability.chips,
					message = "Nya!~"
				}
			else
				return {
					message = "Pathetic~"
				}
			end
		end
	end
}

SMODS.Joker {

	key = 'Kris',

	loc_txt = {
		name = 'Messy art',
		text = {
			"If hand contains a {C:attention}Wild card{}",
			"get an Enhancement on every card",
			"lose {C:attention}Wild card{} Enhancement on cards"
			}
	},

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,

	atlas = 'KRis',

	pos = { x = 7, y = 0 },

	cost = 8,

	loc_vars = function(self, info_queue, card)  
	return { vars = { card.ability.chips } }
	end,	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_wild') then
			local card_settings = {
				Original = false,
				-- Destroy has its set of bugs, but works in theory
				Destroy = false
			}
			
			if card_settings.Original then -- The Original Idea (The slightly more balanced one)
				if SMODS.has_enhancement(context.other_card, 'm_wild') and (not context.other_card.edition) then 
					local edition = poll_edition('aura', nil, true, true)
					context.other_card:set_edition(edition, true)
				end
				
			else -- The Alternative Version (The one designed around the bug)
				 -- Removes Wild enhancement from all cards
				if SMODS.has_enhancement(context.other_card, 'm_wild') then 
					
					if card_settings.Destroy then
						-- Killin' a card ain't no big deal!
						-- Just put a gun to its head
						-- POW...

						-- [Insert FNF song "IRON LUNG" here]
						context.other_card:start_dissolve({G.C.RED}, nil, 1.6)
					else
						context.other_card:set_ability(G.P_CENTERS.c_base, nil, true)
					end

					
				end
				
				for k, v in ipairs(context.scoring_hand) do	
						local edition = poll_edition('aura', nil, true, true)
						-- If the card has an edition it will not effect, 
						-- this will prevent overlapping 
						if not v.edition then
							v:set_edition(edition, true)
						end
					end
				end
        end
			
	end
}

SMODS.Joker {

	key = 'ethan',

	loc_txt = {
		name = 'Commit to the Bit',
		text = {
			"If hand played is {C:attention}not{}",
			"your {C:attention}most played hand{}",
			"destroy played cards after scoring",
			"give {X:mult,C:white}x#1#{} mult",
			}
	},

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,
	config = { mult = 10 },


	atlas = 'KRis',

	pos = { x = 9, y = 0 },

	cost = 8,
	loc_vars = function(self, info_queue, card)  
	return { vars = { card.ability.mult } }
	end,
	
	calculate = function(self, card, context)
		if context.destroying_card and not context.blueprint then
			local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
                        for k, v in pairs(G.GAME.hands) do
                            if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
								return not context.destroying_card.ability.eternal
							end
                        end
		end
			if context.joker_main then
			return{
				xmult = card.ability.mult
			}

		end
	end
	-- if context.before and not context.blueprint then
	-- local reset = true
    -- local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
        -- for k, v in pairs(G.GAME.hands) do
                -- if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                        -- reset = false
                -- end
                -- if reset then
                        -- return {
								-- mult = card.ability.mult
								-- }
				-- else
					-- if context.destroy_card and not context.blueprint then
							-- return not context.destroying_card.ability.eterna
					-- end
				-- end	
		-- end
	-- end
}

SMODS.Joker {

	key = 'm_horror',

	loc_txt = {
		name = 'Horror^3',
		text = {
			"if hand has {C:attention}3{} or less cards",
			"all played cards become {C:edition}negative{}",
			"{C:attention}Self Destructs{} after #1# hands"
			}
	},

	config = {
		counter = 6
	},

	loc_vars = function(self, info_queue, card)  
		return { vars = { card.ability.counter } }
	end,

	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,


	atlas = 'KRis',

	pos = { x = 8, y = 0 },

	cost = 4,

	calculate = function(self, card, context)
		if (context.individual and context.cardarea == G.play and #context.full_hand <= 3) then
			for k, v in ipairs(context.scoring_hand) do
				v:set_edition({negative = true}, true)
			end
		end

		if context.after then
			card:juice_up()
			card.ability.counter = card.ability.counter - 1
			if card.ability.counter == 1 then
				return {message = card.ability.counter.." Day Left..."}
			elseif card.ability.counter == 0 then
				local fscreen, _ = love.window.getFullscreen()
				if (not G.GAME.pool_flags.weem_horror3die) then
					return {message = "Null Joined the game"}
				else
					return {message = "..."}
				end
			else
				return {message = card.ability.counter.." Days Left..."}
			end
		end

		if card.ability.counter == 0 then
			-- The funny thing
			local fscreen, _ = love.window.getFullscreen()
			if (not G.GAME.pool_flags.weem_horror3die) then
				G.GAME.pool_flags.weem_horror3die = true
			end
			if card.ability.eternal then
				card.debuff = true
			else
				card:start_dissolve({G.C.RED}, nil, 1.6)
			end
		end
		
	end
}

SMODS.Joker {

    key = 'm_vobelisk',

    loc_txt = {
        name = 'Vandalized Obelisk',
        text = {
            "This Joker gains {X:mult,C:white}x#2#{} Mult",
            "per consecutive hand played",
            "without playing your most played poker hand",
            "{C:attention}DOES NOT RESET{}",
            "Currently {X:mult,C:white}x#1#{}"
            }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.xmult, card.ability.upgrade } }
    end,

    config = { xmult = 1, upgrade = 0.1 },

    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 3,


    atlas = 'KRis',

    pos = { x = 0, y = 1 },

    cost = 4,

			calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local reset = false
			local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
			for k, v in pairs(G.GAME.hands) do
				if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
					reset = true
				end
			end
				if reset then
					if reset then
						card.ability.xmult =
							lenient_bignum(to_big(card.ability.xmult) + card.ability.upgrade)
							return {
								card = self,
								message  = "upgrade",
							}
						end
					else
						return {
								card = self,
								message = "Get weemyd",
							}
						--TODO return the proper upgrade text
						
					end
				end
				if context.joker_main then
					return {
						xmult = card.ability.xmult
					}
				end
		end
}

SMODS.Joker {

	key = 'm_estrogen',

	loc_txt = {
		name = 'Estrogen',
		text = {
			"All {C:attention}Face cards{}",
			"Become Queens"
			}
	},

	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,

	atlas = 'KRis',

	pos = { x = 1, y = 1 },

	cost = 3,

	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_face() and (context.other_card:get_id() ~= 12) then
				SMODS.change_base(context.other_card, context.other_card.base.suit, "Queen")
				context.other_card:juice_up()
				return {
					message = "Transfem"
				}
			end
		end
	end
}

SMODS.Joker {

    key = 'a_pipline',

    loc_txt = {
        name = 'Pipeline',
        text = {
            -- "Gain {C:chips}#1#{} chips if hand", 
			-- "contains at least 1 {C:attention}'queen'{}",
			-- "and {C:attention}'no'{} other face cards",
			-- ^ this one was the og idea, changed it because both funny new idea, and this one is hard
			"Each {C:attention}queen{} gives {C:chips}#1#{}",
			"all other {C:attention}face cards{} give {C:chips}-#1#{}",
            }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.chips } }
    end,

    config = { chips = 100 },

    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 1,
	
	atlas = 'KRis',

	pos = { x = 4, y = 1 },
  
  	cost = 4,

	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then	
			if context.other_card:get_id() == 12 then
				return {
					chips = card.ability.chips,
					message = ":3c",
				}
			end
			if context.other_card:get_id() == 11 or context.other_card:get_id() == 13 then
				return {
					chips = ((-1)*card.ability.chips),
					message = ":(",
				}
			end
		end
	end
}
 
Gift_animate = {
	frame = 0,
	animation = 0,
	f = function(self, n) 
		self["frame"]=math.fmod(n, 5)
	end
}

local function giftani(card, time) 
	G.E_MANAGER:add_event(Event({
		func = function() 
			card:juice_up()
			card.config.center.pos.y = 1
			return true
		end
	}))

	G.E_MANAGER:add_event(Event({
		trigger = "after", 
		blocking = false,
		delay = time, 
		func = function() 
			card:juice_up()
			card.config.center.pos.y = 0
			return true 
		end
	}))
end

SMODS.Joker {

	key = 'thegift',

	loc_txt = {
		name = 'THE gift',
		text = {
			"Give {X:edition,C:black}^#2#{} mult and {X:blue,C:white}x#1#{} chips",
			"Destroy the jokers to its left and right"
			}
	},

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 4,

	atlas = 'TheGiftAtlas',

	pos = { x = 0, y = 0 },

	config = {
		x_chips = 3,
		e_mult = 3,

	},

	loc_vars = function(self, info_queue, card)  
	return { vars = { card.ability.x_chips, card.ability.e_mult } }
	end,

	cost = 20,

	calculate = function(self, card, context)
		-- Checks at the start of blind
		if context.setting_blind then
			play_sound('weem_slash')
			giftani(card, 2)
			-- Finds the location of where YOU is
			local location = nil
			-- Checks if the card in question is ACTUALLY this card
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then location = i end
			end
			-- Gets rid of ajacent if possible
			if location ~= nil then
				-- Checking for index out of bounds
				if location > 1 then
					-- If the ajacent joker is another THE gift, don't fw it
					if (G.jokers.cards[location-1].config.center_key ~= "j_weem_thegift" and not G.jokers.cards[location-1].ability.eternal) then
						G.jokers.cards[location-1]:start_dissolve({G.C.RED}, nil, 1.6)
					end
				end
				if location < #G.jokers.cards then
					if (G.jokers.cards[location+1].config.center_key ~= "j_weem_thegift" and not G.jokers.cards[location+1].ability.eternal) then
					G.jokers.cards[location+1]:start_dissolve({G.C.RED}, nil, 1.6)
					end
				end
			end
		end
		-- When the joker is actually RAN
		if context.joker_main then
			giftani(card, 5)

			return {
				xchips = card.ability.x_chips,
				emult = card.ability.e_mult,
			}
		end
	end
}


SMODS.Joker {
	key = 'null',
	loc_txt = {
		name = 'Null',
		text = {
			"Retrigger negative cards {C:attention}#1#{} times"
			}
	},
	config =  { repetitions = 1 },
	loc_vars = function(self, info_queue, card)  
	return { vars = { card.ability.repetitions } }
	end,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 2,

	atlas = 'KRis',

	pos = { x = 3, y = 1 },

	cost = 6,
	
	
	calculate = function(self, card, context)
		local possible_messages = {
					'wuh??',
					'how???',
					'what?',
					'who?',
					'when??????????'
				}
		if context.repetition and context.cardarea == G.play then
			if context.other_card.edition ~= nil then
				if context.other_card.edition.type == "negative" then
					return {
							repetitions = card.ability.repetitions,
							card = context.other_card,

							message = possible_messages[math.random(1, 5)]

					}
				end
			end
		end
	end,

	in_pool = function(self, args)
		return G.GAME.pool_flags.weem_horror3die
	end
}

SMODS.Joker {

	key = 'gift_clover',

	loc_txt = {
		name = 'Clover Gifts',
		text = {
			"Each {C:green}'Clover'{} joker",
			"gives {X:mult,C:white}x#1#{} mult"
			}
	},

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,

	atlas = 'KRis',

	pos = { x = 2, y = 1 },

	cost = 3,
	
	config = { xmult = 2 },
	
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.xmult } }
    end,

	
	calculate = function(self, card, context)
		if context.other_joker then
			local clovers = Clover_Jokers
			for _, i in pairs(clovers) do
				-- Checks if each joker is a Clover Joker
				if context.other_joker.config.center_key == ("j_weem_"..i) then
					return {
						xmult = card.ability.xmult
					}
				end
			end
		end
	end,



}


-- TODO:
-- Have people proofread, make sure my overly long way of writing is actually legible or cut down to make sure it's legible.


----------------------------------------------
------------MOD CODE END----------------------
