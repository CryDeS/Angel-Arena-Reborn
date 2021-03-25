modifier_huntress_owl_unit_vision = modifier_huntress_owl_unit_vision or class({})

function modifier_huntress_owl_unit_vision:OnCreated(kv)
    if IsServer() then
        self:StartIntervalThink(0.1)
    end
end

function modifier_huntress_owl_unit_vision:IsAura()
    return true
end

function modifier_huntress_owl_unit_vision:IsHidden()
    return true
end

function modifier_huntress_owl_unit_vision:IsPurgable()
    return false
end

function modifier_huntress_owl_unit_vision:RemoveOnDeath()
    return false
end

function modifier_huntress_owl_unit_vision:AllowIllusionDuplicate()
    return true
end

function modifier_huntress_owl_unit_vision:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius") + self:GetAbility():GetCaster():GetTalentSpecialValueFor("huntress_huntress_owl_radius_aura_tallent")
end

function modifier_huntress_owl_unit_vision:DeclareFunctions()
    return { MODIFIER_EVENT_ON_DEATH, MODIFIER_PROPERTY_BONUS_DAY_VISION, MODIFIER_PROPERTY_BONUS_NIGHT_VISION }
end

function modifier_huntress_owl_unit_vision:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_huntress_owl_unit_vision:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER
end

function modifier_huntress_owl_unit_vision:GetBonusDayVision()
    return self:GetAbility():GetCaster():GetTalentSpecialValueFor("huntress_huntress_owl_radius_aura_tallent")
end

function modifier_huntress_owl_unit_vision:GetBonusNightVision()
    return self:GetAbility():GetCaster():GetTalentSpecialValueFor("huntress_huntress_owl_radius_aura_tallent")
end

function modifier_huntress_owl_unit_vision:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end


function modifier_huntress_owl_unit_vision:GetModifierAura()
    return "modifier_huntress_owl_unit_vision_effect"
end

function modifier_huntress_owl_unit_vision:OnDeath(keys)
    if IsServer() then
        local dead_hero = keys.unit

        if dead_hero ~= self:GetParent() then return end
        if dead_hero.IsReincarnating and dead_hero:IsReincarnating() then return end

        self:Destroy()
    end
end

function modifier_huntress_owl_unit_vision:OnIntervalThink()
    if not IsServer() then return end

    local hero = self:GetParent()

    local enemyUnits = FindUnitsInRadius(hero:GetOpposingTeamNumber(),
        hero:GetAbsOrigin(),
        nil,
        self:GetAbility():GetSpecialValueFor("radius") + self:GetAbility():GetCaster():GetTalentSpecialValueFor("huntress_huntress_owl_radius_aura_tallent"),
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_OTHER,
        DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
        FIND_ANY_ORDER,
        false)

    for _, tree in pairs(enemyUnits) do
        if tree:GetClassname() == "npc_dota_treant_eyes" then
            tree:AddNewModifier(hero, self:GetAbility(), "modifier_truesight", { duration = 0.11 })
        end
    end
end 