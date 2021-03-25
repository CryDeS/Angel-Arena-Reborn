modifier_megacreep_mage_sleep_lua = class({})
--------------------------------------------------------------------------------

function modifier_megacreep_mage_sleep_lua:IsDebuff()
    return true
end
--------------------------------------------------------------------------------

function modifier_megacreep_mage_sleep_lua:IsHidden()
    return false
end
--------------------------------------------------------------------------------

function modifier_megacreep_mage_sleep_lua:GetEffectName()
    return "particles/units/heroes/hero_bane/bane_nightmare.vpcf"
end
--------------------------------------------------------------------------------

function modifier_megacreep_mage_sleep_lua:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
function modifier_megacreep_mage_sleep_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
    return funcs
end
--------------------------------------------------------------------------------

function modifier_megacreep_mage_sleep_lua:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_NIGHTMARED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
    return state
end
--------------------------------------------------------------------------------

function modifier_megacreep_mage_sleep_lua:	GetOverrideAnimation( params )
    return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

