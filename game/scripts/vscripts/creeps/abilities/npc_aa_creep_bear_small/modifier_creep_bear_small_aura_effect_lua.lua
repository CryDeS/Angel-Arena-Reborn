modifier_creep_bear_small_aura_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_creep_bear_small_aura_effect_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_aura_effect_lua:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_aura_effect_lua:OnCreated( kv )
	if self:GetAbility() then
		self.bonus_movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
		self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	end
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_aura_effect_lua:GetModifierMoveSpeedBonus_Constant( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end
	return self.bonus_movespeed
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_aura_effect_lua:GetModifierPreAttack_BonusDamage( params )
	if self:GetCaster():PassivesDisabled() then
		return 0
	end
	return self.bonus_damage
end

--------------------------------------------------------------------------------

