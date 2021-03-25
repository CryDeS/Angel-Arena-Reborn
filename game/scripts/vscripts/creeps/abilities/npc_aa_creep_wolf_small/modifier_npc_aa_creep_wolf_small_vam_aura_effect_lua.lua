modifier_npc_aa_creep_wolf_small_vam_aura_effect_lua = modifier_npc_aa_creep_wolf_small_vam_aura_effect_lua or class({})
local mod = modifier_npc_aa_creep_wolf_small_vam_aura_effect_lua

function mod:IsHidden()
    return true
end

function mod:IsDebuff()
    return false
end

function mod:OnCreated(kv)
    local ability = self:GetAbility()

    if not ability then return end

    self.lifesteal = ability:GetSpecialValueFor("lifesteal")
end

mod.OnRefresh = mod.OnCreated

function mod:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function mod:OnAttackLanded(params)
    if self:GetParent():PassivesDisabled() then return end

    if not IsServer() then return end

    if not self.lifesteal then return end

    if self:GetParent() == params.attacker then
        local steal = params.damage * (self.lifesteal / 100)
        params.attacker:Heal(steal, self)
        local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, params.attacker)
        ParticleManager:SetParticleControl(particle, 0, params.attacker:GetAbsOrigin())
        SendOverheadEventMessage(params.unit, OVERHEAD_ALERT_HEAL, params.attacker, steal, nil)
    end
end
