megacreep_ancient_golem_burn_far = class({})

--particles/units/heroes/hero_demonartist/demonartist_inkdemon_projectile.vpcf
--particles/neutral_fx/black_dragon_fireball_projectile.vpcf

function megacreep_ancient_golem_burn_far:OnSpellStart()
	local caster 	 = self:GetCaster()
	local wave_width = self:GetSpecialValueFor("wave_width")
	local wave_speed = self:GetSpecialValueFor("wave_speed")
	local distance   = self:GetSpecialValueFor("distance")
	local vDirection = self:GetCursorPosition() - caster:GetOrigin()
	vDirection 	 	 = vDirection:Normalized()
	local info = {
		EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
		Ability = self,
		vSpawnOrigin = caster:GetOrigin(), 
		fStartRadius = wave_width,
		fEndRadius = wave_width,
		vVelocity = vDirection * wave_speed,
		fDistance = distance,
		Source = caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		bProvidesVision = true,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iVisionRadius = 200,
	}
	self.nProjID = ProjectileManager:CreateLinearProjectile( info )
end

function megacreep_ancient_golem_burn_far:OnProjectileHit(hTarget)
	if hTarget == nil or hTarget:TriggerSpellAbsorb(self) then return end
	local damage = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = self:GetSpecialValueFor("contact_damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}
	ApplyDamage( damage )
end