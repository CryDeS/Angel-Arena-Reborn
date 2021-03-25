LinkLuaModifier( "modifier_summon",'modifiers/heroes/modifier_summon', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_broodmother_spiders", 'modifiers/heroes/modifier_broodmother_spiders', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shadowshaman_wards", 'modifiers/heroes/modifier_shadowshaman_wards', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_warlock_golems", 'modifiers/heroes/modifier_warlock_golems', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_witch_doctor_ward", 'modifiers/heroes/modifier_witch_doctor_ward', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_summon_venomancer", 'modifiers/heroes/modifier_summon_venomancer', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_summon_undying", 'modifiers/heroes/modifier_summon_undying', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_visage_familiars", 'modifiers/heroes/modifier_visage_familiars', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_summon_plague_ward", 'modifiers/heroes/modifier_summon_plague_ward', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_summon_eidolon", 'modifiers/heroes/modifier_summon_eidolon', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lycan_wolfes", 'modifiers/heroes/modifier_lycan_wolfes', LUA_MODIFIER_MOTION_NONE )


local armor_when_spawn_table = {
	["npc_dota_brewmaster_earth_1"] 		= "modifier_summon",
	["npc_dota_brewmaster_earth_2"] 		= "modifier_summon",
	["npc_dota_brewmaster_earth_3"] 		= "modifier_summon",
	
	["npc_dota_brewmaster_storm_1"] 		= "modifier_summon",
	["npc_dota_brewmaster_storm_2"] 		= "modifier_summon",
	["npc_dota_brewmaster_storm_3"] 		= "modifier_summon",
	
	["npc_dota_brewmaster_fire_1"] 			= "modifier_summon", 
	["npc_dota_brewmaster_fire_2"] 			= "modifier_summon", 
	["npc_dota_brewmaster_fire_3"] 			= "modifier_summon",
	
	["npc_dota_warlock_golem_1"] 			= "modifier_warlock_golems",
	["npc_dota_warlock_golem_2"] 			= "modifier_warlock_golems",
	["npc_dota_warlock_golem_3"] 			= "modifier_warlock_golems",
	["npc_dota_warlock_golem_4"] 			= "modifier_warlock_golems",
	["npc_dota_warlock_golem_5"] 			= "modifier_warlock_golems",
	["npc_dota_warlock_golem_6"] 			= "modifier_warlock_golems",
	["npc_dota_warlock_golem_7"] 			= "modifier_warlock_golems",
	
	["npc_dota_warlock_golem_scepter_1"] 	= "modifier_warlock_golems",
	["npc_dota_warlock_golem_scepter_2"] 	= "modifier_warlock_golems",
	["npc_dota_warlock_golem_scepter_3"] 	= "modifier_warlock_golems",
	["npc_dota_warlock_golem_scepter_4"] 	= "modifier_warlock_golems",
	["npc_dota_warlock_golem_scepter_5"] 	= "modifier_warlock_golems",
	["npc_dota_warlock_golem_scepter_6"] 	= "modifier_warlock_golems",
	["npc_dota_warlock_golem_scepter_7"] 	= "modifier_warlock_golems",

	["npc_dota_necronomicon_warrior_1"] 	= "modifier_summon",
	["npc_dota_necronomicon_warrior_2"] 	= "modifier_summon",
	["npc_dota_necronomicon_warrior_3"] 	= "modifier_summon",
	
	["npc_dota_necronomicon_archer_1"] 		= "modifier_summon",
	["npc_dota_necronomicon_archer_2"] 		= "modifier_summon",
	["npc_dota_necronomicon_archer_3"]		= "modifier_summon",

	["npc_dota_invoker_forged_spirit"]		= "modifier_summon",

	["npc_aa_ancient_hulk"]					= "modifier_summon",
	["npc_aa_ancient_mage"]					= "modifier_summon",
	["npc_aa_ancient_wolf"]					= "modifier_summon",

	["npc_dota_venomancer_plague_ward_1"]	= "modifier_summon_venomancer",
	["npc_dota_venomancer_plague_ward_2"]	= "modifier_summon_venomancer",
	["npc_dota_venomancer_plague_ward_3"]	= "modifier_summon_venomancer",
	["npc_dota_venomancer_plague_ward_4"]	= "modifier_summon_venomancer",
	["npc_dota_venomancer_plague_ward_5"]	= "modifier_summon_venomancer",
	["npc_dota_venomancer_plague_ward_6"]	= "modifier_summon_venomancer",
	["npc_dota_venomancer_plague_ward_7"]	= "modifier_summon_venomancer",

	["npc_dota_lycan_wolf1"]				= "modifier_lycan_wolfes",
	["npc_dota_lycan_wolf2"]				= "modifier_lycan_wolfes",
	["npc_dota_lycan_wolf3"]				= "modifier_lycan_wolfes",
	["npc_dota_lycan_wolf4"]				= "modifier_lycan_wolfes",
	["npc_dota_lycan_wolf5"]				= "modifier_lycan_wolfes",
	["npc_dota_lycan_wolf6"]				= "modifier_lycan_wolfes",
	["npc_dota_lycan_wolf7"]				= "modifier_lycan_wolfes",

	["npc_dota_furion_treant_1"]				= "modifier_summon",
	["npc_dota_furion_treant_2"]				= "modifier_summon",
	["npc_dota_furion_treant_3"]				= "modifier_summon",
	["npc_dota_furion_treant_4"]				= "modifier_summon",
	["npc_dota_furion_treant_5"]				= "modifier_summon",
	["npc_dota_furion_treant_6"]				= "modifier_summon",
	["npc_dota_furion_treant_7"]				= "modifier_summon",
	["npc_dota_furion_treant_large"]		= "modifier_summon",
	["npc_dota_witch_doctor_death_ward"]	= "modifier_witch_doctor_ward",

	["npc_dota_shadow_shaman_ward_1"]		= "modifier_shadowshaman_wards",
	["npc_dota_shadow_shaman_ward_2"]		= "modifier_shadowshaman_wards",
	["npc_dota_shadow_shaman_ward_3"]		= "modifier_shadowshaman_wards",

	["npc_dota_broodmother_spiderling"]		= "modifier_broodmother_spiders",
	["npc_dota_broodmother_spiderite"]		= "modifier_broodmother_spiders",

	["npc_dota_beastmaster_boar"]			= "modifier_summon",
	["npc_dota_beastmaster_greater_boar"]	= "modifier_summon",
	["npc_dota_beastmaster_boar_1"]			= "modifier_summon",
	["npc_dota_beastmaster_boar_2"]			= "modifier_summon",
	["npc_dota_beastmaster_boar_3"]			= "modifier_summon",
	["npc_dota_beastmaster_boar_4"]			= "modifier_summon",

	["npc_dota_unit_undying_zombie"]		= "modifier_summon_undying",
	["npc_dota_unit_undying_zombie_torso"]	= "modifier_summon_undying",


	["npc_eidolon_1"] 			= "modifier_summon_eidolon",
	["npc_eidolon_2"] 			= "modifier_summon_eidolon",
	["npc_eidolon_3"] 			= "modifier_summon_eidolon",
	["npc_eidolon_4"] 			= "modifier_summon_eidolon",
	["npc_eidolon_5"] 			= "modifier_summon_eidolon",
	["npc_eidolon_6"] 			= "modifier_summon_eidolon",
	["npc_eidolon_7"] 			= "modifier_summon_eidolon",

	["npc_dota_venomancer_plague_ward_1"] = "modifier_summon_plague_ward",
	["npc_dota_venomancer_plague_ward_2"] = "modifier_summon_plague_ward",
	["npc_dota_venomancer_plague_ward_3"] = "modifier_summon_plague_ward",
	["npc_dota_venomancer_plague_ward_4"] = "modifier_summon_plague_ward",
	["npc_dota_venomancer_plague_ward_5"] = "modifier_summon_plague_ward",
	["npc_dota_venomancer_plague_ward_6"] = "modifier_summon_plague_ward",
	["npc_dota_venomancer_plague_ward_7"] = "modifier_summon_plague_ward",

	["npc_dota_visage_familiar1"] 			= "modifier_visage_familiars",
	["npc_dota_visage_familiar2"] 			= "modifier_visage_familiars",
	["npc_dota_visage_familiar3"] 			= "modifier_visage_familiars",

	["npc_dota_wraith_king_skeleton_warrior"] = "modifier_summon"


}

return armor_when_spawn_table