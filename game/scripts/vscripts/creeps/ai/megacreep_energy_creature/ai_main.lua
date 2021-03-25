require('lib/timers')

ENEMY_SEARCHING 	= 1150
TICK_TIME 			= 0.2

BACK_TO_SPAWN_RANGE	= ENEMY_SEARCHING + 50

EnergyAI = class({}) or EnergyAI

function Spawn(entityKeyValues)
	EnergyAI():Construct(thisEntity)
end

function EnergyAI:Construct(unit)
	self.unit = unit
	self.ability_blast = unit:FindAbilityByName("megacreep_energy_creature_shock_blast")

	if not self.ability_blast then
		print("EnergyAI:construct failed to create AI when no ability")
		return
	end

	Timers:CreateTimer(TICK_TIME, function()
		if self:OnTick() then 
			return TICK_TIME 
		end

		return nil
	end)
end

function _GetEnemiesNear(pos, teamNumber)
	return FindUnitsInRadius( teamNumber,
							  pos,
							  nil,
							  ENEMY_SEARCHING,
							  DOTA_UNIT_TARGET_TEAM_ENEMY,
							  DOTA_UNIT_TARGET_ALL,
							  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
							  FIND_ANY_ORDER,
							  false )
end

function _CanBeSeen(unit, target) 
	return unit:CanEntityBeSeenByMyTeam(target) and not target:IsInvisible() and not target:IsInvulnerable()
end

function EnergyAI:OnTick()
	local unit = self.unit

	if not unit:IsAlive() or unit:IsDominated() or unit:IsIllusion() then
		return false
	end

	local blast = self.ability_blast

	if blast:IsInAbilityPhase() then
		return true
	end

	local pos = unit:GetAbsOrigin()

	self.spawnPos = self.spawnPos or pos

	local spawnPos = self.spawnPos

	local spawnDist = (pos - spawnPos):Length()
	local currentTarget = unit:GetAttackTarget()

	if spawnDist > BACK_TO_SPAWN_RANGE then
		unit:MoveToPosition(spawnPos)
		return true
	end
	
	local currentTargetPos
	local currentDist = ENEMY_SEARCHING + 100

	if currentTarget then
		if not _CanBeSeen(unit, currentTarget) then
			currentTarget = nil
		else
			currentTargetPos = currentTarget:GetAbsOrigin()
			currentDist 	 = (currentTargetPos - pos):Length()
		end
	end

	local enemies = _GetEnemiesNear( spawnPos, unit:GetTeamNumber() )

	for _, hUnit in pairs(enemies) do
		if _CanBeSeen(unit, hUnit) then
			local unitPos = hUnit:GetAbsOrigin()
			local distToUnit = (unitPos - pos):Length()

			if distToUnit < currentDist then
				currentTarget 	 = hUnit
				currentTargetPos = unitPos
				currentDist 	 = distToUnit
			end
		end
	end

	if not currentTarget then
		if spawnDist > 50 then
			unit:MoveToPosition(spawnPos)
		end
		return true 
	end

	if blast:GetCooldownTimeRemaining() == 0 and not currentTarget:IsMagicImmune() then
		local castRange = blast:GetCastRange(pos, currentTarget) + unit:GetCastRangeBonus()

		if currentDist < (castRange - 50) then
			unit:CastAbilityOnTarget(currentTarget, blast, -1)
			return true
		end
	end

	unit:MoveToTargetToAttack(currentTarget)

	return true
end
