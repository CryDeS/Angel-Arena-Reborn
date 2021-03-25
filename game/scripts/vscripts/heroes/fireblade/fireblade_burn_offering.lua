fireblade_burn_offering = fireblade_burn_offering or class({})
local ability = fireblade_burn_offering

function ability:OnProjectileHit(target, targetPos)
	if not IsServer() then return end
	if not target then return end
	if not target:IsAlive() then return end
	if target:IsMagicImmune() then return end

	local caster = self:GetCaster()

	local damage = self:GetSpecialValueFor("damage")

	if caster:HasTalent("fireblade_talent_burn_offering_attack_dmg") then
		damage = damage + caster:GetAverageTrueAttackDamage(nil)
	end

	local heal = ApplyDamage({
		victim 		= target,
		attacker 	= caster,
		damage 		= damage,
		damage_type = self:GetAbilityDamageType(),
		ability 	= self,
	})

	if caster:HasTalent("fireblade_talent_burn_offering_heal") then
		SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL , caster, heal, nil)
		caster:Heal(heal, self)
		local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	end

	target:EmitSound("Hero_EmberSpirit.SearingChains.Target")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_POINT, target)

	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin() + Vector(0,0,1))
end


function ability:LaunchProjectile( caster, target, speed )
	local projectileInfo = {
		Source 				= caster,
		Target 				= target,
		Ability 			= self,
		EffectName 			= "particles/hw_fx/hw_rosh_fireball.vpcf",
		bDodgeable 			= true,
		bProvidesVision 	= false,
		iMoveSpeed 			= speed,
		iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}

	ProjectileManager:CreateTrackingProjectile( projectileInfo )
end


function ability:OnSpellStart( ... )
	if not IsServer() then return end

	local caster = self:GetCaster()
	local casterPos = caster:GetAbsOrigin()

	local units = FindUnitsInRadius( caster:GetTeamNumber(),
									 casterPos,
									 caster,
									 self:GetCastRange(casterPos, nil) + caster:GetCastRangeBonus(),
									 self:GetAbilityTargetTeam(),
									 self:GetAbilityTargetType(),
									 self:GetAbilityTargetFlags(),
									 FIND_ANY_ORDER,
									 false )

	local speed = self:GetSpecialValueFor("speed")
	local isAOE = caster:HasTalent("fireblade_talent_burn_offering_aoe")

	local target
	local targetDist

	for _, unit in pairs(units) do
		if unit then
			if isAOE then
				self:LaunchProjectile(caster, unit, speed)
			else
				local dist = (unit:GetAbsOrigin() - casterPos):Length()

				if not target or dist < targetDist then
					target = unit
					targetDist = dist
				end
			end
		end
	end

	if not isAOE and target then
		self:LaunchProjectile( caster, target, speed )
	end

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit_warp.vpcf", PATTACH_POINT, caster)

	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() + Vector(0,0,1))
	caster:EmitSound("Hero_EmberSpirit.SearingChains.Cast")
end