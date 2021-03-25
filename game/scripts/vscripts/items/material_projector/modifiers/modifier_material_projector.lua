modifier_material_projector = modifier_material_projector or class({})
local mod = modifier_material_projector

function mod:IsHidden() 		return true  end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	local ability = self:GetAbility()
	
	if not ability then return end

	self.hp 		 = ability:GetSpecialValueFor("bonus_hp")
	self.bonusStats  = ability:GetSpecialValueFor("bonus_stats")
	self.bonusDamage = ability:GetSpecialValueFor("bonus_damage")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
}
end

function mod:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function mod:GetModifierHealthBonus()
	return self.hp
end

function mod:GetModifierBonusStats_Strength( ... )
	return self.bonusStats
end

mod.GetModifierBonusStats_Intellect = mod.GetModifierBonusStats_Strength
mod.GetModifierBonusStats_Agility   = mod.GetModifierBonusStats_Strength