modifier_npc_aa_creep_centaur_small_net_lua = class({})
--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_net_lua:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_net_lua:IsRooted()
    return true
end

----------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_net_lua:GetEffectName()
    return "particles/net_on_target/net_on_target.vpcf"
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_net_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
function modifier_npc_aa_creep_centaur_small_net_lua:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
    }
    return state
end

--------------------------------------------------------------------------------