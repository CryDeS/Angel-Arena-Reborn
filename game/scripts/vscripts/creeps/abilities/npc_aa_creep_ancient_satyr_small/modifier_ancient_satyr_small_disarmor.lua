modifier_ancient_satyr_small_disarmor = class({})

--------------------------------------------------------------------------------

function modifier_ancient_satyr_small_disarmor:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_ancient_satyr_small_disarmor:GetEffectName()
	return "particles/items2_fx/medallion_of_courage.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ancient_satyr_small_disarmor:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_ancient_satyr_small_disarmor:OnCreated( kv )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" )
end

--------------------------------------------------------------------------------

function modifier_ancient_satyr_small_disarmor:OnRefresh( kv )
	self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" )
end

--------------------------------------------------------------------------------

function modifier_ancient_satyr_small_disarmor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ancient_satyr_small_disarmor:GetModifierPhysicalArmorBonus( params )
	return -(self.armor_reduction)
end