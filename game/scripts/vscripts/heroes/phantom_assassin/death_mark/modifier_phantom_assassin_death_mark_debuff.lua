modifier_phantom_assassin_death_mark_debuff = class({})

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_debuff:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_debuff:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_debuff:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_debuff:GetTexture()
    return "custom/angel_arena_agility_breaker"
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_debuff:OnCreated(kv)
    self.bonus_damage_per_attack_pct = self:GetAbility():GetSpecialValueFor("bonus_damage_per_attack_pct")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.max_attacks = self:GetAbility():GetSpecialValueFor("max_attacks")
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_debuff:OnRefresh(kv)
    self.bonus_damage_per_attack_pct = self:GetAbility():GetSpecialValueFor("bonus_damage_per_attack_pct")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_debuff:GetEffectName(kv)
    return "particles/units/phantom_assassin/death_mark/phantom_assassin_death_mark_debuff.vpcf"
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_debuff:OnAttackLanded(params) -- target attacker
    if not IsServer() then return end
    if params.attacker == self:GetAbility():GetCaster() and params.target == self:GetParent() then
        params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_phantom_assassin_death_mark_debuff", { duration = self.duration })
        local currentStack = params.target:GetModifierStackCount("modifier_phantom_assassin_death_mark_debuff", params.attacker)
        if currentStack < self.max_attacks then
            params.target:SetModifierStackCount("modifier_phantom_assassin_death_mark_debuff", params.attacker, currentStack + 1)
        else
            params.target:SetModifierStackCount("modifier_phantom_assassin_death_mark_debuff", params.attacker, currentStack)
        end
    end
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_debuff:GetModifierIncomingPhysicalDamage_Percentage(params)
    if params.attacker == self:GetAbility():GetCaster() and params.target == self:GetParent() then
        local currentStack = params.target:GetModifierStackCount("modifier_phantom_assassin_death_mark_debuff", params.attacker)
        return self.bonus_damage_per_attack_pct * (currentStack - 1)
    end
end

--------------------------------------------------------------------------------
function modifier_phantom_assassin_death_mark_debuff:OnDeath(params)
    if params.unit == self:GetParent() and params.unit:IsRealHero() then
        local ability = self:GetAbility()
        local caster = ability:GetCaster()
        local currentStack = caster:GetModifierStackCount("modifier_phantom_assassin_death_mark_bonus_agi", caster)
        caster:AddNewModifier(caster, ability, "modifier_phantom_assassin_death_mark_bonus_agi", { duration = -1 })
        caster:SetModifierStackCount("modifier_phantom_assassin_death_mark_bonus_agi", caster, currentStack + ability:GetSpecialValueFor("agility_gain_per_kill"))
        if caster:IsAlive() then
            local particleAgi = ParticleManager:CreateParticle("particles/units/phantom_assassin/death_mark/phantom_assassin_death_mark_give_agi.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
            ParticleManager:SetParticleControlEnt(particleAgi, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        end
    end
end

--------------------------------------------------------------------------------
