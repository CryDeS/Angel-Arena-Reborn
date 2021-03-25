require('lib/dropbox')

BossClass = BossClass or class({})

local BOUNTY_AOE = 1200
local LOOT_RADIUS = 50

function BossClass:Create( name, description, allTables )
	local masterName = description["master"]

	local master

	if masterName ~= nil then
		master = allTables[masterName]
	end

	function GetField(field)
		local res = description[field]

		if res == nil and master ~= nil then
			res = master[field]
		end

		return res
	end

	boss = BossClass()

	boss.name = name

	local unitName = GetField("unit_name")

	boss.unitName = unitName

	local point = GetField("point_name")

	if not point then 
		print("[BossClass] Create failed, no point name in configuration for boss", name)
		return
	end

	local pointEnt = Entities:FindByName(nil, point)

	if not pointEnt then
		print("[BossClass] Create failed, no point entity named ", point, " for boss", name)
		return
	end

	boss.point 	 = pointEnt:GetAbsOrigin()
	boss.forward = pointEnt:GetForwardVector()

	boss.spawnDelay 	= GetField("spawn_delay") or 0
	boss.spawnInterval 	= GetField("spawn_interval") or 0

	if boss.spawnInterval == 0 then
		print("[BossClass] Create failed, boss haven't spawn interval, boss", name)
		return
	end

	boss.spawnIntervalRandom = GetField("spawn_interval_random") or 0

	boss.stats = GetField('stats')

	if not boss.stats then
		print("[BossClass] Create failed, boss haven't stats, boss", name)
		return
	end

	boss.onDeath = GetField('on_death')

	if not boss.onDeath then
		print("[BossClass] Create failed, boss haven't onDeath data, boss", name)
		return
	end

	local dropbox = boss.onDeath["dropbox"]

	if dropbox ~= nil then
		boss.dropbox = DropBox:GetDropbox( dropbox )
	end

	boss.deathCount = -1

	PrecacheUnitByNameAsync(unitName, function(...) end)

	return boss
end

function BossClass:Spawn()
	local unit = CreateUnitByName(self.unitName, self.point, true, nil, nil, DOTA_TEAM_NEUTRALS)

	if not unit then
		print("[BossClass] Failed to spawn boss unit, boss name", name, "unit name is", self.unitName)
		return
	end

	print("[BossClass] Boss", self.name, "unit spawned")

	unit:SetForwardVector(self.forward)
	
	unit:Stop()

	self:_SetStats(unit)

	self.unit = unit

	return unit
end

function BossClass:GetInitialSpawnDelay()
	return max( self.spawnDelay, 0 )
end

function BossClass:GetSpawnTime()
	local spawnIntervalRandom = self.spawnIntervalRandom

	return max( self.spawnInterval + RandomFloat(-spawnIntervalRandom, spawnIntervalRandom), 0 )
end

function BossClass:GetDeathCount()
	return self.deathCount + 1
end

function BossClass:OnDeath(killerTeam)
	local unit = self.unit

	self.unit = nil

	local pos = unit:GetAbsOrigin()

	local deathMessage = self.onDeath["message"]

	if deathMessage then
		GameRules:SendCustomMessage(deathMessage, 0, 0) 
	end

	local deathCount = self:GetDeathCount()

	print("[BossClass] Boss", self.name, "now dead, death count", deathCount)

	self.deathCount = deathCount

	local units = FindUnitsInRadius( DOTA_TEAM_NEUTRALS,
									 pos,
									 nil,
									 BOUNTY_AOE,
									 DOTA_UNIT_TARGET_TEAM_ENEMY,
									 DOTA_UNIT_TARGET_HERO,
									 DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
									 FIND_ANY_ORDER,
									 false )

	local bountyTable = self.onDeath

	local bountyGold = (bountyTable["base_gold"] or 0) + (bountyTable["gold_per_death"] or 0 ) * deathCount
	local bountyExp  = (bountyTable["base_exp"]  or 0) + (bountyTable["exp_per_death"]  or 0 ) * deathCount

	TeamHelper:ApplyForHeroes(killerTeam, function(playerid, hero)
		PlayerResource:ModifyGold(playerid, bountyGold, false, DOTA_ModifyGold_RoshanKill)
		hero:AddExperience(bountyExp, DOTA_ModifyXP_RoshanKill, false, true)
	end)

	self:_DropItems( pos )
end


function BossClass:_SetStats(unit)
	local deathCount = self:GetDeathCount()

	local hp 	= self.stats["base_health"] + self.stats["health_per_death"] * deathCount
	local armor = self.stats["base_armor"] + self.stats["armor_per_death"] * deathCount
	local dmg 	= self.stats["base_damage"] + self.stats["damage_per_death"] * deathCount

	unit:SetBaseMaxHealth(hp)
	unit:SetMaxHealth(hp)
	unit:SetHealth(hp)
	unit:SetBaseDamageMin(dmg)
	unit:SetBaseDamageMax(dmg)
	unit:SetPhysicalArmorBaseValue( armor )
end

function BossClass:_DropItems(pos)
	local dropbox = self.dropbox

	if not dropbox then return end

	dropbox:DropAtPos(pos, LOOT_RADIUS)
end