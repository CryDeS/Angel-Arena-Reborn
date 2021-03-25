modifier_megacreep_mage_magic_damage_lua = class({})

--------------------------------------------------------------------------------
function modifier_megacreep_mage_magic_damage_lua:IsHidden()
    return true
end

--------------------------------------------------------------------------------
function modifier_megacreep_mage_magic_damage_lua:OnCreated(kv)
    local ability = self:GetAbility()

    if not ability then return end

    self.chance             = ability:GetSpecialValueFor("chance")
    self.bonus_magic_damage = ability:GetSpecialValueFor("bonus_magic_damage")
end

modifier_megacreep_mage_magic_damage_lua.OnRefresh = modifier_megacreep_mage_magic_damage_lua.OnCreated

--------------------------------------------------------------------------------
function modifier_megacreep_mage_magic_damage_lua:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED, }
end

--------------------------------------------------------------------------------
function modifier_megacreep_mage_magic_damage_lua:OnAttackLanded(params)
    if IsServer() then
        local target = params.target
        if self:GetCaster() ~= target then return end
        if self:GetCaster():PassivesDisabled() then
            return 0
        end

        if target ~= nil and RollPercentage(self.chance) then
            local info = {
                victim = target,
                attacker = self:GetCaster(),
                damage = self.bonus_magic_damage,
                damage_type = DAMAGE_TYPE_MAGICAL,
            }
            ApplyDamage(info)
            local particle = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/au_darkrift_target_oh_e3.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
        end
    end
end