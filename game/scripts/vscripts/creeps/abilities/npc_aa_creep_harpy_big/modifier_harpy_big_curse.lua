modifier_harpy_big_curse = class({})
--------------------------------------------------------------------------------

function modifier_harpy_big_curse:IsDebuff()
    return true
end
--------------------------------------------------------------------------------

function modifier_harpy_big_curse:IsHidden()
    return false
end

--------------------------------------------------------------------------------

function modifier_harpy_big_curse:GetStatusEffectName()
    return "particles/status_fx/status_effect_enigma_malefice.vpcf"
end

--------------------------------------------------------------------------------

function modifier_harpy_big_curse:OnCreated( kv )
    self.increase_damage = self:GetAbility():GetSpecialValueFor( "increase_damage" )

end

--------------------------------------------------------------------------------

function modifier_harpy_big_curse:OnRefresh( kv )
    self.increase_damage = self:GetAbility():GetSpecialValueFor( "increase_damage" )
end

--------------------------------------------------------------------------------

function modifier_harpy_big_curse:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_harpy_big_curse:GetModifierIncomingDamage_Percentage( params )
    return self.increase_damage
end

--------------------------------------------------------------------------------