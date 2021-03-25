modifier_huntress_crippling_arrow_root = modifier_huntress_crippling_arrow_root or class({})

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_root:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_root:IsRooted()
    return true
end

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_root:GetEffectName()
    return "particles/units/heroes/hero_lone_druid/lone_druid_bear_entangle_body.vpcf"
end

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_root:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_huntress_crippling_arrow_root:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
    }
    return state
end

--------------------------------------------------------------------------------