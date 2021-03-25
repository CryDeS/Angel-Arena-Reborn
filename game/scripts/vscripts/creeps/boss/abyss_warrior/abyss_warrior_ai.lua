require('lib/timers')

TICK_TIME 			= 0.5

ENEMY_SEARCHING 	= 1150
BACK_TO_SPAWN_RANGE	= ENEMY_SEARCHING + 50

AbyssWarriorAI = AbyssWarriorAI or class({})

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
	return unit:CanEntityBeSeenByMyTeam(target) and not target:IsInvisible() and not target:IsInvulnerable() and not target:IsCourier()
end

function AbyssWarriorAI:OnTick()
	local unit = self.unit

	if not unit:IsAlive() or unit:IsDominated() or unit:IsIllusion() then 
		return false
	end 

	local abilityDeathLink = self.abilityDeathLink
	local abilityDomnation = self.abilityDomnation
	local abilityEthernal  = self.abilityEthernal

	if abilityDeathLink:IsInAbilityPhase() then return true end
	if abilityDomnation:IsInAbilityPhase() then return true end
	if abilityEthernal :IsInAbilityPhase() then return true end

	local pos = unit:GetAbsOrigin()

	self.spawnPos = self.spawnPos or pos

	local spawnPos = self.spawnPos

	local spawnDist = (pos - spawnPos):Length()

	if spawnDist > BACK_TO_SPAWN_RANGE then
		unit:Stop()
		unit:MoveToPosition(spawnPos)
		return true
	end

	local currentTarget = unit:GetAttackTarget()
	local wasTarget = currentTarget
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

	local deathLinkAoe = ai.deathLinkAoe
	local deathLinkTarget = nil
	local wantDeathLink = abilityDeathLink:GetCooldownTimeRemaining() == 0

	local wantDomnation = abilityDomnation:GetCooldownTimeRemaining() == 0

	local domnationRange = ai.domnationCastRange
	local domnationTarget
	local domnationHp

	for _, hUnit in pairs(enemies) do
		if _CanBeSeen(unit, hUnit) then
			local unitPos = hUnit:GetAbsOrigin()
			local distToUnit = (unitPos - pos):Length()

			if distToUnit < currentDist then
				currentTarget 	 = hUnit
				currentTargetPos = unitPos
				currentDist 	 = distToUnit
			end

			if wantDomnation and distToUnit < domnationRange then
				local unitHealth = hUnit:GetHealthPercent() / 100

				if not domnationTarget or domnationHp > unitHealth then
					domnationTarget = hUnit
					domnationHp 	= unitHealth
				end
			end

			if wantDeathLink and not deathLinkTargets then
				for _, hAnotherUnit in pairs(enemies) do
					local distBetween = (hAnotherUnit:GetAbsOrigin() - unitPos):Length()

					if hUnit ~= hAnotherUnit and distBetween < deathLinkAoe then
						deathLinkTarget = hUnit
						break
					end
				end
			end
		end
	end

	if deathLinkTarget then
		unit:Stop()
		unit:CastAbilityOnTarget(deathLinkTarget, abilityDeathLink, -1)

		return true
	end

	if domnationTarget then
		unit:Stop()
		unit:CastAbilityOnTarget(domnationTarget, abilityDomnation, -1)

		return true
	end

	local selfHealth = unit:GetHealthPercent() / 100

	if selfHealth < 0.7 then
		unit:Stop()
		unit:CastAbilityNoTarget( abilityEthernal, -1 )

		return true
	end

	if not currentTarget then
		if spawnDist > 50 then
			unit:Stop()
			unit:MoveToPosition(spawnPos)
		end

		return true 
	end


	if currentTarget ~= unit:GetAttackTarget() then
		unit:Stop()
		unit:MoveToTargetToAttack(currentTarget)
	end

	return true
end

-- Main entry point for AI 
function Spawn( entityKeyValues )
	ai = AbyssWarriorAI() 

	local unit = thisEntity

	ai.unit 			= unit
	
	ai.abilityDeathLink = unit:FindAbilityByName("abyss_warrior_death_link")
	ai.deathLinkAoe 	= ai.abilityDeathLink:GetSpecialValueFor("link_radius")

	ai.abilityDomnation = unit:FindAbilityByName("abyss_warrior_domination")
	ai.domnationCastRange = ai.abilityDomnation:GetCastRange( unit:GetAbsOrigin(), nil )

	ai.abilityEthernal  = unit:FindAbilityByName("abyss_warrior_ethereal_charge")

	Timers:CreateTimer(TICK_TIME, function() 
		if not ai:OnTick() then 
			return nil
		end

		return TICK_TIME
	end )
end