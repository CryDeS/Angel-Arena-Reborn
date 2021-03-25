modifier_megacreep_mage_dic_resist_lua = class({})
--------------------------------------------------------------------------------

function modifier_megacreep_mage_dic_resist_lua:IsDebuff()
    return true
end
--------------------------------------------------------------------------------

function modifier_megacreep_mage_dic_resist_lua:IsHidden()
    return false
end

--------------------------------------------------------------------------------

function modifier_megacreep_mage_dic_resist_lua:OnCreated( kv )
    self.dic_resist = self:GetAbility():GetSpecialValueFor( "dic_resist" )

end

--------------------------------------------------------------------------------

function modifier_megacreep_mage_dic_resist_lua:OnRefresh( kv )
    self.dic_resist = self:GetAbility():GetSpecialValueFor( "dic_resist" )
end

--------------------------------------------------------------------------------

function modifier_megacreep_mage_dic_resist_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_megacreep_mage_dic_resist_lua:GetModifierMagicalResistanceBonus( params )
    return -(self.dic_resist)
end

--------------------------------------------------------------------------------