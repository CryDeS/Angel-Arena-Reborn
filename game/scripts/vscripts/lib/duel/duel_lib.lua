require('lib/timers')
require('lib/teleport')
require('lib/base_lua_helpers')
require('lib/duel/doors')
require('lib/connection_helpers')

DuelLibrary = DuelLibrary or class({})

DuelLibrary.DRAW_TEAM = 0

local DUEL_TRIBUNE_MODIFIER = "modifier_full_disable_stun"
local DUEL_START_MODIFIER 	= "modifier_godmode"

local DUEL_POINT_NAMES = {
	[DOTA_TEAM_GOODGUYS] = {
		"RADIANT_DUEL_TELEPORT",
	},
	[DOTA_TEAM_BADGUYS] = {
		"DIRE_DUEL_TELEPORT",
	},
}

local TRIBUNE_POINT_NAMES = {
	[DOTA_TEAM_GOODGUYS] = {
		"RADIANT_TRIBUNE",
		"RADIANT_TRIBUNE_1",
		"RADIANT_TRIBUNE_2",
		"RADIANT_TRIBUNE_3",
		"RADIANT_TRIBUNE_4",
		"RADIANT_TRIBUNE_5",
		"RADIANT_TRIBUNE_6",
		"RADIANT_TRIBUNE_7",
		"RADIANT_TRIBUNE_8",
		"RADIANT_TRIBUNE_9",
	},

	[DOTA_TEAM_BADGUYS] = {
		"DIRE_TRIBUNE",
		"DIRE_TRIBUNE_1",
		"DIRE_TRIBUNE_2",
		"DIRE_TRIBUNE_3",
		"DIRE_TRIBUNE_4",
		"DIRE_TRIBUNE_5",
		"DIRE_TRIBUNE_6",
		"DIRE_TRIBUNE_7",
		"DIRE_TRIBUNE_8",
		"DIRE_TRIBUNE_9",
	},
}

local BASE_POINTS_NAMES = {
	[DOTA_TEAM_GOODGUYS] = "RADIANT_BASE",
	[DOTA_TEAM_BADGUYS] = "DIRE_BASE",
}

local DUEL_TRIGGER_NAME = "trigger_box_duel"

local PURGE_MODIFIERS = {
	"modifier_soul_collector_decrease_heal",
	"modifier_soul_merchant_active_buff_enemy",
	"modifier_devour_helm_active",
	"modifier_devour_helm_active_stun",
	"modifier_huskar_burning_spear_counter",
	"modifier_item_invisibility_edge",
	"modifier_life_stealer_assimilate",
	"modifier_huskar_burning_spear_debuff",
	"modifier_kings_bar_magic_immune_active",
	"modifier_black_king_bar_immune",
	"modifier_venomancer_poison_nova",
	"modifier_dazzle_weave_armor",
	"modifier_dazzle_weave_armor_debuff",
	"modifier_life_stealer_infest",
	"modifier_maledict",
	"modifier_silver_edge_debuff",
	"modifier_undying_decay_debuff",
	"modifier_undying_decay_buff",
	"modifier_bane_nightmare",
	"modifier_enchantress_natures_attendants",
	"modifier_joe_black_song_debuff",
	"modifier_eclipse_amphora",
	"modifier_bristleback_quill_spray",
	"modifier_item_angels_greaves_fuckit",
	"modifier_bane_enfeeble",
	"modifier_ice_blast",
	"modifier_riki_tricks_of_the_trade_phase",
	"modifier_venomancer_venomous_gale",
	"modifier_fountain_invulnerability",
}

local function _IsHeroCheck(hero)
	return hero and not hero:IsNull() and IsValidEntity(hero) and hero:IsRealHero() and not hero:IsTempestDouble() and not hero:HasModifier("modifier_banned_custom")
end

function ClearDuelFromHeroes(heroes_table) 
	for _, x in pairs(heroes_table) do
		if x and not x:IsNull() and IsValidEntity(x) and x:IsRealHero() then
			x.IsDueled = false
		end
	end
