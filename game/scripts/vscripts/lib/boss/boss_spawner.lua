require("lib/boss/boss_class")

BossSpawner = BossSpawner or class({})

local CONFIG_PATH = "scripts/npc/boss_spawners.kv"

function BossSpawner:Init()
	if self.inited then return end

	self.bossClasses = self.bossClasses or {}
	self.bossCurrent = self.bossCurrent or {}
	self.currentSpawning = self.currentSpawning or {}

	self.inited = false

	local data = LoadKeyValues(CONFIG_PATH)

	if not data then 
		print("[BossSpawner] Failed to parse config", CONFIG_PATH)
		return
	end

	for bossName, bossData in pairs(data) do
		local boss = BossClass:Create(bossName, bossData, data)

		if not boss then 
			return
		end

		local oldBoss = self.bossClasses[bossName]

		self.bossClasses[bossName] = boss

		if oldBoss then
			boss.unit = oldBoss.unit
		end
	end

	LinkLuaModifier("modifier_boss_power", 'lib/boss/modifier_boss_power', LUA_MODIFIER_MOTION_NONE)

	self.inited = true
end

function BossSpawner:ForBossClass(functor)
	for _, boss in pairs(self.bossClasses) do
		if functor(boss) then return end
	end
end

function BossSpawner:OnGameStart()
	if not self.inited then return end

	for _, boss in pairs(self.bossClasses) do
		self:CheckSpawn(boss, true)
	end
end

function BossSpawner:CheckSpawn(boss, firstTime)
	local spawnDelay

	if firstTime then
		spawnDelay = boss:GetInitialSpawnDelay()
	else
		spawnDelay = boss:GetSpawnTime()
	end

	local wasTimer = self.currentSpawning[boss]
	
	if wasTimer then
		Timers:RemoveTimer(wasTimer)
		print("[BossSpawner] Boss", boss.name, "spawning canceled because have new request for spawntime")
	end

	print("[BossSpawner] Boss", boss.name, "spawning after", spawnDelay, "seconds")

	local timer = Timers:CreateTimer( spawnDelay, function()
		self:_RemoveTimer(boss, true)
		self:SpawnBoss(boss)
	end)

	self.currentSpawning[boss] = timer
end

function BossSpawner:_RemoveTimer(boss)
	local wasTimer = self.currentSpawning[boss]
	
	if wasTimer then
		Timers:RemoveTimer(wasTimer)

		self.currentSpawning[boss] = nil
	end
end

function BossSpawner:SpawnBoss(boss)
	self:_RemoveTimer(boss, true)

	local unit = boss:Spawn()
		
	unit:AddNewModifier(unit, nil, "modifier_boss_power", { duration = -1 })

	unit.IsAngelArenaBoss = true
	
	self.bossCurrent[unit] = boss
	self.currentSpawning[boss] = nil
end

function BossSpawner:IsBoss(unit)
	if not unit then return nil end
	
	return unit.IsAngelArenaBoss
end

function BossSpawner:GetDeathCount(bossName)
	local bossClass = self.bossClasses[bossName]

	if not bossClass then
		return false
	end

	return bossClass:GetDeathCount()	
end

function BossSpawner:IsBossAlive(bossName)
	local bossClass = self.bossClasses[bossName]

	if not bossClass then
		return false
	end

	local unit = bossClass.unit

	if not unit then
		return false
	end

	return unit:IsAlive()
end

function BossSpawner:HandleUnitKill(unit, killer)
	if not unit.IsAngelArenaBoss then
		return false
	end

	local boss = self.bossCurrent[unit]

	if not boss then 
		print("[BossSpawner] Failed to handle unit, unit is boss but he doesn't not contains in boss table, unit is", unit:GetUnitName())
		return 
	end

	self.bossCurrent[unit] = nil

	boss:OnDeath( killer:GetTeamNumber() )

	self:CheckSpawn(boss, false)

	return true
end