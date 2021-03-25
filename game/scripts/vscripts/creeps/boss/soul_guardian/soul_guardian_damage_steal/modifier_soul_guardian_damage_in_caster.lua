modifier_soul_guardian_damage_in_caster = modifier_soul_guardian_damage_in_caster or class({})
local mod = modifier_soul_guardian_damage_in_caster

function mod:IsHidden()         return true  end
function mod:DestroyOnExpire()  return true end
function mod:IsPurgable()       return false end
function mod:IsPurgeException() return false end
function mod:RemoveOnDeath()	return true end

function mod:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_DISABLE_TURNING,
    }
    return funcs
end

function mod:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED] = true,
    }

    return state
end

function mod:GetOverrideAnimation()
    return ACT_DOTA_GENERIC_CHANNEL_1
end

function mod:GetModifierDisableTurning()
	return 1
end