end

function DuelLibrary:MoveHeroesToTribune(heroesTable, tribunesTable)
	local cur = 1
	local max = #tribunesTable

	for _, x in pairs(heroesTable) do
		if x and not x:IsNull() and IsValidEntity(x) then
			self:_RecordPos(x)

			self:ToTribune(x)

			cur = cur + 1
			if cur >= max then 
				cur = 1 
			end
		end
	end
end

function DuelLibrary:_CancelTimers()
	local backTimer = self.backTimer

	if backTimer ~= nil then
		Timers:RemoveTimer(backTimer)
		self.backTimer = nil
	end
end

function DuelLibrary:_RecordPos( unit )
	self.oldPoints[unit] = unit:GetAbsOrigin()
end

function DuelLibrary:_PopRecordedPos( unit )
	if not unit then return end

	local pos = self.oldPoints[unit]
	self.oldPoints[unit] = nil
	return pos
end

function DuelLibrary:_AddBackTimer(unit, limiter)
	self.backUnits[unit] = limiter
end

function DuelLibrary:_RemoveBackTimer(unit)
	self.backUnits[unit] = nil
end

function DuelLibrary:_ValidatePositions()
	for unit, limiter in pairs(self.backUnits) do
		limiter:tick()
	end
end

function DuelLibrary:_StartTimers()
	self:_CancelTimers()

	self.backTimer = Timers:CreateTimer(0.1, function()
		self:_ValidatePositions()
		return 0.1
	end)
end

function DuelLibrary:EndDuel(teamNumber)
	if not self:IsDuelActive() then return end

	self:_CancelTimers()

	local winners = self.teamHeroes[teamNumber] or {}

	for hero, _ in pairs(winners) do
		if hero and hero:IsRealHero() and hero:IsAlive() then
			hero:SetHealth( hero:GetMaxHealth() )
			hero:SetMana( hero:GetMaxMana() )
		end
	end

	for team, units in pairs(self.teamHeroes) do
		self:RemoveHeroesFromDuel(units)
	end

	self.duelActive = false
	self.backUnits = {}
	self.oldPoints = {}
	self.alives = {}
	self.teamHeroes = {}

	DuelLibrary:SetDoorsState( true )

	local callback = self.endCallback

	if callback then
		callback( teamNumber )
		self.endCallback = nil
	end
end

function DuelLibrary:_MoveToDuel( unit, point )
	unit:Stop() 
	GridNav:DestroyTreesAroundPoint(unit:GetAbsOrigin(), 15, true)
	unit:InterruptMotionControllers(true)
	TeleportUnitToPointName(unit, point, true, false)
	unit:Stop() 
	unit:RemoveModifierByName(DUEL_TRIBUNE_MODIFIER)
	unit:AddNewModifier(unit, nil, DUEL_START_MODIFIER, { duration = 2 })

	unit:SetHealth( unit:GetMaxHealth() )
	unit:SetMana( unit:GetMaxMana() )

	unit:Purge(false, true, false, true, false )

	for _, modifier_name in pairs(PURGE_MODIFIERS) do
		unit:RemoveAllModifiersByName(modifier_name)
	end

	function IsAroundDuel(unit, unitPoint) 
		local units = Entities:FindAllInSphere(unitPoint, 10)

		for _, thing in pairs( units )  do
			if thing:GetName() == DUEL_TRIGGER_NAME then
				return true
			end
		end

		return false
	end

	local limiter = MakeMoveLimiter(unit, IsAroundDuel, 20, 100, GetPointPositionByName("DUEL_ARENA_CENTER") )

	self:_AddBackTimer( unit, limiter )

	local heroTeam = unit:GetTeamNumber()

	local nAlives = self.alives[heroTeam]

	self.alives[heroTeam] = nAlives + 1
end

function DuelLibrary:MoveToDuel(duelHeroes, duelPointsTable)
	local cur = 1
	local max = #duelPointsTable 

	for _, x in pairs(duelHeroes) do
		self:_MoveToDuel( x, duelPointsTable[cur])

		cur = cur + 1
		
		if cur >= max then 
			cur = 1 
		end
	end
