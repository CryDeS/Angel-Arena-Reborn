modifier_item_magician_ring_buff = class({})
--------------------------------------------------------------------------------

function modifier_item_magician_ring_buff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring_buff:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring_buff:IsPurgable()
	return false
end

function modifier_item_magician_ring_buff:AllowIllusionDuplicate()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring_buff:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring_buff:GetTexture()
	return "../items/magician_ring_big"
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring_buff:OnCreated( kv )

end

--------------------------------------------------------------------------------

function modifier_item_magician_ring_buff:OnDestroy( kv )
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_magician_ring_buff:GetModifierPercentageCooldown( params )
	return (self:GetAbility():GetSpecialValueFor("cooldown_reduce") or 0) * self:GetStackCount()
end
