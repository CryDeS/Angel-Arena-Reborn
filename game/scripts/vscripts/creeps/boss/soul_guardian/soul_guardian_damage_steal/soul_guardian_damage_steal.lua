soul_guardian_damage_steal = class({})
local damageStealModifierName = "modifier_soul_guardian_damage_steal"
local modifierInCaster = "modifier_soul_guardian_damage_in_caster"
LinkLuaModifier(damageStealModifierName, "creeps/boss/soul_guardian/soul_guardian_damage_steal/"..damageStealModifierName, LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(modifierInCaster, "creeps/boss/soul_guardian/soul_guardian_damage_steal/"..modifierInCaster, LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
function soul_guardian_damage_steal:OnSpellStart()
	for _, var_name in pairs({ 
		"duration", 
		"radius", 
		"delay_for_start",
		"interval",
		"damage_per_tick",
		"debuff_duration",
	}) do
		self[var_name] = self:GetSpecialValueFor(var_name)
	end

	local caster = self:GetCaster()
	caster.channelDamageSteal = true
	local particleDelay = ParticleManager:CreateParticle(
		"particles/bosses/soul_guardian/soul_guardian_damage_steal/soul_guardian_damage_steal_delay.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

	ParticleManager:SetParticleControlEnt(particleDelay, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	Timers:CreateTimer(self.delay_for_start, function()
		local particleStealDamage = ParticleManager:CreateParticle(
			"particles/bosses/soul_guardian/soul_guardian_damage_steal/soul_guardian_damage_steal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

		ParticleManager:SetParticleControlEnt(particleStealDamage, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		caster:AddNewModifier( caster, self, modifierInCaster, { duration = self.duration } )
		local currentTime = 0
		Timers:CreateTimer(0, function()
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
				caster:GetAbsOrigin(),
				nil,
				self.radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)
			for _, enemy in pairs(enemies) do
				local modifier = enemy:FindModifierByName(damageStealModifierName)
				if not modifier then
					modifier = enemy:AddNewModifier(caster, self, damageStealModifierName, { duration = durationDamageReduction })
				end
				modifier:SetDuration(self.debuff_duration, true)
				enemy:SetModifierStackCount(damageStealModifierName, nil, modifier:GetStackCount() + self.damage_per_tick)
			end

			currentTime = currentTime + self.interval
			if currentTime < self.duration and caster:IsAlive() then
				return self.interval
			else
				caster.channelDamageSteal = false
				ParticleManager:DestroyParticle(particleDelay, false)
				ParticleManager:DestroyParticle(particleStealDamage, false)
				return nil
			end
		end)
	end)

end

--------------------------------------------------------------------------------
