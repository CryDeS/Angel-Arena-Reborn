modifier_harpy_small_dive_active_stun = class({})
--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active_stun:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active_stun:IsStunned()
    return true
end

----------------------------------------------------------------------------------
function modifier_harpy_small_dive_active_stun:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active_stun:RemoveOnDeath()
    return true
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active_stun:IsPurgable()
    return true
end

-------------------------------------------------------------------------------
function modifier_harpy_small_dive_active_stun:DestroyOnExpire()
    return true
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active_stun:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active_stun:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

--------------------------------------------------------------------------------
function modifier_harpy_small_dive_active_stun:GetOverrideAnimation(params)
    return ACT_DOTA_DISABLED
end
--------------------------------------------------------------------------------

