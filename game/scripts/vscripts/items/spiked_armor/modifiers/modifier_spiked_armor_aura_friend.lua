modifier_spiked_armor_aura_friend = class({})
--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_friend:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_friend:IsDebuff()
	return false
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_friend:GetTexture()
	return "../items/spiked_armor_big"
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_friend:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_friend:DestroyOnExpire()
	return true
end

------------------------------------------------------------------------------

function modifier_spiked_armor_aura_friend:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs 
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_friend:GetModifierPhysicalArmorBonus()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_armor_aura")
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_friend:GetModifierAttackSpeedBonus_Constant()
    local ability = self:GetAbility()

    if not ability then return 0 end

    return ability:GetSpecialValueFor("bonus_aspeed_aura")
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_friend:OnCreated( kv )

end

---------------------------------------------------------------------------------

function modifier_spiked_armor_aura_friend:OnDestroy()

end