modifier_huntress_owl_aura_true_strike = modifier_huntress_owl_aura_true_strike or class({})

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:IsAura()
    return true
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:GetModifierAura()
    return "modifier_huntress_owl_aura_true_strike_effect_lua"
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:GetStatusEffectName(kv)
    return "particles/huntress/huntress_owl/huntress_owl_unit_effect.vpcf"
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:GetAuraRadius()
    return self.radius
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:OnCreated(kv)
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

-------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:OnRefresh(kv)
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

-------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:GetVisualZDelta(kv)
    return 180
end

-------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:GetModifierIncomingDamage_Percentage(kv)
    return -100
end

----------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:OnAttackLanded(kv)
    local parent = self:GetParent()
    if kv.target == parent then
        if self:GetParent():GetHealth() == 1 then
            parent:Kill(nil, kv.attacker)
        else
            parent:SetHealth(parent:GetHealth() - 1)
        end
    end
end

----------------------------------------------------------------------------------
function modifier_huntress_owl_aura_true_strike:OnDeath(kv)
    if IsServer() then
        local dead_hero = kv.unit
        if dead_hero ~= self:GetParent() then return end
        local owner = self:GetParent():GetOwner()
        if owner == kv.attacker then return end

        local current_stack = owner:GetModifierStackCount("huntress_owl_modifier_current_value", owner)
        if current_stack == 1 then
            owner:RemoveModifierByName("huntress_owl_modifier_current_value")
        else
            owner:SetModifierStackCount("huntress_owl_modifier_current_value", owner, current_stack - 1)
        end
        print (owner:GetAbilityByIndex(1):GetName())
        local ability = owner:GetAbilityByIndex(1)
        ability:RewriteTableOwl(dead_hero)
    end
end

----------------------------------------------------------------------------------
