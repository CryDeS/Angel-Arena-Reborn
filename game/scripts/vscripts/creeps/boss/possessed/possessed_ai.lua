require('lib/ai/simple_ai')

TICK_TIME 			= 0.1
AOI_RANGE 			= 950

function Spawn( entityKeyValues )
	function PerformCurse(caster, ability, aoiEnemies)
		local casterPos = caster:GetAbsOrigin()
		local castRange = ability:GetCastRange(casterPos, nil) + caster:GetCastRangeBonus() - 25

		return AIHelpers:CastRangeFilter( aoiEnemies, casterPos, castRange, function(unit)
			if not AIHelpers:IsCastable(ability, unit) then return false end
			caster:CastAbilityOnTarget(unit, ability, -1)
			return true
		end)
	end

	function PerformHellShield(caster, ability, aoiEnemies)
		if caster:GetHealthPercent() < 75 or #aoiEnemies >= 2 then
			-- dont enable return if all units is disabled
			for _, x in pairs(aoiEnemies) do
				if not (x:IsStunned() or x:IsHexed() or (x:IsDisarmed() and x:IsSilenced() and x:IsMuted()) ) then
					if AIHelpers:IsCastable(ability, x) then
						caster:CastAbilityNoTarget(ability, -1)
						return true
					end
				end
			end
		end

		return false
	end

	function PerformMagmaTrails(caster, ability, aoiEnemies)
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

	-- Ok, stomp have almost same AI like magma trails
	local PerformDevilStomp = PerformMagmaTrails

	local unit = thisEntity

	local actions = {
		SimpleAIActions.ForceBack:Make(unit),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("possessed_hellshield"), 		PerformHellShield),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("possessed_magma_trails"), 	PerformMagmaTrails),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("possessed_devil_stomp"), 	PerformDevilStomp),
		SimpleAIActions.Ability:Make(unit, unit:FindAbilityByName("possessed_curse"), 			PerformCurse),
		SimpleAIActions.Attack:Make(unit),
		SimpleAIActions.Back:Make(unit),
	}

	SimpleAI:Make( unit, TICK_TIME, AOI_RANGE, actions )
end