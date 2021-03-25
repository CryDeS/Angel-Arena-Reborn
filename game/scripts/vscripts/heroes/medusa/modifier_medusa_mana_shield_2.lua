modifier_medusa_mana_shield_2 = class({})

function modifier_medusa_mana_shield_2:IsPurgable()
	return false
end

function modifier_medusa_mana_shield_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function modifier_medusa_mana_shield_2:OnCreated()
	self.damage_per_mana = self:GetAbility():GetSpecialValueFor("damage_per_mana")
	self.absorb_pct = self:GetAbility():GetSpecialValueFor("absorption_pct")
end

function modifier_medusa_mana_shield_2:OnTakeDamage(params)
	if params.unit ~= self:GetParent() or not self:GetCaster():IsAlive() or self:GetCaster():GetMana() == 0 then return end
	local caster = self:GetCaster()

	local shield_damage = params.damage * self.absorb_pct / 100
	local mana_needed = shield_damage / self.damage_per_mana
	local caster_mana = caster:GetMana()
	if mana_needed > caster_mana then
		shield_damage = self.damage_per_mana * caster_mana
		mana_needed = caster_mana
	end
		
	caster:SetMana(caster_mana - mana_needed)
	caster:Heal(shield_damage, self:GetAbility())
	local particleName = "particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(mana_needed,0,0))
end



function modifier_medusa_mana_shield_2:GetEffectName()
	return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf"
end

function modifier_medusa_mana_shield_2:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end