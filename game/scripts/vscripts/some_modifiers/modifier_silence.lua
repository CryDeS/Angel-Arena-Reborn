modifier_silence = class({})
--------------------------------------------------------------------------------
function modifier_silence:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_silence:IsSilenced()
    return true
end

----------------------------------------------------------------------------------
function modifier_silence:GetEffectName()
    return "particles/generic_gameplay/generic_silenced.vpcf"
end

--------------------------------------------------------------------------------
function modifier_silence:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
function modifier_silence:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
    }
    return state
end

--------------------------------------------------------------------------------