modifier_sealed_rune = modifier_sealed_rune or class({})
local mod = modifier_sealed_rune

function mod:IsHidden()         return true  end
function mod:IsPurgable()       return false end
function mod:DestroyOnExpire()  return false end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	local ability = self:GetAbility()

	if not ability then return end

	self.bonusDamage = ability:GetSpecialValueFor("bonus_damage")
	self.bonusAs 	 = ability:GetSpecialValueFor("bonus_as")
	self.bonusAgi    = ability:GetSpecialValueFor("bonus_agi")
	self.bonusStr    = ability:GetSpecialValueFor("bonus_str")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return 
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
}
end

function mod:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function mod:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAs
end

function mod:GetModifierBonusStats_Agility()
	return self.bonusAgi
end

function mod:GetModifierBonusStats_Strength()
	return self.bonusStr
end