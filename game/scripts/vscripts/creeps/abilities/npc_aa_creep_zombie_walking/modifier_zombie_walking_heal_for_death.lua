modifier_zombie_walking_heal_for_death = class({})

--------------------------------------------------------------------------------
function modifier_zombie_walking_heal_for_death:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_heal_for_death:OnCreated(kv)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    self.heal_per_hero_death_pct = self:GetAbility():GetSpecialValueFor("heal_per_hero_death_pct")
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_heal_for_death:DeclareFunctions()
    return { MODIFIER_EVENT_ON_DEATH, }
end

--------------------------------------------------------------------------------
function modifier_zombie_walking_heal_for_death:OnDeath(params)
    if not IsServer() then return end
    if self:GetCaster():PassivesDisabled() then return 0 end
    if not params.unit:IsHero() then return end
    local caster = self:GetCaster()
    local vCaster = caster:GetAbsOrigin()
    local vTarget = params.unit:GetAbsOrigin()
    local vDiff = vTarget - vCaster
    local nDiff = vDiff:Length2D()

    if nDiff <= self.radius then
        caster:Heal( caster:GetMaxHealth()/100*self.heal_per_hero_death_pct, self )
    end
end