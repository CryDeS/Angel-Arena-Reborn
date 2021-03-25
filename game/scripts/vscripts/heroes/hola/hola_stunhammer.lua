hola_stunhammer = class({})

function hola_stunhammer:IsHiddenWhenStolen() return false end

function hola_stunhammer:GetAOERadius()
	return self:GetSpecialValueFor("bolt_aoe")
end

function hola_stunhammer:OnSpellStart( ... )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	caster:EmitSound("Hero_Sven.StormBolt")

	local projectile_speed = self:GetSpecialValueFor("bolt_speed")

	local proj_info = {
		EffectName = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
		Ability = self,
		iMoveSpeed = projectile_speed,
		Source = caster,
		Target = target,
		bDodgeable = true,
		bProvidesVision = false,
	}
	ProjectileManager:CreateTrackingProjectile( proj_info )
end

function hola_stunhammer:OnProjectileHit(hTarget, vLocation)
	if hTarget:TriggerSpellReflect(self) then return end
	if hTarget:TriggerSpellAbsorb(self) then return end

	if hTarget:IsMagicImmune() or hTarget:IsInvulnerable() then return end

	local caster = self:GetCaster()

	caster:EmitSound("Hero_Sven.StormBoltImpact")

	local bolt_damage 			= self:GetSpecialValueFor("bolt_damage")
	local bolt_aoe 				= self:GetSpecialValueFor("bolt_aoe")
	local bolt_stun_duration 	= self:GetSpecialValueFor("bolt_stun_duration") 

	local damage_info = {
		victim = hTarget,
		attacker = caster,
		damage = bolt_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), hTarget:GetOrigin(), hTarget, bolt_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	
	for _,enemy in pairs(enemies) do
		if not enemy:IsMagicImmune() and not enemy:IsInvulnerable() then
			damage_info.victim = enemy
			ApplyDamage(damage_info)

			-- TODO: New modifier for this stun for talens
			enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = bolt_stun_duration})
		end
	end

end