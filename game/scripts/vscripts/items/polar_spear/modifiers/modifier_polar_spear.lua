modifier_polar_spear = class({})
--------------------------------------------------------------------------------

function modifier_polar_spear:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_polar_spear:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_polar_spear:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_polar_spear:OnCreated( kv )

end

--------------------------------------------------------------------------------

function modifier_polar_spear:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_polar_spear:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_polar_spear:GetModifierManaBonus( params )
	return self:GetAbility():GetSpecialValueFor("bonus_mana") or 0
end

--------------------------------------------------------------------------------

function modifier_polar_spear:GetModifierHealthBonus( params )
	return self:GetAbility():GetSpecialValueFor("bonus_hp") or 0
end

--------------------------------------------------------------------------------

function modifier_polar_spear:GetModifierBonusStats_Intellect( params )
	return self:GetAbility():GetSpecialValueFor("bonus_int") or 0
end

--------------------------------------------------------------------------------
