modifier_talisman_of_ambition = class({})
--------------------------------------------------------------------------------

function modifier_talisman_of_ambition:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition:OnCreated( kv )
	self.armor 		= self:GetAbility():GetSpecialValueFor("bonus_armor")		or 0
	self.agility 	= self:GetAbility():GetSpecialValueFor("bonus_agility")		or 0
	self.movespeed 	= self:GetAbility():GetSpecialValueFor("bonus_movespeed")	or 0
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition:GetModifierPhysicalArmorBonus( params )
	return self.armor
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition:GetModifierBonusStats_Agility( params )
	return self.agility
end

--------------------------------------------------------------------------------

function modifier_talisman_of_ambition:GetModifierMoveSpeedBonus_Constant( params )
	return self.movespeed
end

--------------------------------------------------------------------------------
