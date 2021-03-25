skelet_1_blue_heal = class({})

--------------------------------------------------------------------------------

function skelet_1_blue_heal:OnSpellStart()
    self.heal_pct = self:GetSpecialValueFor("heal_pct")
    local target = self:GetCursorTarget()
    local heal = target:GetMaxHealth()/100*self.heal_pct
    local caster = self:GetCaster()
    local damageTable = {
        victim = caster,
        attacker = caster,
        damage = caster:GetMaxHealth(),
        damage_type = DAMAGE_TYPE_PURE,
    }

    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_chen/chen_test_of_faith_b.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl( particle, 0, target:GetOrigin() )
    target:Heal( heal, self )
    ApplyDamage(damageTable)
end

--------------------------------------------------------------------------------
