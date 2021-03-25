modifier_harpy_big_passive_manaregen = class({})

--------------------------------------------------------------------------------

function modifier_harpy_big_passive_manaregen:IsHidden()
    return true
end

--------------------------------------------------------------------------------

function modifier_harpy_big_passive_manaregen:IsDebuff()
    return false
end
--------------------------------------------------------------------------------

function modifier_harpy_big_passive_manaregen:OnCreated( kv )
    self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
end

--------------------------------------------------------------------------------

function modifier_harpy_big_passive_manaregen:OnRefresh( kv )
    self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
end

--------------------------------------------------------------------------------

function modifier_harpy_big_passive_manaregen:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_harpy_big_passive_manaregen:GetModifierConstantManaRegen( params )
    if self:GetCaster():PassivesDisabled() then
        return 0
    end
    return self.mana_regen
end

--------------------------------------------------------------------------------