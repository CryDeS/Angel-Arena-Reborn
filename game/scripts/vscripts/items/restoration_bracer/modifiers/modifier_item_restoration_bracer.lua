modifier_item_restoration_bracer = modifier_item_restoration_bracer or class({})
local mod = modifier_item_restoration_bracer

function mod:IsHidden() 		return true  end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	self.bonusStr = self:GetAbility():GetSpecialValueFor("bonus_str")
	self.bonusHpReg = self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end

function mod:GetModifierBonusStats_Strength()
	return self.bonusStr
end

function mod:GetModifierConstantHealthRegen()
	return self.bonusHpReg
end