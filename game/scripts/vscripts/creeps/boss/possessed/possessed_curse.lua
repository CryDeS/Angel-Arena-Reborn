possessed_curse = possessed_curse or class({})

local ability = possessed_curse

LinkLuaModifier( "modifier_possessed_curse_start", 	 'creeps/boss/possessed/modifiers/modifier_possessed_curse_start', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_possessed_curse_penalty", 'creeps/boss/possessed/modifiers/modifier_possessed_curse_penalty', LUA_MODIFIER_MOTION_NONE )

function ability:FindUnits(caster, position, radius)
	return FindUnitsInRadius( 	caster:GetTeamNumber(),
								position,
							 	caster,
							 	radius,
							 	self:GetAbilityTargetTeam(),
							 	self:GetAbilityTargetType(),
							 	self:GetAbilityTargetFlags(),
							 	FIND_ANY_ORDER, 
							 	false )		
end

function ability:OnSpellStart()
	if not IsServer() then return end

	local caster		= self:GetCaster()
	local target 		= self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then return end

	local radius   = self:GetCastRange( caster:GetAbsOrigin(), nil ) + caster:GetCastRangeBonus()
	local duration = self:GetSpecialValueFor("run_duration")
	local pos 	   = target:GetAbsOrigin()	

	local penaltyLen 	= self:GetSpecialValueFor("run_radius")
	local penaltyDebuff = self:GetSpecialValueFor("penalty_stun")
	local penaltyDamage = self:GetSpecialValueFor("penalty_damage_pct") / 100

	local damageType = self:GetAbilityDamageType()

	local mod = target:AddNewModifier(caster, self, "modifier_possessed_curse_start", { duration = -1 })

	target:EmitSound("Boss_Possessed.Curse.Cast")

	Timers:CreateTimer( duration, function()
		if not target or target:IsNull() or not IsValidEntity(target) then return end

		if not target:IsAlive() then return end

		if mod and not mod:IsNull() then
			mod:Destroy()
		end

		if not self or self:IsNull() then return end
		if not caster or caster:IsNull() or not IsValidEntity(caster) then return end
		if not caster:IsAlive() then return end

		local newPos = target:GetAbsOrigin()

		if (newPos - pos):Length() < penaltyLen then
			ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_ABSORIGIN, target)

			target:EmitSound("Boss_Possessed.Curse.Penalty")

			local damage = target:GetMaxHealth() * penaltyDamage

			local heal = ApplyDamage({
				victim		= target,
				attacker	= caster,
				damage 		= damage,
				damage_type = damageType,
				ability 	= self,
			})

			caster:Heal(heal, self)

			if target:IsAlive() then
				target:AddNewModifier(caster, self, "modifier_possessed_curse_penalty", { duration = penaltyDebuff })
			end
		else
			ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN, target)

			target:EmitSound("Boss_Possessed.Curse.Saved")
		end
	end)
end
