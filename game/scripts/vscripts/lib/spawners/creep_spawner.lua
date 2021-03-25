--[[
 Creep Spawner System. Causer - CryDeS

 Methods:
  CreepSpawner:Init() 											-- initializing of spawn system
  CreepSpawner:StartSpawning() 									-- Start spawning creeps at this time and next times
  CreepSpawner:StopSpawning()									-- Totaly stop spawning system

  CreepSpawner:SetEnable(bValue) 								-- Stop/start spawn of next wave of creeps
  CreepSpawner:GetEnable() 										-- Get current enable system of creep 

  CreepSpawner:SpawnCreeps() 									-- Spawn creeps

  CreepSpawner:RegisterOnSpawnCallback( func )					-- Register callback on creep spawn.
  CreepSpawner:UnregisterOnSpawnCallback( func )				-- Unregister callback on creep spawn.

  CreepSpawner:RegisterOnDeathCallback( func )					-- Register callback on creep death.
  CreepSpawner:UnregisterOnDeathCallback( func )				-- Unregister callback on creep death.
]]

CreepSpawner = CreepSpawner or class({})

LinkLuaModifier("modifier_dominate_protection", 'lib/spawners/modifier_dominate_protection', LUA_MODIFIER_MOTION_NONE)

require("lib/timers")

local DEBUG = IsInToolsMode() 
local FORCE_DEBUG = false
local CONFIG_PATH = "scripts/npc/creep_spawners.kv"

local CREEP_SPAWN_TIME 	= 60
local CREEP_RANDOM_OFFSET = 50

if DEBUG then
	CREEP_SPAWN_TIME = 10
end

local SPAWN_DELAY_PER_UNIT 	= 0.005 
local SPAWN_DELAY_LIMIT 	= 0.25 

-------------------------------------------- PUBLIC -----------------------------------------------------------------

function emptyFunc(...)
end 

function CreepSpawner:Init()
	self.onSpawnCallbacks = {}
	self.onDeathCallbacks = {}

	self.spawnTime = CREEP_SPAWN_TIME
	self.spawnEnabled = true  

	self.spawners, self.creepCount = self:_parseSpawners(CONFIG_PATH)

	if DEBUG then 
		self.preacachedCount = 0
	end 

	self._spawnerCounts = self._spawnerCounts or {}
	
	self:StopSpawning() 

	for spawner_info, creeps in pairs(self.spawners) do
		for _, creepname in pairs(creeps) do 

			if DEBUG then 
				PrecacheUnitByNameAsync( creepname, function(...) 
					self.preacachedCount = self.preacachedCount + 1
					if FORCE_DEBUG then
						print( "Precached unit ", creepname, tostring(self.preacachedCount) .. "/" .. tostring(self.creepCount) )
					end
				end )
			else 
				PrecacheUnitByNameAsync( creepname, emptyFunc )
			end 
		end

		self._spawnerCounts[spawner_info.name] = self._spawnerCounts[spawner_info.name] or {}
	end 
end 

function CreepSpawner:StartSpawning()
	self:SpawnCreeps()

	Timers:CreateTimer("CreepSpawner", {  useGameTime = true, 
										  endTime 	  = self.spawnTime,
										  callback 	  = function() 
												self:SpawnCreeps()
												return self.spawnTime
										  end } )
end 

function CreepSpawner:StopSpawning() 
	Timers:RemoveTimer( "CreepSpawner" )
end 

function CreepSpawner:SetEnable(bVal) 		self.spawnEnabled = bVal; 	end 
function CreepSpawner:GetEnable() 			return self.spawnEnabled; 	end 

