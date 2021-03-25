require('lib/utils')

local STUN_MODIFIER			= "modifier_dissapear"			-- IMPORTANT, its stun that gets hero before change to other hero!
local RADIANT_BASE_POINT 	= "RADIANT_BASE"				-- Game teleport to this point before change hero
local DIRE_BASE_POINT 		= "DIRE_BASE"					-- Game teleport to this point before change hero

local forbidden_modifiers = {
	"modifier_shredder_chakram_disarm",
	"modifier_shredder_chakram_disarm_2",
	"modifier_shredder_chakram_2_disarm",
	"modifier_naga_siren_song_of_the_siren_aura",
	"modifier_followthrough",
}

local FIX_SKILLS = {
	["npc_dota_hero_riki"] 					= { "modifier_riki_permanent_invisibility" },
	["npc_dota_hero_weaver"] 				= { "modifier_weaver_geminate_attack" },
	["npc_dota_hero_keeper_of_the_light"] 	= { "modifier_keeper_of_the_light_spirit_form" },
	["npc_dota_hero_brewmaster"] 			= { "modifier_brewmaster_drunken_brawler" },
	["npc_dota_hero_tidehunter"] 			= { "modifier_tidehunter_kraken_shell" },
	["npc_dota_hero_lycan"] 				= { "modifier_lycan_feral_impulse_aura", "modifier_lycan_feral_impulse"},
	["npc_dota_hero_huskar"] 				= { "modifier_huskar_burning_spear_self", "modifier_huskar_berserkers_blood"},
	["npc_dota_hero_shredder"] 				= { "modifier_shredder_reactive_armor"},
	["npc_dota_hero_skeleton_king"] 		= { "modifier_skeleton_king_vampiric_aura", "modifier_skeleton_king_vampiric_aura_buff", "modifier_skeleton_king_mortal_strike", "modifier_skeleton_king_reincarnation"},
	["npc_dota_hero_abaddon"] 				= { "modifier_abaddon_frostmourne", "modifier_abaddon_borrowed_time_passive" },
	["npc_dota_hero_spirit_breaker"] 		= { "modifier_spirit_breaker_empowering_haste_aura", "modifier_spirit_breaker_empowering_haste"},
	["npc_dota_hero_elder_titan"]			= { "modifier_elder_titan_natural_order_aura"},
	["npc_dota_hero_omniknight"] 			= { "modifier_beastmaster_inner_beast_aura", "modifier_beastmaster_inner_beast"},
	["npc_dota_hero_earthshaker"] 			= { "modifier_earthsheker_aftershock" },
	["npc_dota_hero_bloodseeker"] 			= { "modifier_bloodseeker_thirst" },
	["npc_dota_hero_troll_warlord"]			= { "modifier_troll_warlord_fervor" },
	["npc_dota_hero_phantom_lance"]			= { "modifier_phantom_lancer_phantom_edge", "modifier_phantom_lancer_juxtapose" },
	["npc_dota_hero_nevermore"]				= { "modifier_nevermore_necromastery" },
	["npc_dota_hero_phantom_assassin"]		= { "modifier_phantom_assassin_blur", "modifier_phantom_assassin_blur_active", "modifier_phantom_assassin_coupdegrace" },
	["npc_dota_hero_luna"]					= { "modifier_luna_moon_glaive" },
	["npc_dota_hero_spectre"]				= { "modifier_spectre_spectral_dagger_path", "modifier_spectre_desolate", "modifier_spectre_dispersion" },
	["npc_dota_hero_bounty_hunter"]			= { "modifier_bounty_hunter_jinada"},
	["npc_dota_hero_broodmother"]			= { "modifier_broodmother_incapacitating_bite" },
	["npc_dota_hero_ursa"]					= { "modifier_ursa_fury_swipes" },
	["npc_dota_hero_viper"]					= { "modifier_viper_poison_attack", "modifier_viper_nethertoxin", "modifier_viper_corrosive_skin" },
	["npc_dota_hero_obsidian_destroyer"]	= { "modifier_obsidian_destroyer_arcane_orb"},
	["npc_dota_hero_enchantress"]			= { "modifier_enchantress_untouchable", "modifier_enchantress_impetus" },
	["npc_dota_hero_storm_spirit"]			= { "modifier_storm_spirit_overload_passive" },
	["npc_dota_hero_necrolyte"]				= { "modifier_necrolyte_sadist" },
}

