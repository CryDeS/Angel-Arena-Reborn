require('lib/common_abilities/auto_textured')

modifier_soul_collector_active_debuff = CommonAbilities:ConstructModifier( modifier_soul_collector_active_debuff, CommonAbilities.AutoTextured )

local mod = modifier_soul_collector_active_debuff

function mod:IsHidden()         return false end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return true end
function mod:RemoveOnDeath()    return true end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.decreaseHealPct = -ability:GetSpecialValueFor("decrease_heal_pct")
	self.slowPercentage  = -ability:GetSpecialValueFor("slow_percent")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
}
end

function mod:GetModifierHPRegenAmplify_Percentage(kv)
	return self.decreaseHealPct
end

function mod:GetModifierHealAmplify_PercentageTarget(kv)
	return self.decreaseHealPct
end

function mod:GetModifierMoveSpeedBonus_Percentage(kv) 
	return self.slowPercentage 
end
