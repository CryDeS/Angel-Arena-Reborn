angel_arena_fountain_aura = class({})

--------------------------------------------------------------------------------
function angel_arena_fountain_aura:IsAura()
    return true
end

--------------------------------------------------------------------------------
function angel_arena_fountain_aura:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function angel_arena_fountain_aura:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function angel_arena_fountain_aura:GetModifierAura()
    return "angel_arena_fountain_aura_effect"
end

--------------------------------------------------------------------------------
function angel_arena_fountain_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------
function angel_arena_fountain_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
function angel_arena_fountain_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------
function angel_arena_fountain_aura:OnCreated(kv)
end
-------------------------------------------------------------------------------
function angel_arena_fountain_aura:GetAuraRadius()
    if self.radius == nil then
        if self:GetAbility() then
            self.radius = self:GetAbility():GetSpecialValueFor("radius_aura")
        end
    end
    return (self.radius or 0)
end

--------------------------------------------------------------------------------
function angel_arena_fountain_aura:CheckState()
    local state = {
        [MODIFIER_STATE_CANNOT_MISS] = true,
    }
    return state
end

--------------------------------------------------------------------------------
function angel_arena_fountain_aura:DeclareFunctions()
    return { MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, }
end

--------------------------------------------------------------------------------
function angel_arena_fountain_aura:GetModifierBaseAttack_BonusDamage(params)
    return GameRules:GetGameTime() / 60 * 10
end

-----------------------------------------------------------------------------