require('lib/ai/simple_ai')

TICK_TIME 			= 0.1
AOI_RANGE 			= 750

function Spawn( entityKeyValues )
	function PerformDamageRing(caster, ability, aoiEnemies)
		if caster.channelDamageSteal then return false end
		local casterPos = caster:GetAbsOrigin()
		local castRange = ability:GetCastRange(casterPos, nil) + caster:GetCastRangeBonus() - 100
		return AIHelpers:CastRangeFilter( aoiEnemies, casterPos, castRange, function(unit)
			caster:CastAbilityNoTarget(ability, -1)
			return true
		end)
	end
	
	function PerformHeal(caster, ability, aoiEnemies)
		if caster.channelDamageSteal then return false end
		if (caster:GetHealthPercent() <= 80 and caster:IsStunned()) or caster:GetHealthPercent() <= 40 then
			caster:CastAbilityNoTarget(ability, -1)
			return true
		end
		return false
	end

	function PerformStealDamage(caster, ability, aoiEnemies)
		if caster.channelDamageSteal then return false end
		if caster.castDamageRingProgress then return false end
		local casterPos = caster:GetAbsOrigin()
		local castRange = ability:GetCastRange(casterPos, nil) + caster:GetCastRangeBonus() - 50
		return AIHelpers:CastRangeFilter( aoiEnemies, casterPos, castRange, function(unit)
			caster:CastAbilityNoTarget(ability, -1)
			return true
		end)
	end
	
	function PerformRage(caster, ability, aoiEnemies)
		if caster.channelDamageSteal then return false end
		if caster:GetHealthPercent() <= 40 then
			caster:CastAbilityNoTarget(ability, -1)
			return true
		end
		return false
	end
	
	local unit = thisEntity

	local actions = {
		SimpleAIActions.ForceBack:Make(unit),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("soul_guardian_heroes_ring"),		PerformDamageRing),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("soul_guardian_pure_heal"),		PerformHeal),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("soul_guardian_damage_steal"),	PerformStealDamage),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("soul_guardian_holy_rage"), 		PerformRage),
		SimpleAIActions.Attack:Make(unit),
		SimpleAIActions.Back:Make(unit),
	}

	SimpleAI:Make( unit, TICK_TIME, AOI_RANGE, actions )
end
