modifier_ancient_satyr_small_aura_manareg = class({})

--------------------------------------------------------------------------------
function modifier_ancient_satyr_small_aura_manareg:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_ancient_satyr_small_aura_manareg:IsAura()
    return true
end

--------------------------------------------------------------------------------
function modifier_ancient_satyr_small_aura_manareg:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_ancient_satyr_small_aura_manareg:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
function modifier_ancient_satyr_small_aura_manareg:GetModifierAura()
    return "modifier_ancient_satyr_small_aura_manareg_effect"
end

--------------------------------------------------------------------------------
function modifier_ancient_satyr_small_aura_manareg:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------
function modifier_ancient_satyr_small_aura_manareg:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
function modifier_ancient_satyr_small_aura_manareg:GetAuraRadius()
    return self.radius
end

--------------------------------------------------------------------------------
function modifier_ancient_satyr_small_aura_manareg:OnCreated(kv)
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------