modifier_stun = class({})
--------------------------------------------------------------------------------
function modifier_stun:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_stun:IsStunned()
    return true
end

----------------------------------------------------------------------------------
function modifier_stun:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------
function modifier_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
function modifier_stun:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_stun:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

--------------------------------------------------------------------------------
function modifier_stun:GetOverrideAnimation(params)
    return ACT_DOTA_DISABLED
end
--------------------------------------------------------------------------------