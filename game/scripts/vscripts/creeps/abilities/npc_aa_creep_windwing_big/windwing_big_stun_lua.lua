windwing_big_stun_lua = class({})

function windwing_big_stun_lua:OnSpellStart()
    self.duration = self:GetSpecialValueFor("duration")
    self.damage = self:GetSpecialValueFor("damage")


    local info = {
        EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
        Ability = self,
        iMoveSpeed = 600,
        Source = self:GetCaster(),
        Target = self:GetCursorTarget(),
        iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    }
    ProjectileManager:CreateTrackingProjectile(info)
end

function windwing_big_stun_lua:OnProjectileHit(hTarget, vLocation)
    if hTarget ~= nil and (not hTarget:IsInvulnerable()) and (not hTarget:TriggerSpellAbsorb(self)) then
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self.duration })
        local info = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
        }
        ApplyDamage(info)
    end
end