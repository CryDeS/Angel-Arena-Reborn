modifier_item_steel_frame = modifier_item_steel_frame or class({})
local mod = modifier_item_steel_frame

function mod:IsHidden() 		return true  end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	self.bonusDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonusAs    = self:GetAbility():GetSpecialValueFor("bonus_as")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function mod:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage
end

function mod:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAs
end
