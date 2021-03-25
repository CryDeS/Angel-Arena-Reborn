modifier_huntress_crippling_arrow_slow = modifier_huntress_crippling_arrow_slow or class({})

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_slow:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_slow:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_slow:IsPurgable()
    return true
end

-----------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_slow:OnCreated(kv)
    self.slow_pct = self:GetAbility():GetSpecialValueFor("slow_pct")
end

-------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_slow:OnRefresh(kv)
    self.slow_pct = self:GetAbility():GetSpecialValueFor("slow_pct")
end

-------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_slow:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

-------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_slow:GetModifierMoveSpeedBonus_Percentage(params)
    return -(self.slow_pct)
end

----------------------------------------------------------------------------