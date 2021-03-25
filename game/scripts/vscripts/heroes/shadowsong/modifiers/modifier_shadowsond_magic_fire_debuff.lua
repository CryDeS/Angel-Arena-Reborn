modifier_shadowsond_magic_fire_debuff = class({})
mod = modifier_shadowsond_magic_fire_debuff

function mod:IsHidden() 		return false end
function mod:IsPurgable() 		return true end
function mod:DestroyOnExpire() 	return true end
function mod:IsPurgeException() return true end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
}
end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	self.statusResist = -ability:GetSpecialValueFor("status_resist_debuff")
	self.healDecrease = -ability:GetSpecialValueFor("heal_decrease_debuff")
end

mod.OnRefresh = mod.OnCreated

function mod:GetModifierStatusResistanceStacking() 
	return self.statusResist * self:GetStackCount()
end

function mod:GetModifierHPRegenAmplify_Percentage(kv)
    return self.healDecrease * self:GetStackCount()
end

mod.GetModifierHealAmplify_PercentageTarget = GetModifierHPRegenAmplify_Percentage

function mod:GetEffectName()
	return "particles/econ/items/lich/lich_ti8_immortal_arms/lich_ti8_ambient_flare.vpcf"
end

function mod:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end