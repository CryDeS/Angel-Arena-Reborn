modifier_huntress_hunting_spirit = modifier_huntress_hunting_spirit or class({})

--------------------------------------------------------------------------------
function modifier_huntress_hunting_spirit:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_huntress_hunting_spirit:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_huntress_hunting_spirit:IsPurgable()
    return false
end

-----------------------------------------------------------------------------
function modifier_huntress_hunting_spirit:GetStatusEffectName(kv)
    return "particles/huntress/huntress_hunting_spirit/huntress_hunting_spirit.vpcf"
end

--------------------------------------------------------------------------------
function modifier_huntress_hunting_spirit:OnCreated(kv)

end

-------------------------------------------------------------------------------
function modifier_huntress_hunting_spirit:OnRefresh(kv)

end

-------------------------------------------------------------------------------
function modifier_huntress_hunting_spirit:CheckState(params)
    local state = {
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
    }
    return state
end

-------------------------------------------------------------------------------
function modifier_huntress_hunting_spirit:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
    }
    return funcs
end

-------------------------------------------------------------------------------
function modifier_huntress_hunting_spirit:GetModifierMoveSpeedBonus_Percentage(params)
    return self:GetAbility():GetSpecialValueFor("bonus_movespeed_pct")
end

-------------------------------------------------------------------------------
function modifier_huntress_hunting_spirit:GetModifierStatusResistance(params)
    return self:GetParent():GetTalentSpecialValueFor("huntress_hunting_spirit_status_resist_tallent")
end

-------------------------------------------------------------------------------