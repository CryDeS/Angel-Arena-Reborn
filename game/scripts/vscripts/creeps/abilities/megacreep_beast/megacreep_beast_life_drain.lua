megacreep_beast_life_drain = class({})

---------------------------------------------------------------------------

function megacreep_beast_life_drain:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("CNY_Beast.Ability.Cast")
	return true 
end 

function megacreep_beast_life_drain:OnSpellStart()
	local caster = self:GetCaster() 

	self.target = self:GetCursorTarget() 
	self.damage = self:GetSpecialValueFor("damage") + caster:GetHealth() * self:GetSpecialValueFor("damage_from_health") / 100 
	self.dmg_type = self:GetAbilityDamageType() 

	self.damage = self.damage / self:GetDuration() 

	self.p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_lifedrain_drainfield.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	self.p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_lifedrain_innerglow_give.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
end

function megacreep_beast_life_drain:DealDamage(damage)
    ApplyDamage(
    {
        victim = self.target,
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self,
    })

    ParticleManager:SetParticleControl(self.p1, 1, self.target:GetAbsOrigin() + Vector(0,0,100) )
	ParticleManager:SetParticleControl(self.p2, 1, self.target:GetAbsOrigin() + Vector(0,0,100) )

    self:GetCaster():Heal(damage, self)
end

function megacreep_beast_life_drain:OnChannelThink(fInterval)
    if not IsServer() then return end
    self:DealDamage(self.damage * fInterval)
end

function megacreep_beast_life_drain:OnChannelFinish(bInterrupted)
	ParticleManager:DestroyParticle(self.p1, false)
	ParticleManager:DestroyParticle(self.p2, false)
end

