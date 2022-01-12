--[[
-----------------------------------------
Creator: CryDeS
If somebody read this, KILL ME PLEASE
-----------------------------------------
]]

require('lib/utils')

require('tp_s')
require('lib/teleport')
require('lib/duel/duel_controller')
require('lib/gpm_lib')
require('lib/percent_damage')
require('lib/panorama_pings')
require('lib/captains_mode')
require('lib/spawners/creep_spawner')
require('lib/spawners/creep_leveling')
require('lib/timers')
require('lib/item_precache')
require('lib/attentions')
require('lib/chat_listener')
require('lib/debug/geometrics')
require('lib/neutral_slot')
require('lib/repick_menu')
require('lib/comeback_system')
require('lib/move_limiter')
require('lib/boss/boss_spawner')
require('lib/custom_modifiers/custom_modifiers')
require('lib/team_helper')
require('lib/game_ender')
require('lib/connection_helpers')
require('lib/output_redirect')

-- Список модулей которые нужно загружать в InitGameMode, а не при создании VM'ки 
local postRequireList = {
	'lib/base/player',
	'lib/base/base_npc'
}

local Constants = require('consts') -- XP TABLE
local armor_table = require('creeps/armor_table_summon') -- armor to units

local MP_REGEN_PER_INT = 0.4

RESPAWN_MODIFER = 0.135
GOLD_PER_TICK = 4

KILL_LIMIT = 100

GOLD_FOR_COUR = 350

_G.Kills = {}
_G.KILL_LIMIT  = KILL_LIMIT

local is_game_start = false
local is_game_end = false
local game_start_for_courier = false

local crash_abilities = {
	["shadow_demon_disruption"] = 1,
	["obsidian_destroyer_astral_imprisonment"] = 1,
	["rubick_telekinesis"] = 1,
	["disruptor_thunder_strike"] = 1,
}

local forbidden_ability_boss = {
	["life_stealer_infest"] = 1,
	["chen_holy_persuasion"] = 1,
	["enchantress_enchant"] = 1,
	["item_devour_helm"] = 1,
	["item_iron_talon"] = 1,
	["night_stalker_hunter_in_the_night"] = 1,
	["snapfire_spit_creep"] = 1,
	["juggernaut_omni_slash"] = 1,
	["snapfire_gobble_up"] = 1,
}

local forbidden_items_for_clones = {
	["item_pet_hulk"] = 1,
	["item_pet_mage"] = 1,
	["item_pet_wolf"] = 1,
	["item_refresher"] = 1,
	["item_recovery_orb"] = 1,
	["item_devour_helm"] = 1,
}

local illusion_bug_crash =
{
	["npc_dota_hero_dawnbreaker"] = 1,
	["npc_dota_hero_visage"] = 1,
	["npc_dota_hero_weaver"] = 1,
}

if AngelArena == nil then
	_G.AngelArena = class({})
	AngelArena.DeltaTime = 0.5
end

function Activate()
	GameRules.AngelArena = AngelArena()
	GameRules.AngelArena:InitGameMode()
end

function Precache(context)
	DuelController:Precache(context)
	ItemPrecache:Precache(context)
end

