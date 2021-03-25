modifier_dark_edge_debuff = modifier_dark_edge_debuff or class({})
local mod = modifier_dark_edge_debuff

function mod:IsHidden()         return false  end
function mod:IsPurgable()       return false end
function mod:IsDebuff()       	return true end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return true end

function mod:OnCreated( kv )
	local ability = self:GetAbility()

	if not ability then return end

	self.damageReduction 	= -ability:GetSpecialValueFor("backstab_reduction")
	self.hpRestoreReduction = -ability:GetSpecialValueFor("decrease_heal_pct")
end

mod.OnRefresh = mod.OnCreated

function mod:CheckState() return
{
	[MODIFIER_STATE_PASSIVES_DISABLED] = true,
}
end

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
}
end

function mod:GetModifierTotalDamageOutgoing_Percentage( params )
	return self.damageReduction
end

function mod:GetModifierHPRegenAmplify_Percentage(kv)
    return -self.hpRestoreReduction
end

mod.GetModifierHealAmplify_PercentageTarget = mod.GetModifierHPRegenAmplify_Percentage