function CreepSpawner:SpawnCreeps()
	local spawnDelay = 0.0

	for spawner_info, creep_names in pairs(self.spawners) do
		local spawner_name = spawner_info.name 

		local base_spawner_pos  = spawner_info.pos
		local spawner_dir  = spawner_info.direction

		for _, creep_name in pairs(creep_names) do
			if self:_needSpawn( spawner_name )  then 
				local offset = RandomVector( CREEP_RANDOM_OFFSET )
				local spawner_pos  = base_spawner_pos + offset

				spawnDelay = spawnDelay + SPAWN_DELAY_PER_UNIT
				
				if spawnDelay > SPAWN_DELAY_LIMIT then
					spawnDelay = SPAWN_DELAY_LIMIT
				end 

				Timers:CreateTimer(spawnDelay, function()
					local creep = CreateUnitByName(creep_name, spawner_pos, true, nil, nil, DOTA_TEAM_NEUTRALS) 	

					if not creep then
						print("Error handled, no unit with name", creep, " exists. Trying to spawn it on spawner ", spawner_name)
						return nil
					end

					creep:SetForwardVector(spawner_dir)
					creep:Stop()

					self:_CreateCreep(creep, spawner_info)
				end)
			end 
		end 
	end 
end 

function CreepSpawner:RegisterOnSpawnCallback( func ) table.insert(self.onSpawnCallbacks, func ); end 
function CreepSpawner:UnregisterOnSpawnCallback( func ) table.remove(self.onSpawnCallbacks, func ); end 

function CreepSpawner:RegisterOnDeathCallback( func ) table.insert(self.onDeathCallbacks, func ); end 
function CreepSpawner:UnregisterOnDeathCallback( func ) table.remove(self.onDeathCallbacks, func ); end 

-------------------------------------------- PRIVATE -----------------------------------------------------------------

function CreepSpawner:_parseSpawners(sSettingsFile)
	local temp = LoadKeyValues( sSettingsFile )

	local ret = {}

	local creepCount = 0

	for spawner_name, spawner_table in pairs(temp) do 
		local entity = Entities:FindByName( nil, spawner_name ) 

		if not entity then 
			print( "Failed to parse point, there is not point on map, point =", spawner_name )
		else 
			local spawner_info = { 	name = spawner_name, 
									pos = entity:GetAbsOrigin(),
									direction = entity:GetForwardVector(),
									spawner_type = spawner_table["type"] }

			local creeps = spawner_table["creeps"]

			ret[spawner_info] = creeps 

			for _, _ in pairs(creeps) do 
				creepCount = creepCount + 1
			end 
		end 
	end 

	return ret, creepCount
end 

function CreepSpawner:_notifyCallbackList(callback_list, arg_kv)
	for _, callback in pairs(callback_list) do
		xpcall( function() 
					callback(arg_kv) 
				end,
				function(msg)
					print( "Error notify callback in CreepSpawner:_notifyCallbacks + \n" .. msg .. " traceback:\n" .. debug.traceback() )
				end )
	end 
end

function CreepSpawner:_needSpawn( spawnerName )
	local result = true
	for unit, _ in pairs(self._spawnerCounts[ spawnerName ]) do
		if unit and not unit:IsNull() and unit.IsAlive and unit:IsAlive() then
			result = false
		end
	end
	return result
end

function CreepSpawner:_FreeCreep( unit )
	unit.spawner_info = nil
end

function CreepSpawner:_CreateCreep( unit, spawner_info )
	unit:AddNewModifier(unit, nil, "modifier_dominate_protection", { duration = -1 })

	unit.spawner_info = spawner_info

	self:_notifyCallbackList(self.onSpawnCallbacks, { creep = unit, spawner_info = spawner_info } )
end

function CreepSpawner:_OnDominated( unit )
	self:_FreeCreep( unit )
end

function CreepSpawner:_OnDied( unit )
	self:_FreeCreep( unit )
	self:_notifyCallbackList(self.onDeathCallbacks, { creep = unit, spawner_info = unit.spawner_info } )
end

function CreepSpawner:_OnEnterTrigger( spawnName, trigger )
	if self._spawnerCounts[ spawnName ] == nil then return end
	self._spawnerCounts[ spawnName ][trigger] = true;
end

function CreepSpawner:_OnLeaveTrigger( spawnName, trigger )
	if self._spawnerCounts[ spawnName ] == nil then return end
	self._spawnerCounts[ spawnName ][trigger] = nil;
end

