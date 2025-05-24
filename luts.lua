-- All lookup tables here

Clover_Jokers = {
	'siffrin',
	'Clover1',
	'Clover2',
	'Clover3',
	'gift_clover',
}

WeemColours = {
	Kris = function() return create_badge('Kris', G.C.RED, G.C.WHITE, 1.2 ) end,
	Sine = function() return create_badge('Sine', G.C.YELLOW, G.C.BLACK, 1.2 ) end,
	Clover = function() return create_badge('Clover', G.C.BLUE, G.C.WHITE, 1.2 ) end,
	Azzy = function() return create_badge('Azzy', G.C.PURPLE, G.C.WHITE, 1.2 ) end,
	Ethan = function() return create_badge('Ethan', G.C.BLACK, G.C.WHITE, 1.2 ) end,
	Jade = function() return create_badge('Jade', G.C.ORANGE, G.C.WHITE, 1.2 ) end
}

UpgradeColours = {
	Upgrade = function() return create_badge('Upgradeable', G.C.BLACK, G.C.WHITE, 1.5 ) end,
	Tier1 = function() return create_badge('Tier 1', G.C.WHITE, G.C.BLACK, 1.2 ) end,
	Tier2 = function() return create_badge('Tier 2', G.C.WHITE, G.C.BLACK, 1.2 ) end,
	Tier3 = function() return create_badge('Tier 3', G.C.WHITE, G.C.BLACK, 1.2 ) end,
}