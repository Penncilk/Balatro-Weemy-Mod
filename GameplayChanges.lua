local function round(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces>0 then
    local mult = 10^numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

local function eulerscode(self, card, context)
    if (context.individual and context.cardarea == G.play and (context.other_card.base.value == "weem_E")) then
        -- times_played
        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
        if context.other_card.base.times_played <= 20 then
            if context.other_card.ability.perma_bonus <= 0 then
                context.other_card.ability.perma_bonus = 2.72
            else
                context.other_card.ability.perma_bonus = round(context.other_card.ability.perma_bonus * (2.72), 2)
            end
            return {
                extra = { message = localize('k_upgrade_ex'), colour = G.C.CHIPS },
                card = card
            }
        end

    end
end


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
        -- Add any changes into here, as a function
        eulerscode(self, card, context)
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

local runhook = Game.start_run
function Game:start_run(args)
    runhook(self, args)
    print("test")
    local saveTable = args.savetext or nil
    if not saveTable then
        --Put voucher in here
        local cardd = SMODS.create_card({set = 'Voucher', key = 'v_weem_weemtweaks'})
        cardd.ability.eternal = true
        cardd:redeem_no_pay()
        cardd:remove()
    end
end