---- Sine ----

SMODS.Joker {
	key = 'Sine1',

	loc_txt = {
		name = 'Quick HOTFIX!!',
		text = {
			"Give the average amount of",
            "chips from all played cards",
			"as {C:mult}+mult{}"
		}
	},
	set_badges = function(self, card, badges)
 		badges[#badges+1] = WeemColours.Sine()
 	end,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 1,


	atlas = 'KRis',

	pos = { x = 3, y = 0 },

	cost = 4,

	loc_vars = function(self, info_queue, card)  
	return { vars = { card.ability.money, card.ability.mult } }
	end,	
	calculate = function(self, card, context)
		if context.joker_main then
                --[[
				-- Checks to see if the id is an ace or face card,
				-- Otherwise return the id, as it is equal to the card's value
				local give_amount = context.other_card.base.nominal
				if (context.other_card.ability.effect == 'Stone Card') then
					give_amount = 0
				end
				-- Adds bonus chips either from bonus cards or perma_bonus
				give_amount = give_amount + context.other_card.ability.bonus + context.other_card.ability.perma_bonus
                ]]--


			return {
				mult = 20,
				message = "Sorry!!"
			}
		end
	end
}

-- Tier 2
SMODS.Joker {
	key = 'Sine2',

	loc_txt = {
		name = 'Coding Oversight',
		text = {
			"Cards give half of",
            "their total chips value",
			"as {C:mult}+mult{}"
		}
	},
	set_badges = function(self, card, badges)
 		badges[#badges+1] = WeemColours.Sine()
 	end,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 3,


	atlas = 'KRis',

	pos = { x = 3, y = 0 },

	cost = 8,

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
				mult = give_amount / 2,

				message = possible_messages[math.random(1, 8)]
			}
		end
	end
}


-- Tier 3
SMODS.Joker {

	key = 'Sine3',

	loc_txt = {
		name = 'Backdoor Opening',
		text = {
			"Cards give their total chips value",
			"as {C:mult}+mult{} and {C:money}$money{}"
			}
	},
	set_badges = function(self, card, badges)
 		badges[#badges+1] = WeemColours.Sine()
 	end,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	rarity = 4,


	atlas = 'KRis',

	pos = { x = 3, y = 0 },

	cost = 20,

	loc_vars = function(self, info_queue, card)  
	return { vars = { card.ability.money, card.ability.mult } }
	end,	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
				-- Checks to see if the id is an ace or face card,
				-- Otherwise return the id, as it is equal to the card's value
				local give_amount = context.other_card.base.nominal
				if (context.other_card.ability.effect == 'Stone Card') then
					give_amount = 0
				end
				-- Adds bonus chips either from bonus cards or perma_bonus
				give_amount = give_amount + context.other_card.ability.bonus + context.other_card.ability.perma_bonus
			return {
				mult = give_amount,
				dollars = give_amount,

				message = "Hehe!"
			}
		end
	end
}

---- Kris ----

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
	set_badges = function(self, card, badges)
 		badges[#badges+1] = WeemColours.Kris()
 	end,

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

---- Clover ----

-- Tier 1
SMODS.Joker {

	key = 'Clover1',

	loc_txt = {
		name = 'Clover in the Wind',
		text = {
			"{C:green}#1# in #2#{} chance to",
			"to give {C:mult}#3# mult{}",
			"per card played"
			}
	},
	set_badges = function(self, card, badges)
 		badges[#badges+1] = WeemColours.Clover()
 	end,

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { mult = 10, odds = 4 } },
	rarity = 1,

	atlas = 'KRis',

	pos = { x = 1, y = 0 },

	cost = 4,

	loc_vars = function(self, info_queue, card)
		return { vars = { (G.GAME.probabilities.normal), card.ability.extra.odds, card.ability.extra.mult  } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if pseudorandom('Clover1') < G.GAME.probabilities.normal / card.ability.extra.odds then
				return {
				mult = card.ability.extra.mult,
				message = 'Lucky!'
				}
			end
		end
	end
}


-- Tier 2
SMODS.Joker {

	key = 'Clover2',

	loc_txt = {
		name = '3 Leaf Clover',
		text = {
			"{C:green}#1# in #2#{} chance to",
			"to give {X:mult,C:white}x#3#{} {C:mult}mult{}",
			"per card played"
			}
	},
	set_badges = function(self, card, badges)
 		badges[#badges+1] = WeemColours.Clover()
 	end,

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
			if pseudorandom('Clover2') < G.GAME.probabilities.normal / card.ability.extra.odds then
				return {
				Xmult = card.ability.extra.xmult,
				message = 'Luckier!'
				}
			end
		end
	end
}

-- Tier 3
SMODS.Joker {

	key = 'Clover3',

	loc_txt = {
		name = '4 Leaf Clover',
		text = {
			"{C:green}#1# in #2#{} chance to",
			"to give {X:mult,C:white}x#3#{} {C:mult}mult{}",
			"per card played",
            "{C:green}#1# in #4#{} chance to",
            "to increase value by {X:mult,C:white}x#5#{}"
			}
	},
	set_badges = function(self, card, badges)
 		badges[#badges+1] = WeemColours.Clover()
 	end,

	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { xmult = 2, odds = 4, odds2 = 8, xinc = 1.2 } },
	rarity = 4,

	atlas = 'KRis',

	pos = { x = 1, y = 0 },

	cost = 20,

	loc_vars = function(self, info_queue, card)
		return { vars = { (G.GAME.probabilities.normal), card.ability.extra.odds, card.ability.extra.xmult, card.ability.extra.odds2, card.ability.extra.xinc  } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
            if pseudorandom('Clover32') < G.GAME.probabilities.normal / card.ability.extra.odds then
                card.ability.extra.xmult = card.ability.extra.xmult * card.ability.extra.xinc
            end
			if pseudorandom('Clover31') < G.GAME.probabilities.normal / card.ability.extra.odds then
				return {
				Xmult = card.ability.extra.xmult,
				message = 'Luckiest!'
				}
			end
		end
	end
}