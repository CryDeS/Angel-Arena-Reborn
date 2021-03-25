modifier_item_dimensional_accelerator = modifier_item_dimensional_accelerator or class({})
local mod = modifier_item_dimensional_accelerator

function mod:IsHidden() 		return true  end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function mod:OnCreated(kv)
	self.bonusAttackRange = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
	self.bonusAs = self:GetAbility():GetSpecialValueFor("bonus_as")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function mod:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return self.bonusAttackRange
	end

	return 0
end

function mod:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAs
end