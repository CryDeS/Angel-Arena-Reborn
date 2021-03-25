modifier_creep_bear_small_regen_lua = class({})

--------------------------------------------------------------------------------

function modifier_creep_bear_small_regen_lua:IsHidden()
    return false
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_regen_lua:IsDebuff()
    return false
end
--------------------------------------------------------------------------------

function modifier_creep_bear_small_regen_lua:OnCreated( kv )
    self.bonus_regen = self:GetAbility():GetSpecialValueFor( "bonus_regen" )
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_regen_lua:OnRefresh( kv )
    self.bonus_regen = self:GetAbility():GetSpecialValueFor( "bonus_regen" )
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_regen_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_creep_bear_small_regen_lua:GetModifierConstantHealthRegen( params )
    if self:GetCaster():PassivesDisabled() then
        return 0
    end
    return self.bonus_regen
end

--------------------------------------------------------------------------------