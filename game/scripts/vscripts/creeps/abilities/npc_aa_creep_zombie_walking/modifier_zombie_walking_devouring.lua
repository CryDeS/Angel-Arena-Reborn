modifier_zombie_walking_devouring = class({})
--------------------------------------------------------------------------------
function modifier_zombie_walking_devouring:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_devouring:IsStunned()
    return true
end

----------------------------------------------------------------------------------
function modifier_zombie_walking_devouring:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_devouring:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_devouring:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_devouring:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_devouring:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_devouring:GetOverrideAnimation(params)
    return ACT_DOTA_DISABLED
end
--------------------------------------------------------------------------------