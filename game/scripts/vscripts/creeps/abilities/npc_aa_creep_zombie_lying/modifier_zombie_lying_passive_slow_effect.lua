modifier_zombie_lying_passive_slow_effect = class({})

--------------------------------------------------------------------------------
function modifier_zombie_lying_passive_slow_effect:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_zombie_lying_passive_slow_effect:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_zombie_lying_passive_slow_effect: IsPurgable()
    return true
end

-----------------------------------------------------------------------------
function modifier_zombie_lying_passive_slow_effect:OnCreated(kv)
    if not self:GetAbility() then return end
    self.slow_pct = self:GetAbility():GetSpecialValueFor("slow_pct")
end

-------------------------------------------------------------------------------
function modifier_zombie_lying_passive_slow_effect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

-------------------------------------------------------------------------------
function modifier_zombie_lying_passive_slow_effect:GetModifierMoveSpeedBonus_Percentage(params)
    if self:GetCaster():PassivesDisabled() then
        return 0
    end
    return -(self.slow_pct)
end

----------------------------------------------------------------------------