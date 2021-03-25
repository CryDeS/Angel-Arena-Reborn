modifier_item_cursed_orb = modifier_item_cursed_orb or class({})
local mod = modifier_item_cursed_orb

function mod:IsHidden() 		return true  end
function mod:IsPurgable() 		return false end
function mod:DestroyOnExpire() 	return false end
function mod:IsPurgable() 		return false end
function mod:IsPurgeException() return false end

function mod:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end

function mod:OnCreated(kv)
	self.bonusStats = self:GetAbility():GetSpecialValueFor("bonus_all")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions() return
{
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
}
end

function mod:GetModifierBonusStats_Strength()
	return self.bonusStats
end

function mod:GetModifierBonusStats_Intellect()
	return self.bonusStats
end

function mod:GetModifierBonusStats_Agility()
	return self.bonusStats
end
