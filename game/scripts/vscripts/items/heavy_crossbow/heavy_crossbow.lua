item_heavy_crossbow = item_heavy_crossbow or class({})
local ability = item_heavy_crossbow

LinkLuaModifier( "modifier_heavy_crossbow", 	 'items/heavy_crossbow/modifiers/modifier_heavy_crossbow', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heavy_crossbow_crit", 'items/heavy_crossbow/modifiers/modifier_heavy_crossbow_crit', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heavy_crossbow_stun", 'items/heavy_crossbow/modifiers/modifier_heavy_crossbow_stun', LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_heavy_crossbow"
end

function ability:LaunchProjectile(hSource, hTarget)
	if not hSource or hSource:IsNull() then return end
	if not hTarget or hTarget:IsNull() then return end
	if not self or self:IsNull() then return end

	local info =
	{
		Target 				= hTarget,
		Source 				= hSource,
		vSourceLoc 			= hSource:GetAbsOrigin(),

		Ability 			= self,
		EffectName 			= "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_base_attack.vpcf",
		iMoveSpeed 			= self:GetSpecialValueFor("projectile_speed"),
		bDrawsOnMinimap 	= false,
		bDodgeable 			= true,
		bIsAttack 			= false,
		bVisibleToEnemies 	= true,
		bReplaceExisting 	= false,
		bProvidesVision 	= false,
	}

	ProjectileManager:CreateTrackingProjectile(info)

	hSource:EmitSound("Item_HeavyCrossbow.Cast")
end 

function ability:OnSpellStart()
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) or target:TriggerSpellReflect(self) then return end

	self:LaunchProjectile(self:GetCaster(), target)
end

function ability:OnProjectileHit(hTarget, vLocation)
	if not self or self:IsNull() then return end
	if not hTarget or hTarget:IsNull() then return end

	local caster = self:GetCaster()
	
	if not caster or caster:IsNull() then return end

	local damageAttackPct = self:GetSpecialValueFor("attack_to_dmg") / 100

	local damage = self:GetSpecialValueFor("damage") + caster:GetAverageTrueAttackDamage( nil ) * damageAttackPct

	local heal = ApplyDamage({
		victim 		= hTarget,
		attacker 	= caster,
		damage 		= damage,
		damage_type = self:GetAbilityDamageType(),
		ability 	= self
	})

	caster:Heal(heal, self)

	hTarget:AddNewModifier(caster, self, "modifier_heavy_crossbow_stun", { duration = self:GetSpecialValueFor("stun_duration") })

	local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster, heal, nil)

	local particle = ParticleManager:CreateParticle("particles/econ/events/ti10/high_five/high_five_impact_burst.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(particle, 3, hTarget:GetAbsOrigin())

	hTarget:EmitSound("Item_HeavyCrossbow.Hit")
end 
