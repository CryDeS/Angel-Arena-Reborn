modifier_demon_archer_aura = class({})

--------------------------------------------------------------------------------
function modifier_demon_archer_aura:IsAura()
    return true
end

--------------------------------------------------------------------------------
function modifier_demon_archer_aura:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_demon_archer_aura:IsPurgable()
    return false
end

--------------------------------------------------------------------------------

function modifier_demon_archer_aura:GetModifierAura()
    return "modifier_demon_archer_aura_effect"
end

--------------------------------------------------------------------------------
function modifier_demon_archer_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------
function modifier_demon_archer_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------
function modifier_demon_archer_aura:GetAuraEntityReject(hEntity)
    if hEntity:IsRangedAttacker() then
        return false
    else
        return true
    end
end

--------------------------------------------------------------------------------
function modifier_demon_archer_aura:GetAuraRadius()
    return self.radius
end

--------------------------------------------------------------------------------
function modifier_demon_archer_aura:OnCreated(kv)
    local ability = self:GetAbility() 
    if not ability then return end

    self.radius = ability:GetSpecialValueFor("radius")
end

modifier_demon_archer_aura.OnRefresh = modifier_demon_archer_aura.OnCreated
