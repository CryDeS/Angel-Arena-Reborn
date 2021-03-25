modifier_keymaster_shadow_support = modifier_keymaster_shadow_support or class({})
local mod = modifier_keymaster_shadow_support

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end
function mod:DestroyOnExpire() 	return true end

function mod:GetEffectName()
	return "particles/items_fx/blademail.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function testflag(set, flag)
	return set % (2*flag) >= flag
end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability or ability:IsNull() then return end

	self.returnDamage = ability:GetSpecialValueFor("return_damage") / 100
end

if IsServer() then
	function mod:DeclareFunctions() return
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	end

	function mod:OnTakeDamage( params )
		if not self or self:IsNull() then return end

		local parent = self:GetParent()

		if not parent or parent:IsNull() then return end

		if params.unit ~= parent then return end

		if testflag(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) then return end 

		local target = params.attacker

		if not target then return end

		if target:IsNull() then return end

		if target:IsInvulnerable() then return end

		local ability = self:GetAbility()

		if not ability or ability:IsNull() then return end

		if parent:IsIllusion() then return end 

		ApplyDamage({
			victim 		 = target,
			attacker 	 = parent,
			damage 		 = params.damage * self.returnDamage,
			damage_type  = DAMAGE_TYPE_PURE,
			ability 	 = ability,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
		})

		local idx = ParticleManager:CreateParticle("particles/econ/items/nyx_assassin/nyx_ti9_immortal/nyx_ti9_carapace_crimson_hit_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt( idx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

		target:EmitSound("Boss_Keymaster.ShadowSupport.Damage")
	end
end