function _HasForbiddenModifier(unit)
	for _, modifier_name in pairs(forbidden_modifiers) do
		if unit:HasModifier(modifier_name) then
			return true
		end
	end

	return false
end

function _MoveToBase(unit)
	local point

	if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		point =  Entities:FindByName( nil, RADIANT_BASE_POINT ):GetAbsOrigin()
	elseif unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		point =  Entities:FindByName( nil, DIRE_BASE_POINT ):GetAbsOrigin()
	end
	
	if not point then return end

	FindClearSpaceForUnit(unit, point, false)

	unit:Stop()
end

function _DeleteAllControlUnits(player, unit_name)
	local all = Entities:FindAllByName(unit_name) 

	for i,x in pairs(all) do
		if x:GetPlayerOwner() == player then
			UTIL_Remove(x)
		end
	end
end

function ChangeHero(player, oldHero, newHeroName, successCallback, failedCallback, checkFunction, repickItemName)
	local playerid = player:GetPlayerID() 
	local hMod = oldHero:AddNewModifier(oldHero, nil, STUN_MODIFIER, {duration = -1}) -- stun is infinite

	-- wish i has a RAII here, but no
	local newFailedCallback = function()
		hMod:Destroy()
		failedCallback()
	end

	PrecacheUnitByNameAsync(newHeroName, function()
		local cantPick = ( not IsConnected(oldHero) ) or (player.crash_timer ~= nil) or _HasForbiddenModifier(oldHero) or not checkFunction();

		if cantPick then
			newFailedCallback()
			return 
		end

		_MoveToBase(oldHero)

		if oldHero:HasAbility("life_stealer_assimilate") then
			local heroes = HeroList:GetAllHeroes() 
			for _, hero in pairs(heroes) do
				hero:RemoveModifierByName("modifier_life_stealer_assimilate")
			end
		end

		if oldHero:HasAbility("lone_druid_spirit_bear") then 
			oldHero:RemoveAbility("lone_druid_spirit_bear")
		end

		if oldHero:GetUnitName() == "npc_dota_hero_arc_warden" then
			local all = Entities:FindAllByName("npc_dota_hero_arc_warden") 
			for i,x in pairs(all) do
				if x:HasModifier("modifier_arc_warden_tempest_double") and x:GetPlayerOwner() == player then
					UTIL_Remove(x)
				end
			end
		end

		if oldHero:GetUnitName() == "npc_dota_hero_visage" then
			_DeleteAllControlUnits(player, "npc_dota_visage_familiar")
		end

		if oldHero:GetUnitName() == "npc_dota_hero_batrider" then
			_DeleteAllControlUnits(player, "npc_custom_unit_hawk")
		end

		if oldHero:GetUnitName() == "npc_dota_hero_earth_spirit" then
			_DeleteAllControlUnits(player, "npc_dota_earth_spirit_stone")
		end

		if oldHero:GetUnitName() == "npc_dota_hero_broodmother" then
			_DeleteAllControlUnits(player, "npc_dota_broodmother_web")
		end

		if oldHero:GetUnitName() == "npc_dota_hero_lone_druid" then
			_DeleteAllControlUnits(player, "npc_dota_lone_druid_bear")
		end

		local item_table = {}

		for i = 0, 17 do
			local item = oldHero:GetItemInSlot(i)

			if item then
				if item:GetName() == repickItemName then
					oldHero:RemoveItem(item)
				else
					item = oldHero:TakeItem(item)

					if item:GetPurchaser() == oldHero then
						item:SetPurchaser(nil)
					end

					table.insert(item_table, item)
				end
			end
		end

		local gold = oldHero:GetGold() or 0

		local hero = PlayerResource:ReplaceHeroWith( playerid, newHeroName, gold, 0 )

		UTIL_Remove(oldHero)

		-- Remove any item from Valve that gives to new heroes
		for i = 0, 17 do
			item = hero:GetItemInSlot(i)

			if item then
				hero:RemoveItem(item)
			end
		end 

		for _, item in pairs(item_table) do
			if item:GetPurchaser() == nil then
				item:SetPurchaser(hero)
			end

			hero:AddItem(item)
		end

		hero:SetAbilityPoints(1)
		
		_MoveToBase(hero)

		if FIX_SKILLS[newHeroName] then
			for _, modifier_to_remove in pairs(FIX_SKILLS[newHeroName]) do
				hero:RemoveModifierByName(modifier_to_remove)
			end
		end

		successCallback()
	end)
end