function AngelArena:InitGameMode()
	for _, moduleName in pairs(postRequireList) do
		require(moduleName)
	end

	Convars:SetInt("dota_max_physical_items_purchase_limit", 100)

	local GameMode = GameRules:GetGameModeEntity()

	GameRules:SetCustomVictoryMessage("#aa_on_win_message")

	--GameRules:SetSafeToLeave(true)

	GameRules:SetPreGameTime(60) -- old 90

	if GetMapName() == "map_5x5_cm" then
		GameRules:SetHeroSelectionTime(50)
		GameRules:SetStrategyTime(10)
	else
		GameMode:SetDraftingHeroPickSelectTimeOverride(60)
		GameMode:SetDraftingBanningTimeOverride(20)
		GameRules:SetStrategyTime(15.0)
		GameRules:SetHeroSelectionTime(90) -- old 60
	end

	GameMode:SetCustomBackpackSwapCooldown(4.0)
	GameRules:SetPostGameTime(30)

	if GameRules:IsCheatMode() then
		GameRules:SetHeroSelectionTime(25)
		GameRules:SetStrategyTime(1)
		GameMode:SetDraftingHeroPickSelectTimeOverride(25)
		GameMode:SetDraftingBanningTimeOverride(0)
	end

	GameRules:SetGoldPerTick(GOLD_PER_TICK)

	GameRules:SetHeroRespawnEnabled(true)
	GameRules:SetGoldTickTime(1)
	GameRules:SetShowcaseTime(0.0)
	GameRules:SetTreeRegrowTime(180)
	GameRules:SetUseBaseGoldBountyOnHeroes(true)
	GameMode:SetBountyRuneSpawnInterval(120.0)
	GameRules:SetRuneSpawnTime(120)
	for i = 0, 11 do
		GameMode:SetRuneEnabled(i, true)
	end

	--GameRules:SetRuneSpawnTime(120)

	GameRules:SetCustomGameEndDelay(1)
	GameMode:SetFountainPercentageHealthRegen(7)
	GameMode:SetFountainPercentageManaRegen(10)
	GameMode:SetFountainConstantManaRegen(20)
	GameMode:SetUseCustomHeroLevels(true)
	GameMode:SetCustomXPRequiredToReachNextLevel(Constants.XP_PER_LEVEL_TABLE)
	GameMode:SetFreeCourierModeEnabled( true )
	--GameMode:SetTopBarTeamValuesVisible(false)
	GameMode:SetBuybackEnabled(true)
	GameMode:SetStashPurchasingDisabled(false)
	GameMode:SetLoseGoldOnDeath(true)
	--GameMode:SetTopBarTeamValuesOverride ( true )
	--GameMode:SetTopBarTeamValuesVisible( true )
	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetSameHeroSelectionEnabled(false)
	GameRules:SetCustomGameAllowMusicAtGameStart( true )
	GameRules:SetStartingGold(625)
	GameRules:SetCustomGameBansPerTeam(5)
	GameRules:SetCreepSpawningEnabled( false )

	-- AttributeDerivedStats
	--GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_MAGIC_RESISTANCE_PERCENT, 0)
	--GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_STATUS_RESISTANCE_PERCENT, 0)
	--GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN, 0)
	--GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_MOVE_SPEED_PERCENT, 0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN, MP_REGEN_PER_INT)
	
	GameMode:SetCustomBackpackCooldownPercent(1)
	--GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MAGIC_RESISTANCE_PERCENT, 0)

	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 5)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 5)

	--################################## BASE LISTENERS ############################################### --
	ListenToGameEvent("dota_player_pick_hero", Safe_Wrap(AngelArena, "OnHeroPicked"), self)
	ListenToGameEvent("entity_killed", Safe_Wrap(AngelArena, "OnEntityKilled"), self)
	ListenToGameEvent('game_rules_state_change', Safe_Wrap(AngelArena, 'OnGameStateChange'), self)
	ListenToGameEvent('player_connect_full', Safe_Wrap(AngelArena, 'OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Safe_Wrap(AngelArena, 'OnPlayerDisconnect'), self)
	ListenToGameEvent('npc_spawned', Safe_Wrap(AngelArena, 'OnNPCSpawned'), self)
	ListenToGameEvent('dota_item_picked_up', Safe_Wrap(AngelArena, 'OnPickUpItem'), self)
	ListenToGameEvent('dota_rune_activated_server', Safe_Wrap(AngelArena, 'OnRuneActivate'), self)
	ListenToGameEvent('dota_player_used_ability', Safe_Wrap(AngelArena, 'OnPlayerUsedAbility'), self)
	ListenToGameEvent('dota_item_purchased', Safe_Wrap(AngelArena, 'OnPlayerBuyItem'), self)
	ListenToGameEvent('dota_player_gained_level', Safe_Wrap(AngelArena, 'OnLevelUp'), self)

	ListenToGameEvent("player_chat", Safe_Wrap(ChatListener, 'OnPlayerChat'), ChatListener)

	PlayerResource:ClearOnAbandonedCallbacks()
	PlayerResource:RegisterOnAbandonedCallback(function(arg) AngelArena:OnAbandoned(arg) end)

	--################################## BASE MODIFIERS ############################################### --
	LinkLuaModifier("modifier_full_disable_stun", 'modifiers/modifier_full_disable_stun', LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_hidden_from_map", 'modifiers/modifier_hidden_from_map', LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_dissapear", 'modifiers/modifier_dissapear', LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_stop", 'modifiers/modifier_stop', LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_medical_tractate", 'modifiers/modifier_medical_tractate', LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_godmode", 'modifiers/modifier_godmode', LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_courier", 'modifiers/modifier_courier', LUA_MODIFIER_MOTION_NONE)

	if GameRules:IsCheatMode() then
		require('lib/debug/keyexec')
		KeyExec:Init()
	end

	--########################################## FILTERS ############################################### --

	GameMode:SetExecuteOrderFilter(Safe_Wrap(AngelArena, "OrderFilter"), self)
	GameMode:SetModifyGoldFilter(Safe_Wrap(AngelArena, "GoldFilter"), self)
	GameMode:SetDamageFilter(Safe_Wrap(AngelArena, "DamageFilter"), self)
	GameMode:SetModifyExperienceFilter(Safe_Wrap(AngelArena, "ModifierExpirience"), self)
	GameMode:SetRuneSpawnFilter(Safe_Wrap(AngelArena, "ModifierRuneSpawn"), self)
	GameMode:SetItemAddedToInventoryFilter(Safe_Wrap(AngelArena, "ItemAddedToInventoryFilter"), self)
	GameMode:SetModifierGainedFilter(Safe_Wrap(AngelArena, "ModifierGainedFilter"), self)

	GameMode:SetCustomRadiantScore(0)
	GameMode:SetCustomDireScore(0)
	_G.Kills[DOTA_TEAM_GOODGUYS] = _G.Kills[DOTA_TEAM_GOODGUYS] or 0
	_G.Kills[DOTA_TEAM_BADGUYS] = _G.Kills[DOTA_TEAM_BADGUYS] or 0

	AngelArena:OnGameStateChange()

	SendToConsole("dota_shop_recommended_open 1")
	CreepSpawner:Init()
	BossSpawner:Init()
	Attentions:SetKillLimit( KILL_LIMIT )

	CreepSpawner:RegisterOnSpawnCallback(function(arg) CreepLeveling:OnSpawnCallback(arg); end)
	CreepSpawner:RegisterOnDeathCallback(function(arg) CreepLeveling:OnDeathCallback(arg); end)
end

function AngelArena:OnAbandoned(arg)
	local playerid = arg.playerid

	local abaddonTeam = PlayerResource:GetTeam(playerid)
	local heroTeam = nil

	if abaddonTeam == DOTA_TEAM_GOODGUYS then
		heroTeam = DOTA_TEAM_BADGUYS
	elseif abaddonTeam == DOTA_TEAM_BADGUYS then
		heroTeam = DOTA_TEAM_GOODGUYS
	else
		return
	end

	local kills = _G.Kills[heroTeam] or 0
	local diff = (KILL_LIMIT - kills)

	local heroes = PlayerResource:GetHeroes(abaddonTeam)

	local connectedHeroes = 0

	for pid, hero in pairs(heroes) do
		if not (PlayerResource:IsAbandoned(pid) and hero:GetTeamNumber() == abaddonTeam) then
			connectedHeroes = connectedHeroes + 1
		end
	end
	if connectedHeroes == 0 then return end

	kills = kills + math.ceil(diff / (connectedHeroes + 1))

	if kills > KILL_LIMIT then return end

	_G.Kills[heroTeam] = kills

	local GameMode = GameRules:GetGameModeEntity()

	GameMode:SetCustomDireScore( _G.Kills[DOTA_TEAM_BADGUYS] )
	GameMode:SetCustomRadiantScore( _G.Kills[DOTA_TEAM_GOODGUYS] )
end

function AngelArena:ModifierRuneSpawn(keys)
	function Almostequal(value1, value2, epsilon)
		return math.abs(value1 - value2) < epsilon
	end
	local rune_type = keys.rune_type
	
	if rune_type == 5 then return true end

	local runes = { 0, 1, 2, 3, 4, 6 }

	local Dotatime = GameRules:GetDOTATime(false, false)
	if Almostequal(120, Dotatime, 1) or Almostequal(240, Dotatime, 1) then 
		keys.rune_type = 7
	else
		keys.rune_type = runes[RandomInt(1, #runes)]	
	end
	print (Dotatime)
	return true
end

function AngelArena:OnPlayerDisconnect(event)
	local name = event.name
	local networkid = event.networkid
	local reason = event.reason
	local userid = event.userid
end

function AngelArena:ItemAddedToInventoryFilter(event)
	if not event.item_entindex_const then return end
	if not event.inventory_parent_entindex_const then return end
	local hItem = EntIndexToHScript(event.item_entindex_const)

	if not hItem or hItem:IsNull() then return true end

	local hUnit = EntIndexToHScript(event.inventory_parent_entindex_const)
	if not hUnit then return true end
	if hUnit:IsNull() then return end
	if hUnit:IsCourier() then return true end

	if NeutralSlot:NeedToNeutralSlot( hItem:GetName() ) then
		local slotIndex = NeutralSlot:GetSlotIndex()
		local itemInSlot = hUnit:GetItemInSlot(slotIndex)

		if not itemInSlot then
			-- just practical heuristic, when hero take item from another unit/from ground event.item_parent_entindex_const != event.inventory_parent_entindex_const
			-- never ask me about this dirty hack.
			local isStash = event.item_parent_entindex_const == event.inventory_parent_entindex_const

			if not isStash or hUnit:IsInRangeOfShop(DOTA_SHOP_HOME, true) then
				event.suggested_slot = NeutralSlot:GetSlotIndex()
			end
		end
	end

	if hItem.ForceShareable then
		hItem:SetPurchaser( hUnit )
	end

	return true
end

function AngelArena:GoldFilter(event)
	ComebackSystem:OnGiveGold( event.player_id_const, event.gold, event.reliable, event.reason_const )

	return true
end

function AngelArena:SaveGoldForPlayerId(playerid)
	if not PlayerResource:IsValidPlayerID(playerid) then return end

	local player_gold = PlayerResource:GetGold(playerid)

	local tPlayers = self.tPlayers

	if not tPlayers then
		tPlayers = {}
		self.tPlayers = tPlayers
	end

	if not IsAbadonedPlayerID(playerid) then
		tPlayers[playerid] = tPlayers[playerid] or {} -- nil error exception
		tPlayers[playerid].gold = tPlayers[playerid].gold or 0 -- nil error exception

		if player_gold > 80000 then
			local gold_to_save = player_gold - 80000
			tPlayers[playerid].gold = tPlayers[playerid].gold + gold_to_save
			PlayerResource:SpendGold(playerid, gold_to_save, 0)
		end

		if player_gold < 80000 then
			local free_gold = 80000 - player_gold
			local total_saved_gold = tPlayers[playerid].gold
			if total_saved_gold > free_gold then
				tPlayers[playerid].gold = tPlayers[playerid].gold - free_gold
				PlayerResource:ModifyGold(playerid, free_gold, true, 0)
			else
				PlayerResource:ModifyGold(playerid, total_saved_gold, true, 0)
				tPlayers[playerid].gold = 0
			end
		end

		local total_gold = PlayerResource:GetGold(playerid) + tPlayers[playerid].gold -- почему не player_gold? потому что золото игрока изменилось, а эта переменная нет :c

		CustomNetTables:SetTableValue("gold", "player_id_" .. playerid, { gold = total_gold })
	end
end

function AngelArena:OrderFilter(event)
	local order_type = event.order_type
	local iAbility = event.entindex_ability
	local units_table = event.units
	local player_id = event.issuer_player_id_const
	local player = PlayerResource:GetPlayer(player_id)
	local remove_tbl_idx = {}
	local unit
	if event.units and event.units["0"] then
		unit = EntIndexToHScript(event.units["0"])
	end
	
	if player and player:GetAssignedHero() and player:GetAssignedHero():HasModifier("modifier_banned_custom") then return false end

	if units_table and type(units_table) == "table" and player and not GameRules:IsCheatMode() then
		for idx, entUnit in pairs(units_table) do
			local unit = EntIndexToHScript(entUnit)

			if player:GetTeamNumber() ~= unit:GetTeamNumber() then 
				remove_tbl_idx[idx] = true
			end

			if (unit.personal) then
				if (player_id ~= unit.personal and not (PlayerResource:AreUnitsSharedWithPlayerID(unit.personal, player_id))) then
					remove_tbl_idx[idx] = true
				end
			end
		end
	end

	for idx, _ in pairs(remove_tbl_idx) do
		local unit_s = event["units"]

		table.remove(unit_s, unit_s["0"])
		unit_s[idx .. ""] = nil
	end

	if order_type == DOTA_UNIT_ORDER_CAST_TARGET then
		local ability = EntIndexToHScript(event.entindex_ability)
		local target = EntIndexToHScript(event.entindex_target)
		local target_id = target:GetPlayerOwnerID()

		if PlayerResource:IsDisableHelpSetForPlayerID(target_id, player_id) then
			return UF_FAIL_DISABLE_HELP
		end

		if forbidden_ability_boss[ability:GetName()] and BossSpawner:IsBoss(target) then
			return UF_FAIL_DISABLE_HELP
		end

		if target:HasAbility("wisp_tether") and ability:GetName() == "wisp_tether" then return end
		
		if unit and target == unit and ability:GetName() == "rubick_spell_steal" then
			return UF_FAIL_DISABLE_HELP
		end
	end

	return true
end

function AngelArena:OnPlayerBuyItem(event)
	local playerid = event.PlayerID

	AngelArena:SaveGoldForPlayerId(playerid)
end

function AngelArena:OnPlayerUsedAbility(event)
	local player = PlayerResource:GetPlayer(event.PlayerID)
	local ability_name = event.abilityname
	if not player or not ability_name or not IsValidEntity(player) then return end
	local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)

	if not hero then return end

	if crash_abilities[ability_name] then
		player.crash_timer = 6.0
		Timers:CreateTimer(1.0, function()

			if player.crash_timer == nil or player.crash_timer <= 0 then
				player.crash_timer = nil;
				return nil;
			end
			player.crash_timer = player.crash_timer - 1

			return 1.0
		end)
	end
end

function AngelArena:OnRuneActivate(event)
	local runeid = event.rune
	local playerid = event.PlayerID
	local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()

	if not hero then return end

	if runeid == DOTA_RUNE_BOUNTY then
		local cur_min = GameRules:GetGameTime() / 60

		local item_mod_table = {
			{ "item_hand_of_midas",  150 + 7.7 * cur_min },
			{ "item_advanced_midas", 200 + 15.4 * cur_min }
		}

		local hero_mod_table = {
			["npc_dota_hero_alchemist"] = 2,
		}
	
		local gold_without_mods = 100 + 20 * cur_min

		function CalcBountyGold( hero )
			local hero_mult = hero_mod_table[ hero:GetUnitName() ] or 1

			local item_gold = 0
			for _, data in pairs(item_mod_table) do
				local item = data[1]
				local gold = data[2]

				if hero:HasItemInInventory(item) and gold > item_gold then
					item_gold = gold
				end
			end

			return hero_mult * ( gold_without_mods + item_gold )
		end

		local team = hero:GetTeamNumber()

		TeamHelper:ApplyForHeroes(team, function(playerid, unit)
			unit:ModifyGold(CalcBountyGold( unit ), false, 0)
		end)
	end

	if runeid == DOTA_RUNE_ILLUSION then
		hero:AddNewModifier(hero, nil, "modifier_rune_illusion_one", { duration = 30 }) -- 30%dmg, +20mvspd
		hero:AddNewModifier(hero, nil, "modifier_rune_illusion_two", { duration = 30 }) --+15dmg resist
	end
end

function AngelArena:OnPickUpItem(event)
	if not event.ItemEntityIndex then return end
	local unit
	if event.HeroEntityIndex then unit = EntIndexToHScript(event.HeroEntityIndex) end
	if event.UnitEntityIndex then unit = EntIndexToHScript(event.UnitEntityIndex) end
	local item = EntIndexToHScript(event.ItemEntityIndex)

	if not unit or not item then return end

	if unit:IsCourier() then
		if item:GetOwnerEntity() == unit and item:GetPurchaser() == unit then
			UTIL_Remove(item)
		end
	end

	if AngelArena:IsUnitBear(unit) then
		if item:GetPurchaser() == unit then
			item:SetPurchaser( unit:GetOwnerEntity() )
		end
	end
end

function AngelArena:OnNPCSpawned(event)
	local spawnedUnit = EntIndexToHScript(event.entindex)
	if not spawnedUnit then return end

	local unitname = spawnedUnit:GetUnitName()
	local unit_owner = spawnedUnit:GetOwnerEntity()

	if spawnedUnit:IsRealHero() then
		OnHeroRespawn(spawnedUnit)
	end

	if spawnedUnit:IsCourier() then
		spawnedUnit:SetMana( -10000000 )
		spawnedUnit:SetMaxMana( -10000000 )
	end

	if spawnedUnit:HasAbility("summons_attack_magical") then
		spawnedUnit:FindAbilityByName("summons_attack_magical"):SetLevel(1)
	end

	if unitname == "npc_dota_invoker_forged_spirit" then
		Timers:CreateTimer(0.0, function()
			spawnedUnit:SetHealth(spawnedUnit:GetMaxHealth()) -- full heal
			return nil
		end)
	end

	for i = 1, 7 do
		local f_name = "npc_dota_venomancer_plague_ward_" .. tostring(i)
		if unitname == f_name then
			local poison_ability_venom = spawnedUnit:GetOwner():GetAbilityByIndex(1)
			local cleave_ability = spawnedUnit:FindAbilityByName("venomancer_ward_cleave")
			if cleave_ability then
				cleave_ability:SetLevel(1)
			end
			if poison_ability_venom:GetLevel() > 0 then
				local poison_ability = spawnedUnit:FindAbilityByName("venomancer_poison_sting")
				if poison_ability then
					poison_ability:SetLevel(poison_ability_venom:GetLevel())
				end
			end
		end
	end

	if AngelArena:IsUnitBear(spawnedUnit) then
		local ability

		local bear_abilities =
		{
			["separation_of_souls_bear"] = 1,
			["lone_druid_spirit_bear_defender"] = 1,
		}

		for i = 0, spawnedUnit:GetAbilityCount() - 1 do
			ability = spawnedUnit:GetAbilityByIndex(i)

			if ability and bear_abilities[ability:GetName()] then
				ability:SetLevel(1)
			end
		end
	end

	if armor_table[unitname] then -- see file creeps/armor_table_summon.lua for details
		spawnedUnit:AddNewModifier(spawnedUnit, nil, armor_table[unitname], {})
	end


	if spawnedUnit:IsIllusion() and spawnedUnit:IsHero() then
		local playerid = spawnedUnit:GetPlayerOwnerID()

		if playerid ~= nil and playerid ~= -1 then
			local original_hero = PlayerResource:GetSelectedHeroEntity( playerid )

			if original_hero and not original_hero:IsNull() then
				if not illusion_bug_crash[spawnedUnit:GetUnitName()] then
					local ability
					for i = 0, spawnedUnit:GetAbilityCount() - 1 do
						ability = spawnedUnit:GetAbilityByIndex(i)
						if ability then spawnedUnit:RemoveAbility(ability:GetAbilityName()) end
					end

					for i = 0, original_hero:GetAbilityCount() - 1 do
						ability = original_hero:GetAbilityByIndex(i)
						if ability then spawnedUnit:AddAbility(ability:GetAbilityName()) end
					end
				end

				local str = original_hero:GetBaseStrength() - (original_hero:GetLevel() - 1) * original_hero:GetStrengthGain()
				local agi = original_hero:GetBaseAgility() - (original_hero:GetLevel() - 1) * original_hero:GetAgilityGain()
				local int = original_hero:GetBaseIntellect() - (original_hero:GetLevel() - 1) * original_hero:GetIntellectGain()

				spawnedUnit:SetBaseStrength(str)
				spawnedUnit:SetBaseIntellect(int)
				spawnedUnit:SetBaseAgility(agi)

				if original_hero.medical_tractates then
					spawnedUnit.medical_tractates = original_hero.medical_tractates
					spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_medical_tractate", { duration = -1})
				end

				Timers:CreateTimer(0.1, function() 
					if not original_hero or original_hero:IsNull() or not IsValidEntity(original_hero) then return end
					if not spawnedUnit or spawnedUnit:IsNull() or not IsValidEntity(spawnedUnit) then return end

					local slot = NeutralSlot:GetSlotIndex()
					local item = original_hero:GetItemInSlot( slot )

					if item then
						local baseItemName = item:GetName()
						for i = 0, 171 do
							local illusionItem = spawnedUnit:GetItemInSlot(i)

							if illusionItem and illusionItem:GetName() == baseItemName and slot ~= i then
								spawnedUnit:SwapItems(i, slot)
								break
							end
						end
					end
				end)
			end
		end
	end

	if spawnedUnit:IsRealHero() then --print(spawnedUnit:GetUnitName())
		Timers:CreateTimer(0.15, function()
			if not spawnedUnit or spawnedUnit:IsNull() or not IsValidEntity(spawnedUnit) or not spawnedUnit:IsRealHero() then return nil end
			if spawnedUnit:GetUnitName() == "npc_dota_hero_arc_warden" then
				if spawnedUnit:HasModifier("modifier_arc_warden_tempest_double") then

					if not spawnedUnit:HasModifier("modifier_kill") then
						UTIL_Remove(spawnedUnit)
					else

						local real_hero = spawnedUnit:GetPlayerOwner():GetAssignedHero()

						if not spawnedUnit:HasModifier("modifier_kill") then
							UTIL_Remove(spawnedUnit)
						end

						if real_hero then
							local att = real_hero:GetBaseStrength()
							spawnedUnit:SetBaseStrength(att)
							att = real_hero:GetBaseAgility()
							spawnedUnit:SetBaseAgility(att)
							att = real_hero:GetBaseIntellect()
							spawnedUnit:SetBaseIntellect(att)

							local owner_team = real_hero:GetTeamNumber()

							if owner_team then spawnedUnit:SetTeam(owner_team) end

							for i = 0, 5 do
								if spawnedUnit:GetItemInSlot(i) and forbidden_items_for_clones[spawnedUnit:GetItemInSlot(i):GetName()] then
									spawnedUnit:RemoveItem(spawnedUnit:GetItemInSlot(i))
								end
							end

							if real_hero.medical_tractates then
								spawnedUnit.medical_tractates = real_hero.medical_tractates
								spawnedUnit:RemoveModifierByName("modifier_medical_tractate")
								spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_medical_tractate", { duration = -1 })
							end
						end
					end
				end
			end
			return nil
		end)
	end

	if spawnedUnit then
		if spawnedUnit.medical_tractates then
			spawnedUnit:RemoveModifierByName("modifier_medical_tractate")
			spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_medical_tractate", { duration = -1 })
		end
	end
end

function OnHeroRespawn(spawned_hero)
	CustomModifiers:OnHeroSpawn(spawned_hero)
end

function AngelArena:OnConnectFull(event)
	local entIndex = event.index + 1
	local player = EntIndexToHScript(entIndex)
	local playerID = player:GetPlayerID()


	CustomGameEventManager:Send_ServerToAllClients("MakeNeutralItemsInShopColored", {})

	PlayerResource:OnPlayerConnected(playerID, event.userid)
end

function AngelArena:ShareGold()
	local teamGolds = {}

	TeamHelper:ApplyForPlayers(nil, function(playerID)
		local team = PlayerResource:GetTeam(playerID)

		local teamData = teamGolds[team] or {
			nPlayers = 0,
			freeGold = 0,
		}

		if PlayerResource:IsConnected( playerID ) then
			teamData.nPlayers = teamData.nPlayers + 1
		end

		if not PlayerResource:IsAbandoned( playerID ) then return end

		teamData.freeGold = teamData.freeGold + PlayerResource:GetGold( playerID )

		PlayerResource:SetGold(playerID, 0, false)
		PlayerResource:SetGold(playerID, 0, true)
	end)


	TeamHelper:ApplyForPlayers(nil, function(playerID)
		local team = PlayerResource:GetTeam(playerID)

		local teamData = teamGolds[team]

		if not teamData then return end

		local newGold = teamData.freeGold / teamData.nPlayers

		PlayerResource:ModifyGold(playerID, newGold, true, 0)
	end)
end

function UpdatePlayersCount()
	if is_game_end then return end

	local teamsData = 
	{
		[DOTA_TEAM_GOODGUYS] = 0,
		[DOTA_TEAM_BADGUYS]  = 0,
	}

	local nPlayersConnected = 0

	TeamHelper:ApplyForPlayers(nil, function(playerid)
		if IsAbadonedPlayerID(playerid) then return end

		local team = PlayerResource:GetTeam(playerid)

		-- ignore invalid team
		if team == 0 then return end

		teamsData[team] = (teamsData[team] or 0) + 1
		nPlayersConnected = nPlayersConnected + 1
	end)

	local nRadiants = teamsData[DOTA_TEAM_GOODGUYS]
	local nDire = teamsData[DOTA_TEAM_BADGUYS]

	if nPlayersConnected == 0 or (nRadiants == 0 or nDire == 0 and not GameRules:IsCheatMode()) then
		local team

		if nPlayersConnected == 0 then
			team = DOTA_TEAM_NEUTRALS -- creeps is the best
		elseif nRadiants == 0 then
			team = DOTA_TEAM_BADGUYS
		else
			team = DOTA_TEAM_GOODGUYS
		end

		DuelController:SetFreezeTimer( true )
		GameEnder:StartGameEnd( team )
		is_game_end = true
	end
end


function AngelArena:OnGameStateChange()
	if GetMapName() ~= "map_5x5_cm" then
		if GameRules:State_Get() == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then

			TeamHelper:ApplyForPlayers(team, function(ply_id)
				local player = PlayerResource:GetPlayer(ply_id)

				if player and PlayerResource:IsValidPlayer(ply_id) and PlayerResource:GetSelectedHeroName(ply_id) == "" then
					player:MakeRandomHeroSelection()
				end
			end)
		end
	end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		PauseGame(true)
		CustomGameEventManager:Send_ServerToAllClients("MakeNeutralItemsInShopColored", {})
		Timers:CreateTimer(0.5, function()
			AngelArena:SaveGold()
			return 0.5
		end)

		
		local spawners = Entities:FindAllByClassname("npc_dota_neutral_spawner")

		for _, spawner in pairs(spawners) do
			UTIL_Remove(spawner)
		end
	end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if not is_game_start then
			GameRules:SetTimeOfDay( 0.251 )
			CreepSpawner:StartSpawning()
			BossSpawner:OnGameStart()

			local buildings = Entities:FindAllByClassname('npc_dota_building')

			for _, building in pairs(buildings) do

				local unitName = building:GetUnitName() 

				if unitName == "npc_aa_bulding_obelisk_dire" or unitName == "npc_aa_bulding_obelisk_radiant" then
					building:RemoveModifierByName("modifier_invulnerable")
				end 
			end 

			Timers:CreateTimer(0.1, function()
				GPM_Init()
				if not game_start_for_courier then
					game_start_for_courier = true
					local courier_spawn = {}
					courier_spawn[2] = Entities:FindByClassname(nil, "info_courier_spawn_radiant")
					courier_spawn[3] = Entities:FindByClassname(nil, "info_courier_spawn_dire")

					for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
						local heroes = TeamHelper:GetHeroes( team )

						local hero

						if heroes then
							for _, ithero in pairs(heroes) do
								hero = ithero
								break
							end
						end

					end
					return nil
				end
			end)

			Timers:CreateTimer(10, function() -- таймер для шаринга голды
				AngelArena:ShareGold()
				UpdatePlayersCount()
				return 10
			end)

			Timers:CreateTimer(0.5, function()
				BackPlayersToMap()
				return 0.5
			end)

			DuelController:OnGameStart(function(winnerTeam)
				is_game_end = true
				DuelController:SetFreezeTimer(true)
				GameEnder:ForceEnd(winnerTeam)
			end)

			is_game_start = true
		end
	end
end

function AngelArena:OnEntityKilled(event)
	local killedUnit = EntIndexToHScript(event.entindex_killed)
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript(event.entindex_attacker)
	local heroTeam = hero:GetTeam()

	_G.Kills[heroTeam] = _G.Kills[heroTeam] or 0
	_G.Kills[DOTA_TEAM_BADGUYS] = _G.Kills[DOTA_TEAM_BADGUYS] or 0
	_G.Kills[DOTA_TEAM_GOODGUYS] = _G.Kills[DOTA_TEAM_GOODGUYS] or 0

	local GameMode = GameRules:GetGameModeEntity()

	if not killedUnit or not IsValidEntity(killedUnit) then return end

	if BossSpawner:HandleUnitKill( killedUnit, hero ) then
		return
	end

	if IsValidEntity(killedUnit) and not killedUnit:IsAlive() and killedUnit:IsRealHero() then
		local timeLeft = killedUnit:GetLevel() * 3.8 + 5
		timeLeft = timeLeft * RESPAWN_MODIFER
		if timeLeft < 5.0 then
			timeLeft = 5.0
		end

		if killedUnit:IsReincarnating() == false then
			killedUnit:SetTimeUntilRespawn(timeLeft)
		end
	end

	if killedUnit:IsRealHero() and not killedUnit:IsReincarnating() and heroTeam and heroTeam ~= killedTeam and _G.Kills[heroTeam] then
		_G.Kills[heroTeam] = _G.Kills[heroTeam] + 1
	end

	if (killedUnit:HasAbility("skeleton_king_reincarnation") or killedUnit:HasAbility("angel_arena_reincarnation")) then
		local rein_ability = killedUnit:FindAbilityByName("skeleton_king_reincarnation") or killedUnit:FindAbilityByName("angel_arena_reincarnation")
		local ability_level = rein_ability:GetLevel()
		local current_cooldown = rein_ability:GetCooldownTimeRemaining()
		local cooldown = Util:GetReallyCooldown(killedUnit, rein_ability)

		if (current_cooldown ~= cooldown) then
			while (killedUnit:HasModifier("modifier_item_aegis")) do
				killedUnit:RemoveModifierByName("modifier_item_aegis")
			end
		end
	else
		while (killedUnit:HasModifier("modifier_item_aegis")) do
			killedUnit:RemoveModifierByName("modifier_item_aegis")
		end
	end

	if killedUnit:IsRealHero() and not killedUnit:IsReincarnating() then
		self:OnHeroDeath(killedUnit, hero)
	end

	local allowedTeams = {
		DOTA_TEAM_GOODGUYS,
		DOTA_TEAM_BADGUYS,
	}

	for _, teamNumber in pairs(allowedTeams) do
		if _G.Kills[teamNumber] >= KILL_LIMIT and not DuelController:IsLastDuelTeam(teamNumber) then
			DuelController:AddLastDuelTeam( teamNumber )
			Attentions:SendAttentionText("#aa_last_duel_coming", 10, 2)
			Attentions:SendChatMessage("#aa_last_duel_coming")
		end
	end

	GameMode:SetCustomDireScore( _G.Kills[DOTA_TEAM_BADGUYS] )
	GameMode:SetCustomRadiantScore( _G.Kills[DOTA_TEAM_GOODGUYS] )

	if hero and hero:GetPlayerOwnerID() ~= nil and killedUnit:IsCourier() then
		PlayerResource:ModifyGold(hero:GetPlayerOwnerID(), GOLD_FOR_COUR, false, 0)
	end
end

function AngelArena:OnHeroDeath(dead_hero, killer)
	if not dead_hero or dead_hero:IsNull() or not IsValidEntity(dead_hero) then return end
	if not killer or killer:IsNull() or not IsValidEntity(killer) then return end

	ComebackSystem:OnKill( killer:GetPlayerOwnerID(), killer:GetTeamNumber(), dead_hero:GetPlayerOwnerID(), dead_hero:GetTeamNumber() )
end

function AngelArena:OnHeroPicked(event)
	local hero = EntIndexToHScript(event.heroindex)

	if hero then
		hero.medical_tractates = 0
	end
end

function BackPlayersToMap()
	local heroes = HeroList:GetAllHeroes()

	for _, hero in pairs(heroes) do
		if hero and hero:IsAlive() then

			if not hero._info then
				function CheckPos(unit, pos)
					return pos[3] >= -2500
				end

				function GetBasePosition(team)
					if team == DOTA_TEAM_GOODGUYS then
						return Entities:FindByName(nil, "RADIANT_BASE"):GetAbsOrigin()
					elseif team == DOTA_TEAM_BADGUYS then
						return Entities:FindByName(nil, "DIRE_BASE"):GetAbsOrigin()
					end
				end

				local nSaveSteps = 20
				local fMinDist = 100
				hero._info = MakeMoveLimiter(hero, CheckPos, nSaveSteps, fMinDist, GetBasePosition(hero:GetTeamNumber()) )
			end

			hero._info:tick()
		end
	end
end

function AngelArena:SaveGold()
	TeamHelper:ApplyForPlayers( nil, function(pid)
		AngelArena:SaveGoldForPlayerId(pid)
	end)
end

function AngelArena:IsUnitBear(unit)
	if not unit or not IsValidEntity(unit) then return false end
	local unit_name = unit:GetUnitName()
	if unit_name == "npc_dota_lone_druid_bear1" or unit_name == "npc_dota_lone_druid_bear2"
			or unit_name == "npc_dota_lone_druid_bear3" or unit_name == "npc_dota_lone_druid_bear4" then
		return true
	end

	return false
end

function AngelArena:DamageFilter(event)
	local damage = event.damage
	local entindex_inflictor_const = event.entindex_inflictor_const
	local entindex_victim_const = event.entindex_victim_const
	local entindex_attacker_const = event.entindex_attacker_const
	local damagetype_const = event.damagetype_const
	local skill_name = ""
	local victim
	local attacker

	if (entindex_inflictor_const) then skill_name = EntIndexToHScript(entindex_inflictor_const):GetName() end
	if (entindex_victim_const) then victim = EntIndexToHScript(entindex_victim_const) end
	if (entindex_attacker_const) then attacker = EntIndexToHScript(entindex_attacker_const) end

	-----------------------------------------------------------------------------------------------------
	------------------------------ Костыль для ланаи ----------------------------------------------------
	-----------------------------------------------------------------------------------------------------
	
	if attacker and victim:HasModifier("modifier_templar_assassin_refraction_absorb") then
		if skill_name ~= "item_helm_of_the_undying" and skill_name ~= "skeleton_king_reincarnation" then
			return
		end
	end

	-----------------------------------------------------------------------------------------------------
	--------------------------------- Procent damage enable for some skills -----------------------------
	-----------------------------------------------------------------------------------------------------

	if skill_name and _G.skill_callback and _G.skill_callback[skill_name] then
		if victim and (victim:IsHero() or victim:IsCreep() or victim:IsAncient()) then

			for callback_id, callback in pairs(_G.skill_callback[skill_name]) do
				local ability = attacker:FindAbilityByName(skill_name)

				if not ability then
					ability = attacker:FindItemInInventory(skill_name)
				end

				if attacker and (skill_name == "batrider_sticky_napalm") then
					return
				end

				local callback_data = {
					caster = attacker,
					target = victim,
					skill_name = skill_name,
					ability = ability,
					damage = damage,
					damage_type = damagetype_const,
				}

				local status, res = pcall(callback, callback_data)

				if status and res then
					ApplyDamage({ victim = victim, attacker = attacker, damage = res, damage_type = damagetype_const })
				end
			end
		end
	end

	return true
end

function AngelArena:ModifierGainedFilter(event)
	local casterIdx  = event.entindex_caster_const
	local parentIdx  = event.entindex_parent_const
	local abilityIdx = event.entindex_ability_const

	if casterIdx == nil or parentIdx == nil or abilityIdx == nil then return true end

	local caster  = EntIndexToHScript( casterIdx )
	local parent  = EntIndexToHScript( parentIdx )
	local ability = EntIndexToHScript( abilityIdx )

	if not caster or not parent or not ability then return true end

	if caster:IsNull() or parent:IsNull() or ability:IsNull() then return true end

	-- datadriven dont ignore status resist
	local helper = {
		[CDOTA_Ability_Lua] = 1,
		[CDOTA_Item_Lua] = 1,
	}

	local baseClass = ability.BaseClass

	if baseClass and helper[ baseClass ] and parent.GetStatusResistance then
		if caster:GetTeamNumber() ~= parent:GetTeamNumber() then
			event.duration = event.duration * (1 - parent:GetStatusResistance() )
		end
	end

	return true
end

function AngelArena:ModifierExpirience(event)
	if event.experience <= 0 then
		return false
	end

	if event.experience > 20000 then
		force_print("Error, too many exp ", event.experience, "reason", event.reason_const, "playerid", event.player_id_const)
		event.experience = 0
		return true
	end

	return true
end

local no_points_levels = {
	[17] = 1,
	[19] = 1,
	[21] = 1,
	[22] = 1,
	[23] = 1,
	[24] = 1,
	[25] = 1,
	[26] = 1,
	[27] = 1,
	[28] = 1,
	[29] = 1,
}

function AngelArena:OnLevelUp(keys)
	local hero = EntIndexToHScript(keys.hero_entindex)
	local level = keys.level

	if no_points_levels[level] and hero:GetUnitName() ~= "npc_dota_hero_invoker" or level >= 30 then
		hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
	end
end
