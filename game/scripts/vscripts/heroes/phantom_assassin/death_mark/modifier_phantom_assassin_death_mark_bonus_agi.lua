modifier_phantom_assassin_death_mark_bonus_agi = class({})

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_bonus_agi:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_bonus_agi:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_bonus_agi:GetTexture()
    return "custom/angel_arena_agility_breaker"
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_bonus_agi:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_bonus_agi:RemoveOnDeath()
    return false
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_bonus_agi:OnCreated(kv)
end
--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_bonus_agi:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_bonus_agi:GetModifierBonusStats_Agility()
    return self:GetStackCount()
end