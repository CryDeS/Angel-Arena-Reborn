modifier_item_consumption_orb = modifier_item_consumption_orb or class({})
local mod = modifier_item_consumption_orb

function mod:IsHidden() 		return true  end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	local ability = self:GetAbility()
	if not ability then return end

	self.bonusDamage = ability:GetSpecialValueFor("bonus_damage")
	self.bonusStr    = ability:GetSpecialValueFor("bonus_str")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
}
end

function mod:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage or 0
end

function mod:GetModifierBonusStats_Strength()
	return self.bonusStr or 0
end
