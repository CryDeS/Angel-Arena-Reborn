modifier_amaliels_cuirass_aura_enemy = class({})
--------------------------------------------------------------------------------

function modifier_amaliels_cuirass_aura_enemy:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass_aura_enemy:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass_aura_enemy:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass_aura_enemy:OnCreated()

end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass_aura_enemy:GetTexture()
	return "../items/amaliels_cuirass_big"
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass_aura_enemy:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass_aura_enemy:DestroyOnExpire()
	return true
end

------------------------------------------------------------------------------

function modifier_amaliels_cuirass_aura_enemy:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs 
end

--------------------------------------------------------------------------------

function modifier_amaliels_cuirass_aura_enemy:GetModifierPhysicalArmorBonus()
    local ability = self:GetAbility()

    if not ability then return 0 end
	local disarmor_aura = ability:GetSpecialValueFor("disarmor_aura")
	return disarmor_aura

end