end

function DuelLibrary:RemoveHeroesFromDuel(heroesTable)
	for x, _ in pairs(heroesTable) do
		if x and IsValidEntity(x) then
			x:Purge(true, true, false, true, true )

			while(x:HasModifier("modifier_huskar_burning_spear_counter")) do
				x:RemoveModifierByName("modifier_huskar_burning_spear_counter")
			end

			x:RemoveModifierByName("modifier_huskar_burning_spear_debuff")

			local point = self:_PopRecordedPos(x)

			if not point then
				local entityName = BASE_POINTS_NAMES[ x:GetTeamNumber() ]

				if entityName then
					point = Entities:FindByName( nil, entityName ):GetAbsOrigin()
				end
			end

			if x:IsAlive() then
				x:RemoveModifierByName(DUEL_TRIBUNE_MODIFIER)
			end

			if point then
				if x:IsAlive() then 
					x:InterruptMotionControllers(true)
					TeleportUnitToVector(x, point, true, true)
				end
			else
				print("[DS] Duel system error, base points not found!")
			end
		end
	end
end

function DuelLibrary:Precache( context )
	DuelDoors:Precache( context )
end

function DuelLibrary:IsDuelActive()
	return self.duelActive
end

function DuelLibrary:ToTribune(hero)
	local team = hero:GetTeamNumber()

	local tribuneName = TRIBUNE_POINT_NAMES[team][1]

	hero:InterruptMotionControllers(true)
	TeleportUnitToPointName(hero, tribuneName, true, true)

	hero:AddNewModifier(hero, nil, DUEL_TRIBUNE_MODIFIER, {})

	self.teamHeroes[team][hero] = true
end

function DuelLibrary:GetDuelCount()
	return self.duelCount
end

