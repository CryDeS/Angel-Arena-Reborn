modifier_huntress_owl_aura_true_strike_effect_lua = modifier_huntress_owl_aura_true_strike_effect_lua or class({})

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike_effect_lua:IsHidden()
    local parent = self:GetParent()
    if parent:GetUnitName() == "npc_hero_huntress" or parent:GetUnitName() == "npc_dota_hero_windrunner" then
        return false
    end
    return true
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike_effect_lua:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike_effect_lua:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike_effect_lua:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike_effect_lua:CheckState()
    local parent = self:GetParent()
    local state = {
        [MODIFIER_STATE_CANNOT_MISS] = true,
    }
    if parent:GetUnitName() == "npc_hero_huntress" or parent:GetUnitName() == "npc_dota_hero_windrunner" then
        return state
    end
    state = {}
    return state

end

--------------------------------------------------------------------------------