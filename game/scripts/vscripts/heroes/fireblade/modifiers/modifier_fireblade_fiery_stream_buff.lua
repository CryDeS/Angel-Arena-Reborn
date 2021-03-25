modifier_fireblade_fiery_stream_buff = class({})


--------------------------------------------------------------------------------

function modifier_fireblade_fiery_stream_buff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_fireblade_fiery_stream_buff:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_fireblade_fiery_stream_buff:IsPurgable()
	return false
end

function modifier_fireblade_fiery_stream_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------

function modifier_fireblade_fiery_stream_buff:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_fireblade_fiery_stream_buff:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_per_hero" )
end

--------------------------------------------------------------------------------

function modifier_fireblade_fiery_stream_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_fireblade_fiery_stream_buff:GetModifierPreAttack_BonusDamage()
	return self.damage
end

--------------------------------------------------------------------------------
