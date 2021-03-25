modifier_center_of_peace_active_channel = class({})
--------------------------------------------------------------------------------
function modifier_center_of_peace_active_channel:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_center_of_peace_active_channel:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_center_of_peace_active_channel:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_center_of_peace_active_channel:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_center_of_peace_active_channel:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_center_of_peace_active_channel:GetTexture()
    return "../items/center_of_peace_big"
end

--------------------------------------------------------------------------------
function modifier_center_of_peace_active_channel:GetEffectName()
    return "particles/center_of_peace/center_of_peace_channel.vpcf"
end

--------------------------------------------------------------------------------
function modifier_center_of_peace_active_channel:OnCreated(kv)
    self.mana_regen_total_pct = self:GetAbility():GetSpecialValueFor("mana_regen_total_pct") / 100
    self.bonus_magical_resist = self:GetAbility():GetSpecialValueFor("bonus_magical_resist")
end

--------------------------------------------------------------------------------
function modifier_center_of_peace_active_channel:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_center_of_peace_active_channel:GetModifierMagicalResistanceBonus(kv)
    return self.bonus_magical_resist
end

function modifier_center_of_peace_active_channel:GetModifierTotalPercentageManaRegen(kv)
    return self.mana_regen_total_pct
end