npc_aa_creep_salamander_big_fireball_lua = npc_aa_creep_salamander_big_fireball_lua or class({})

function npc_aa_creep_salamander_big_fireball_lua:OnSpellStart()
    self.damage = self:GetSpecialValueFor("damage")
    self.speed = self:GetSpecialValueFor("speed")

    local info = {
        EffectName = "particles/hw_fx/hw_rosh_fireball.vpcf",
        Ability = self,
        iMoveSpeed = self.speed,
        Source = self:GetCaster(),
        Target = self:GetCursorTarget(),
        iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    }
    ProjectileManager:CreateTrackingProjectile(info)
end

function npc_aa_creep_salamander_big_fireball_lua:OnProjectileHit(hTarget, vLocation)
    if hTarget ~= nil and (not hTarget:IsInvulnerable()) and (not hTarget:TriggerSpellAbsorb(self)) then
        local info = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
        }
        ApplyDamage(info)
    end
end