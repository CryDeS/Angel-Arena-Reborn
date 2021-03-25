modifier_creep_bear_big_passive_anticreep_lua = class({})

--------------------------------------------------------------------------------
function modifier_creep_bear_big_passive_anticreep_lua:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_creep_bear_big_passive_anticreep_lua:OnCreated(kv)
    self.damage_creep_pct = self:GetAbility():GetSpecialValueFor("damage_creep_pct")
end

--------------------------------------------------------------------------------
function modifier_creep_bear_big_passive_anticreep_lua:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED, }
end

--------------------------------------------------------------------------------
function modifier_creep_bear_big_passive_anticreep_lua:OnAttackLanded(params)
    if IsServer() then
        if self:GetCaster():PassivesDisabled() then
            return 0
        end
        if params.attacker == self:GetParent() then
            local target = params.target
            if target ~= nil and target:IsCreep() then
                local allDamage = params.damage * self.damage_creep_pct / 100
                local info = {
                    victim = target,
                    attacker = self:GetCaster(),
                    damage = allDamage,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
                }
                ApplyDamage(info)
            end
        end
    end
end