function DuelLibrary:StartDuel(radiant_heroes, dire_heroes, hero_count, onDuelEnd)
	if self:IsDuelActive() then
		self:EndDuel( DuelLibrary.DRAW_TEAM )
	end
	
	radiant_heroes 	= self:FilterUnits( radiant_heroes )
	dire_heroes 	= self:FilterUnits( dire_heroes )

	local radiantCount = min(#radiant_heroes, hero_count)
	local direCount = min(#dire_heroes, hero_count)

	radiant_heroes = ShuffleTable( radiant_heroes )
	dire_heroes    = ShuffleTable( dire_heroes )

	function GetHeroesToDuelFromTeamTable(heroTable, nHeroes)
		local out = {}

		local i = 1
		local lenHeroTable = #heroTable

		while nHeroes > 0 and i <= lenHeroTable do
			if IsConnected( heroTable[i] ) then
				table.insert(out, heroTable[i] )
				nHeroes = nHeroes - 1
			end

			i = i + 1
		end

		return out
	end

	local radiant_warriors = GetHeroesToDuelFromTeamTable(radiant_heroes, radiantCount)
	local dire_warriors    = GetHeroesToDuelFromTeamTable(dire_heroes, direCount)

	self:SetDoorsState( false )

	self.duelCount = self.duelCount + 1
	self.duelActive = true
	self.endCallback = onDuelEnd

	local warriors = {
		[DOTA_TEAM_GOODGUYS] = { radiant_heroes, radiant_warriors, },
		[DOTA_TEAM_BADGUYS]  = { dire_heroes, 	 dire_warriors, },
	}

	for team, warriorData in pairs(warriors) do
		local totalHeroes = warriorData[1]
		local warriorHeroes = warriorData[2]

		self.teamHeroes[team] = {}
		self.alives[team] = 0
		self:MoveHeroesToTribune(totalHeroes, TRIBUNE_POINT_NAMES[team])
		self:MoveToDuel(warriorHeroes, DUEL_POINT_NAMES[team])
	end

	local currentWarriors = {}

	for _, hero in pairs( radiant_warriors ) do
		currentWarriors[hero] = 1
	end

	for _, hero in pairs( dire_warriors ) do
		currentWarriors[hero] = 1
	end

	self.currentWarriors = currentWarriors

	self:_StartTimers()
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function DuelLibrary:_Init()
	if not self.init then
		ListenToGameEvent("entity_killed", Dynamic_Wrap(DuelLibrary, "DeathListener"), self )
		ListenToGameEvent('npc_spawned', Dynamic_Wrap(DuelLibrary, "SpawnListener"), self )

		self.init = true
	end

	self.backTimer 	= self.backTimer or nil

	self.duelActive = self.duelActive or false
	self.duelCount 	= self.duelCount or 0

	self.oldPoints 	= self.oldPoints or {}
	self.backUnits 	= self.backUnits or {}
	self.alives 	= self.alives or {}
	self.teamHeroes = self.teamHeroes or {}
end

function DuelLibrary:FilterUnits(unitTable)
	local result = {}

	for _, unit in pairs(unitTable) do
		if _IsHeroCheck(unit) and unit:IsAlive() then
			table.insert( result, unit )
		end
	end

	return result
end

function DuelLibrary:_OnHeroDeathOnDuel( hero )
	local heroTeam = hero:GetTeamNumber()

	DuelLibrary:_PopRecordedPos(hero)
	DuelLibrary:_RemoveBackTimer(hero)

	self.currentWarriors[hero] = nil

	local nAlives = self.alives[heroTeam] - 1

	self.alives[heroTeam] = nAlives

	if nAlives == 0 then
		if heroTeam == DOTA_TEAM_GOODGUYS then
			winnerTeam = DOTA_TEAM_BADGUYS
		else
			winnerTeam = DOTA_TEAM_GOODGUYS
		end

		self:EndDuel( winnerTeam )
	end
end

function DuelLibrary:DeathListener( event )
	if not self:IsDuelActive() then return end

	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
	local hero = EntIndexToHScript( event.entindex_attacker )
	local heroTeam = hero:GetTeam()
	
	if not killedUnit or not IsValidEntity(killedUnit) or not killedUnit:IsRealHero() then return end

	if DuelLibrary:IsDuelActive() and not killedUnit:IsReincarnating() then
		print("on hero death on duel")
	   self:_OnHeroDeathOnDuel( killedUnit )
	end
end

function DuelLibrary:SpawnListener(event)
	if not self:IsDuelActive() then return end

	local spawnedUnit = EntIndexToHScript( event.entindex )

	if not spawnedUnit or spawnedUnit:IsNull() or not IsValidEntity(spawnedUnit) or not spawnedUnit:IsRealHero() then
		return
	end

	if self.currentWarriors[spawnedUnit] ~= nil then return end

	Timers:CreateTimer(0.01, function()
		if not spawnedUnit or spawnedUnit:IsNull() then return end

		if not _IsHeroCheck(spawnedUnit) then return end

		if not DuelLibrary:IsDuelActive() then return end

		local playerID = spawnedUnit:GetPlayerOwnerID()

		-- yes invalid playerid is allowed
		if playerID ~= -1 and PlayerResource:GetSelectedHeroEntity(playerID) ~= spawnedUnit then return end

		DuelLibrary:ToTribune(spawnedUnit)
	end )
end

function DuelLibrary:GetMaximumHeroes(hero_table1, hero_table2)
	local function CountAliveHeroes(heroTable)
		local nAlives = 0
		local nTotal = 0

		for _, x in pairs(heroTable) do
			if _IsHeroCheck(x) and IsConnected(x) then

				nTotal = nTotal + 1

				if x:IsAlive() then
					nAlives = nAlives + 1
				end
			end
		end

		return nAlives, nTotal
	end

	local nOne, nOneTotal = CountAliveHeroes( hero_table1 ) 
	local nTwo, nTwoTotal = CountAliveHeroes( hero_table2 )

	return nOne, nOneTotal, nTwo, nTwoTotal
end

function DuelLibrary:SetDoorsState(state)
	DuelDoors:SetDoorsState(state)
end

DuelLibrary:_Init()