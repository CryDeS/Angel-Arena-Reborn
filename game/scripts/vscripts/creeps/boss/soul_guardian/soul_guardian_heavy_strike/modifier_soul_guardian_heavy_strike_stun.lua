modifier_soul_guardian_heavy_strike_stun = modifier_soul_guardian_heavy_strike_stun or class({})
local mod = modifier_soul_guardian_heavy_strike_stun

function mod:IsHidden()         return false end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end
function mod:RemoveOnDeath() 	return true	 end
function mod:IsDebuff() 		return true	 end
function mod:IsStunned() 		return true	 end

function mod:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end

function mod:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function mod:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end

function mod:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

function mod:GetOverrideAnimation()
    return ACT_DOTA_DISABLED
end
