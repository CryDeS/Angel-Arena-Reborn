modifier_rubick_dagon_passive = class({})

--------------------------------------------------------------------------------

function modifier_rubick_dagon_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_rubick_dagon_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_rubick_dagon_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_rubick_dagon_passive:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

--------------------------------------------------------------------------------

function modifier_rubick_dagon_passive:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_att")
end

--------------------------------------------------------------------------------

function modifier_rubick_dagon_passive:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_att")
end

--------------------------------------------------------------------------------

function modifier_rubick_dagon_passive:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int") + self:GetAbility():GetSpecialValueFor("bonus_att")
end

--------------------------------------------------------------------------------
