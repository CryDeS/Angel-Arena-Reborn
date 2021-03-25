modifier_small_satyr_little_slow = class({})

--------------------------------------------------------------------------------

function modifier_small_satyr_little_slow:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_small_satyr_little_slow:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_small_satyr_little_slow:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_small_satyr_little_slow:OnCreated( kv )
	self.percent = self:GetAbility():GetSpecialValueFor( "percent" )
	print(percent)
end

--------------------------------------------------------------------------------

function modifier_small_satyr_little_slow:OnRefresh( kv )
	self.percent = self:GetAbility():GetSpecialValueFor( "percent" )
end

--------------------------------------------------------------------------------

function modifier_small_satyr_little_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_small_satyr_little_slow:GetModifierMoveSpeedBonus_Percentage( params )
	return self.percent
end