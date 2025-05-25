local WeemFix = {}

-------- WRITE FUNCTIONS HERE --------

-- Allows euler's number to grow exponentially
function WeemFix.eulerscode(self, card, context)
    if (context.individual and context.cardarea == G.play) then
        if (context.other_card.base.value == "weem_E") then
            -- Built in counter for Euler's Usage
            context.other_card.ability.eulered = context.other_card.ability.eulered or 0
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
            -- Limiting the max values
            if context.other_card.ability.eulered <= 24 then
                if context.other_card.ability.perma_bonus <= 0 then
                    context.other_card.ability.perma_bonus = 2.72
                else
                    context.other_card.ability.perma_bonus = round(context.other_card.ability.perma_bonus * (2.72), 2)
                end
                context.other_card.ability.eulered = context.other_card.ability.eulered + 1
                return {
                    extra = { message = localize('k_upgrade_ex'), colour = G.C.CHIPS },
                    card = card
                }
            end
        end
    end
end


-------- VOUCHER CODE HERE --------

SMODS.Voucher {
    key = 'weemtweaks',
    loc_txt = {
        label = 'Weemy Tweaks',
        name = 'Weemy Tweaks',
        text = {"A few base editions to", "Balatro to add to", "the experence."}
    },
    atlas = "weemyfix",
    pos = {x=0, y=0},
    calculate = function(self, card, context)
        for _, i in pairs(WeemFix) do
            i(self, card, context)
        end
    end
}

-- Lets you just *add* a voucher
function Card:redeem_no_pay()
    if self.ability.set == "Voucher" then
        if not self.config.center.discovered then
            discover_card(self.config.center)
        end
        G.GAME.used_vouchers[self.config.center_key] = true
        set_voucher_usage(self)
        check_for_unlock({type = 'run_redeem'})
        self:apply_to_run()
    end
end

-- Hooks into the start run code
local runhook = Game.start_run
function Game:start_run(args)
    runhook(self, args)
    -- Makes sure its a new game, and not a continued one
    -- BECUASE I DON'T WANNA DEAL WITH THOSE EDGE CASES
    local saveTable = args.savetext or nil
    G.GAME.addedWeemy = G.GAME.addedWeemy or false
    if not saveTable then
        if G.GAME.addedWeemy == false then
            local card = SMODS.create_card({set = 'Voucher', key = 'v_weem_weemtweaks'})
            card.ability.eternal = true
            card:redeem_no_pay()
            card:remove()
            G.GAME.addedWeemy = true
        end
        
    end
end

-- I Wanted to round things ok?
local function round(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces>0 then
    local mult = 10^numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

-- UI HOOKS

local old_cuibhud = create_UIBox_HUD
function create_UIBox_HUD()

    local scale = 0.4
    local spacing = 0.13
    local temp_col = G.C.DYN_UI.BOSS_MAIN
    local temp_col2 = G.C.DYN_UI.BOSS_DARK
    
    local newui = {
        -- Motivation UI
        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 1.1, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "cm", minh = 0.33, maxw = 0.9}, nodes={
            {n=G.UIT.T, config={text = 'Motiv', scale = 0.85*scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.R, config={align = "cm", r = 0.1, minw = 0.8, colour = temp_col2}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'discards_left'}}, font = G.LANGUAGES['en-us'].font, colours = {G.C.ORANGE},shadow = true, rotate = true, scale = 2*scale}),id = 'discard_UI_count'}},
            }}
            }},
        }},
        -- Spacing
        {n=G.UIT.C, config={minw = spacing},nodes={}},

        -- Updated Dollars UI
        {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 1.75 + spacing, minh = 1.15, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.C, config={align = "cm", r = 0.1, minw = 1.50+spacing, minh = 1, colour = temp_col2}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'dollars', prefix = localize('$')}}, maxw = 1.35, colours = {G.C.MONEY}, font = G.LANGUAGES['en-us'].font, shadow = true,spacing = 2, bump = true, scale = 2.2*scale}), id = 'dollar_text_UI'}}
            }},
            }},
        }},
    }

    local curui = old_cuibhud()
    curui.nodes[1].nodes[1].nodes[#curui.nodes[1].nodes[1].nodes].nodes[2].nodes[3].nodes = newui

    return curui
end