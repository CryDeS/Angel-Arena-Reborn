modifier_spiked_armor_aura_enemy = class({})
--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.1, function() 
			if not self or self:IsNull() then return end
				local disarmor = self:GetParent():GetPhysicalArmorValue( false ) - self:GetModifierPhysicalArmorBonus()

				CustomNetTables:SetTableValue("items", "modifier_spiked_armor_disarmor" .. self:GetParent():entindex() , 
					{ base_armor = disarmor }
					)
			return 0.1
		end)

	end
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy:GetTexture()
	return "../items/spiked_armor_big"
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy:DestroyOnExpire()
	return true
end

------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs 
end

--------------------------------------------------------------------------------

function modifier_spiked_armor_aura_enemy:GetModifierPhysicalArmorBonus()
    local ability = self:GetAbility()

    if not ability then return 0 end

    local disarmor_tbl = CustomNetTables:GetTableValue("items", "modifier_spiked_armor_disarmor" .. self:GetParent():entindex() )
	local base_armor = 0

	if disarmor_tbl then
		base_armor = disarmor_tbl.base_armor
	end

	return -(base_armor * (ability:GetSpecialValueFor("disarmor_aura_pct") / 100 )) + ability:GetSpecialValueFor("disarmor_aura")

end
