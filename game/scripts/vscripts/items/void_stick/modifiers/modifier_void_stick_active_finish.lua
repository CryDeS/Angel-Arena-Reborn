modifier_void_stick_active_finish = class({})
--------------------------------------------------------------------------------
function modifier_void_stick_active_finish:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_void_stick_active_finish:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_void_stick_active_finish:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_void_stick_active_finish:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_void_stick_active_finish:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_void_stick_active_finish:GetTexture()
    return "../items/void_stick_big"
end

--------------------------------------------------------------------------------
function modifier_void_stick_active_finish:GetEffectName()
    return "particles/void_stick/void_stick_finish.vpcf"
end

--------------------------------------------------------------------------------
function modifier_void_stick_active_finish:OnCreated(kv)
    self.after_cast_mana_regen = self:GetAbility():GetSpecialValueFor("after_cast_mana_regen")
    self.after_cast_reduce_manacost_pct = self:GetAbility():GetSpecialValueFor("after_cast_reduce_manacost_pct")
end

--------------------------------------------------------------------------------
function modifier_void_stick_active_finish:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_void_stick_active_finish:GetModifierConstantManaRegen(kv)
    return self.after_cast_mana_regen
end

--------------------------------------------------------------------------------
function modifier_void_stick_active_finish:GetModifierPercentageManacost(kv)
    return self.after_cast_reduce_manacost_pct
end

--------------------------------------------------------------------------------
