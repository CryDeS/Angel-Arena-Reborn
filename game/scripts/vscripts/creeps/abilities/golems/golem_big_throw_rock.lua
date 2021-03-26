golem_big_throw_rock = golem_big_throw_rock or class({})

function golem_big_throw_rock:OnSpellStart()
	self.duration = self:GetSpecialValueFor("stun_duration")
	self.damage = self:GetSpecialValueFor("damage")
	self.dmg_type = self:GetAbilityDamageType() 

    local info = {
        EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
        Ability = self,
        iMoveSpeed = self:GetSpecialValueFor("speed"),
        Source = self:GetCaster(),
        Target = self:GetCursorTarget(),
        iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    }
    ProjectileManager:CreateTrackingProjectile(info)
end

function golem_big_throw_rock:OnProjectileHit(hTarget, vLocation)
    if hTarget ~= nil and (not hTarget:IsInvulnerable()) and (not hTarget:TriggerSpellAbsorb(self)) then
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self.duration })

        local info = {
            victim = hTarget,
            attacker = self:GetCaster(),
            damage = self.damage,
            damage_type = self.dmg_type,
        }
        ApplyDamage(info)

        local particle = ParticleManager:CreateParticle( "particles/neutral_fx/mud_golem_hurl_boulder_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControl( particle, 3, vLocation )
        ParticleManager:ReleaseParticleIndex( particle )
    end
end