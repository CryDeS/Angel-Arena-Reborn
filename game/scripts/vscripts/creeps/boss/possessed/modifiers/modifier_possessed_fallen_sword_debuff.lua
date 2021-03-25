modifier_possessed_fallen_sword_debuff = modifier_possessed_fallen_sword_debuff or class({})
local mod = modifier_possessed_fallen_sword_debuff

function mod:IsDebuff() 		return false end
function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return true end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return true end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.damageModifier = -ability:GetSpecialValueFor("damage_reduction")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
}
end

function mod:GetModifierTotalDamageOutgoing_Percentage()
	return self.damageModifier or 0
end

function mod:GetEffectName()
	return "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
