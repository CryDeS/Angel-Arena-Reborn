keymaster_bite = keymaster_bite or class({})

local ability = keymaster_bite

LinkLuaModifier( "modifier_keymaster_bite", 'creeps/boss/keymaster/modifiers/modifier_keymaster_bite', LUA_MODIFIER_MOTION_NONE )

function ability:OnSpellStart()
	if not IsServer() then return end
	if not self or self:IsNull() then return end

	local target    = self:GetCursorTarget()
	local caster    = self:GetCaster()
	
	if not target or target:IsNull() then return end
	if not caster or caster:IsNull() then return end

	local damage    = self:GetSpecialValueFor("damage")
	local killLimit = self:GetSpecialValueFor("kill_limit_pct")

	ApplyDamage({
		victim 		= target,
		attacker 	= caster,
		ability 	= self,
		damage 		= damage,
		damage_type = self:GetAbilityDamageType(),
	})

	caster:EmitSound("Boss_Keymaster.Bite.Cast")

	if target:GetHealthPercent() < killLimit then
		caster:EmitSound("Boss_Keymaster.Bite.Kill")
		target:Kill(self, caster)

		ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	else
		local debuffDuration = self:GetSpecialValueFor("debuff_duration")

		target:AddNewModifier(caster, self, "modifier_keymaster_bite", { duration = debuffDuration })

		local idx = ParticleManager:CreateParticle("particles/econ/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_impact_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt( idx, 3, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end
end

