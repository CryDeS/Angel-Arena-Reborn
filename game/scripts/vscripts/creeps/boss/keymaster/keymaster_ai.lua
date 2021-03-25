require('lib/ai/simple_ai')

TICK_TIME 			= 0.1
AOI_RANGE 			= 750

function Spawn( entityKeyValues )
	function PerformHowl(caster, ability, aoiEnemies)
		local casterHealth = caster:GetHealthPercent()
		local casterPos = caster:GetAbsOrigin()
		local nTargets = 0

		local castRange = ability:GetCastRange(casterPos, nil) + caster:GetCastRangeBonus() - 50

		return AIHelpers:CastRangeFilter( aoiEnemies, casterPos, castRange, function(unit)
			if not AIHelpers:IsCastable(ability, unit) then return false end

			nTargets = nTargets + 1

			if nTargets >= 2 or casterHealth < 50 then
					
				caster:CastAbilityNoTarget(ability, -1)	

				return true
			end

			return false
		end)
	end

	function PerformBite(caster, ability, aoiEnemies)
		local casterPos = caster:GetAbsOrigin()
		local castRange = ability:GetCastRange(casterPos, nil) + caster:GetCastRangeBonus() - 25

		return AIHelpers:CastRangeFilter( aoiEnemies, casterPos, castRange, function(unit)
			if not AIHelpers:IsCastable(ability, unit) then return false end

			caster:CastAbilityOnTarget(unit, ability, -1)
			
			return true
		end)
	end

	function PerformShadowSupport(caster, ability, aoiEnemies)
		if caster:GetHealthPercent() < 75 or #aoiEnemies >= 2 then
			-- dont enable return if all units is disabled
			for _, x in pairs(aoiEnemies) do
				if not (x:IsStunned() or x:IsHexed() or (x:IsDisarmed() and x:IsSilenced() and x:IsMuted()) ) then
					caster:CastAbilityNoTarget(ability, -1)
					return true
				end
			end
		end

		return false
	end

	function PerformInterception(caster, ability, aoiEnemies)
		local casterHealth = caster:GetHealthPercent()

		if casterHealth < 85 or caster:IsStunned() then
			caster:CastAbilityNoTarget(ability, -1)
			return true
		end

		return false
	end

	function PerformDamnedSouls(caster, ability, aoiEnemies)
		local casterPos = caster:GetAbsOrigin()
		local castRange = ability:GetCastRange(casterPos, nil) + caster:GetCastRangeBonus() - 50

		local nTargets = 0
		local casterHealth = caster:GetHealthPercent()

		return AIHelpers:CastRangeFilter( aoiEnemies, casterPos, castRange, function(unit)
			if not AIHelpers:IsCastable(ability, unit) then return false end

			nTargets = nTargets + 1 

			if nTargets > 2 or casterHealth < 80 then
				caster:CastAbilityNoTarget(ability, -1)

				return true
			end

			return false
		end)
	end

	local unit = thisEntity

	local actions = {
		SimpleAIActions.ForceBack:Make(unit),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("keymaster_interception"), 	PerformInterception),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("keymaster_shadow_support"), 	PerformShadowSupport),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("keymaster_damned_souls"), 	PerformDamnedSouls),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("keymaster_howl"), 			PerformHowl),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("keymaster_bite"), 			PerformBite),
		SimpleAIActions.Attack:Make(unit),
		SimpleAIActions.Back:Make(unit),
	}

	SimpleAI:Make( unit, TICK_TIME, AOI_RANGE, actions )
end