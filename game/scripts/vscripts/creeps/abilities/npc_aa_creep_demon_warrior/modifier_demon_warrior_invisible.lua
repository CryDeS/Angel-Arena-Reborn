modifier_demon_warrior_invisible = class({})
--------------------------------------------------------------------------------
function modifier_demon_warrior_invisible:IsDebuff()
    return false
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_invisible:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_invisible:IsInvisible()
    return true
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_invisible:GetPriority()
    return MODIFIER_PRIORITY_NORMAL
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_invisible:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_invisible:OnCreated(kv)
    self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
    self.bonus_manaburn = self:GetAbility():GetSpecialValueFor("bonus_manaburn")
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_invisible:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
    }
    return state
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_invisible:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_invisible:OnAttackLanded(params)
    local caster = params.attacker
    if caster == self:GetParent() then
        self:Destroy()
        local target = params.target
        local info = {
            victim = target,
            attacker = caster,
            damage = self.bonus_damage,
            damage_type = DAMAGE_TYPE_PHYSICAL,
        }
        ApplyDamage(info)
        target:ReduceMana(self.bonus_manaburn)
    end
end

--------------------------------------------------------------------------------
function modifier_demon_warrior_invisible:OnAbilityExecuted(params)

    local caster = params.unit
    if caster == self:GetParent() then
        self:Destroy()
    end
end

--------------------------------------------------------------------------------