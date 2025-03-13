function resetItems() 
	for _, v in pairs(ITEM_MAPPING) do
		if v then
			local obj = Tracker:FindObjectForCode(v)
			if obj then
				obj.Active = false
			end
		end
	end
end

function resetLocations() 
	for _, v in pairs(LOCATION_MAPPING) do
		if v then
			local obj = Tracker:FindObjectForCode(v)
			if obj then
				obj.AvailableChestCount = 1
			end
		end
	end
end

MAP_TOGGLE={[0]=0,[1]=1}
MAP_TRIPLE={[0]=0,[1]=1,[2]=2}
MAP_TOGGLE_REVERSE={[0]=1,[1]=0}

MAP_FREEFLY={
	[0]=0,
	[FLY_ECRUTEAK]=1,
	[FLY_OLIVINE]=2,
	[FLY_CIANWOOD]=3,
	[FLY_MAHOGANY]=4,
	[FLY_BLACKTHORN]=5,
	[FLY_VIRIDIAN]=6,
	[FLY_PEWTER]=7,
	[FLY_CERULEAN]=8,
	[FLY_VERMILION]=9,
	[FLY_LAVENDER]=10,
	[FLY_CELADON]=11,
	[FLY_SAFFRON]=12,
	[FLY_FUCHSIA]=13,
}
-- MAP_BADGES={}
-- for i=0,8 do MAP_BADGES[i]=i end

SLOT_CODES = {
	randomize_hidden_items={
		code="hiddenitems", 
		mapping=MAP_TOGGLE
	},
	-- elite_four_badges={
	-- 	code="e4_badges", 
	-- 	mapping=MAP_BADGES
	-- },
	-- red_badges={
	-- 	code="red_badges", 
	-- 	mapping=MAP_BADGES
	-- },
	goal={
		code="goal", 
		mapping=MAP_TOGGLE
	},
	randomize_badges={
		code="badges", 
		mapping=MAP_TRIPLE
	},
	randomize_pokegear={
		code="pokegear", 
		mapping=MAP_TOGGLE
	},
	trainersanity={
		code="trainersanity", 
		mapping=MAP_TOGGLE
	},
	hm_badge_requirements={
		code="badgereqs", 
		mapping=MAP_TRIPLE
	},
	require_itemfinder={
		code="reqitemfinder", 
		mapping=MAP_TOGGLE_REVERSE
	},
	johto_only={
		code="johto_only", 
		mapping=MAP_TRIPLE
	},
	free_fly_location={
		code="free_fly",
		mapping=MAP_FREEFLY
	},
	map_card_fly_location={
		code="map_card_fly",
		mapping=MAP_FREEFLY
	},
	randomize_berry_trees={
		code="berries",
		mapping=MAP_TOGGLE
	},
	ilex_cut_tree={
		code="ilextree",
		mapping=MAP_TOGGLE
	},
	route_32_condition={
		code="r32_guy",
		mapping=MAP_TRIPLE
	}
}
