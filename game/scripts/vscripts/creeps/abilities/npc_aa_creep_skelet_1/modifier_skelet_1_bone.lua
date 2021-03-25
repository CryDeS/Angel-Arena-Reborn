modifier_skelet_1_bone = class({})
--------------------------------------------------------------------------------
function modifier_skelet_1_bone:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_skelet_1_bone:IsStunned()
    return true
end

----------------------------------------------------------------------------------
function modifier_skelet_1_bone:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_skelet_1_bone:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------
function modifier_skelet_1_bone:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
function modifier_skelet_1_bone:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_skelet_1_bone:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

--------------------------------------------------------------------------------
function modifier_skelet_1_bone:GetOverrideAnimation(params)
    return ACT_DOTA_DISABLED
end
--------------------------------------------------------------------------------