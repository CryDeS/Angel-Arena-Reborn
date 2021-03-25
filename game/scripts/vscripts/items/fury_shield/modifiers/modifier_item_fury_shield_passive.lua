modifier_item_fury_shield_passive = class({})
--------------------------------------------------------------------------------

function modifier_item_fury_shield_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_passive:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_passive:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_passive:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_passive:GetModifierBonusStats_Strength( params )
	return self:GetAbility():GetSpecialValueFor("bonus_stats") or 0
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_passive:GetModifierBonusStats_Agility( params )
	return self:GetAbility():GetSpecialValueFor("bonus_stats") or 0
end

--------------------------------------------------------------------------------

function modifier_item_fury_shield_passive:GetModifierBonusStats_Intellect( params )
	return self:GetAbility():GetSpecialValueFor("bonus_stats") or 0
end

--------------------------------------------------------------------------------
