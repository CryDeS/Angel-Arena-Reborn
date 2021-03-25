modifier_fireblade_fiery_stream_debuff = class({})

--------------------------------------------------------------------------------
function modifier_fireblade_fiery_stream_debuff:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_fireblade_fiery_stream_debuff:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
function modifier_fireblade_fiery_stream_debuff:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_fireblade_fiery_stream_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end


--------------------------------------------------------------------------------
function modifier_fireblade_fiery_stream_debuff:GetEffectName()
    return "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster_embers.vpcf"
end

--------------------------------------------------------------------------------
function modifier_fireblade_fiery_stream_debuff:GetModifierMoveSpeedBonus_Percentage()
  return -self.slow
end
--------------------------------------------------------------------------------
function modifier_fireblade_fiery_stream_debuff:OnCreated()
    self.slow = self:GetAbility():GetSpecialValueFor("slow")
end
--------------------------------------------------------------------------------

