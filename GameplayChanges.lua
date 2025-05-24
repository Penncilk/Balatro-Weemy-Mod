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
        self.states.hover.can = false
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
    if not saveTable then
        local cardd = SMODS.create_card({set = 'Voucher', key = 'v_weem_weemtweaks'})
        cardd.ability.eternal = true
        cardd:redeem_no_pay()
        cardd:remove()
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