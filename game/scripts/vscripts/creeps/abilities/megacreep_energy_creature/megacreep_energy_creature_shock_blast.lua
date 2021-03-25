megacreep_energy_creature_shock_blast = class({})

function megacreep_energy_creature_shock_blast:IsHiddenWhenStolen() return false end

function megacreep_energy_creature_shock_blast:OnSpellStart( ... )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	caster:EmitSound("Hero_Pugna.NetherBlast.TI9.Layer")

	local projectile_speed = self:GetSpecialValueFor("projectile_speed")

	local proj_info = {
		EffectName = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf",
		Ability = self,
		iMoveSpeed = projectile_speed,
		Source = caster,
		Target = target,
		bDodgeable = true,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile( proj_info )
end

function megacreep_energy_creature_shock_blast:OnProjectileHit(hTarget, vLocation)
	if not hTarget then return end
	
	if hTarget:TriggerSpellReflect(self) then return end
	if hTarget:TriggerSpellAbsorb(self) then return end

	if hTarget:IsMagicImmune() or hTarget:IsInvulnerable() then return end

	local caster = self:GetCaster()

	caster:EmitSound("Hero_Invoker.EMP.Discharge")

	local bolt_damage 			= self:GetSpecialValueFor("damage")
	local bolt_stun_duration 	= self:GetDuration()

	local damage_info = {
		victim = hTarget,
		attacker = caster,
		damage = bolt_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}

	ApplyDamage(damage_info)

	hTarget:AddNewModifier(caster, self, "modifier_stunned", {duration = bolt_stun_duration})

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile_hit_ring.vpcf", PATTACH_ABSORIGIN , hTarget)
	ParticleManager:SetParticleControlEnt( particle, 1, hTarget, PATTACH_POINT, "attach_hitloc", hTarget:GetAbsOrigin(), true)
end