local AvailableUnits = {
	["npc_dota_juggernaut_healing_ward"] = 1,
	["npc_dota_zeus_cloud"] = 1,
	["npc_dota_tusk_frozen_sigil1"] = 1,
	["npc_dota_tusk_frozen_sigil2"] = 1,
	["npc_dota_tusk_frozen_sigil3"] = 1,
	["npc_dota_tusk_frozen_sigil4"] = 1,
	["npc_dota_tusk_frozen_sigil5"] = 1,
	["npc_dota_tusk_frozen_sigil6"] = 1,
	["npc_dota_tusk_frozen_sigil7"] = 1,
	["npc_dota_observer_wards"] = 1,
	["npc_dota_sentry_wards"] = 1,
	["npc_dota_witch_doctor_death_ward"] = 1,
	["npc_dota_shadow_shaman_ward_1"] = 1,
	["npc_dota_shadow_shaman_ward_2"] = 1,
	["npc_dota_shadow_shaman_ward_3"] = 1,
	["npc_dota_shadow_shaman_ward_4"] = 1,
	["npc_dota_shadow_shaman_ward_5"] = 1,
	["npc_dota_shadow_shaman_ward_6"] = 1,
	["npc_dota_shadow_shaman_ward_7"] = 1,
	["npc_dota_venomancer_plague_ward_1"] = 1,
	["npc_dota_venomancer_plague_ward_2"] = 1,
	["npc_dota_venomancer_plague_ward_3"] = 1,
	["npc_dota_venomancer_plague_ward_4"] = 1,
	["npc_dota_venomancer_plague_ward_5"] = 1,
	["npc_dota_venomancer_plague_ward_6"] = 1,
	["npc_dota_venomancer_plague_ward_7"] = 1,
	["npc_dota_clinkz_skeleton_archer"] = 1,
	["npc_dota_unit_tombstone1"] = 1,
	["npc_dota_unit_tombstone2"] = 1,
	["npc_dota_unit_tombstone3"] = 1,
	["npc_dota_unit_tombstone4"] = 1,
	["npc_dota_unit_tombstone5"] = 1,
	["npc_dota_unit_tombstone6"] = 1,
	["npc_dota_unit_tombstone7"] = 1,
	["npc_dota_pugna_nether_ward_1"] = 1,
	["npc_dota_pugna_nether_ward_2"] = 1,
	["npc_dota_pugna_nether_ward_3"] = 1,
	["npc_dota_pugna_nether_ward_4"] = 1,
	["npc_dota_pugna_nether_ward_5"] = 1,
	["npc_dota_pugna_nether_ward_6"] = 1,
	["npc_dota_pugna_nether_ward_7"] = 1,
	["npc_dota_lich_ice_spire"] = 1,
	["npc_dota_rattletrap_cog"] = 1,
}

function creep_spawner_on_start_touch( trigger, data )
	if not trigger then return end
	if not trigger.GetName then return end

	local spawnName = trigger:GetName()

	local activator = data.activator
	
	if not activator then return end

	if not activator.IsCreature or not activator.IsHero or not activator.IsCourier or not activator.IsOther then return end

	if activator:IsCourier() then return end

	local must = activator:IsCreature() or activator:IsCreep() or activator:IsHero() or activator:IsOther()

	if not must then return end

	if activator:IsOther() and not AvailableUnits[ activator:GetUnitName() ] then return end

	CreepSpawner:_OnEnterTrigger( spawnName , activator )
end

function creep_spawner_on_end_touch( trigger, data )
	if not trigger then return end
	if not trigger.GetName then return end

	local spawnName = trigger:GetName()

	local activator = data.activator

	if not activator then return end

	if not activator.IsCreature or not activator.IsHero or not activator.IsCourier or not activator.IsCourier or not activator.IsOther then return end

	if activator:IsCourier() then return end

	local must = activator:IsCreature() or activator:IsCreep() or activator:IsHero() or activator:IsOther()
	
	if activator:IsOther() and not AvailableUnits[ activator:GetUnitName() ] then return end

	if not must then return end

	CreepSpawner:_OnLeaveTrigger( spawnName , activator )
end
