item_azrael_crossbow = item_azrael_crossbow or class({})
local ability = item_azrael_crossbow

LinkLuaModifier( "modifier_azrael_crossbow", 	 'items/azrael_crossbow/modifiers/modifier_azrael_crossbow', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_azrael_crossbow_crit", 'items/azrael_crossbow/modifiers/modifier_azrael_crossbow_crit', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_azrael_crossbow_stun", 'items/azrael_crossbow/modifiers/modifier_azrael_crossbow_stun', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_azrael_crossbow_cd", 'items/azrael_crossbow/modifiers/modifier_azrael_crossbow_cd', LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_azrael_crossbow"
end

function ability:LaunchProjectile(hSource, hTarget)
	if not self or self:IsNull() then return end
	if not hSource or hSource:IsNull() then return end
	if not hTarget or hTarget:IsNull() then return end

	local extraData = {}
	extraData.my = 1
	extraData.my2 = 3

	local info =
	{
		Target 				= hTarget,
		Source 				= hSource,
		vSourceLoc 			= hSource:GetAbsOrigin(),

		Ability 			= self,
		EffectName 			= "particles/items/azrael_crossbow/azrael_crossbow_bolt.vpcf",
		iMoveSpeed 			= self:GetSpecialValueFor("projectile_speed"),
		bDrawsOnMinimap 	= false,
		bDodgeable 			= true,
		bIsAttack 			= false,
		bVisibleToEnemies 	= true,
		bReplaceExisting 	= false,
		bProvidesVision 	= false,
		ExtraData 			= extraData,
	}

	ProjectileManager:CreateTrackingProjectile(info)

	hSource:EmitSound("Item_AzraelCrossbow.Cast")
end 

function ability:OnSpellStart()
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if not target or target:IsNull() then return end

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

	self.noAttack = true
	caster:PerformAttack(hTarget, true, true, true, true, false, false, true) 
	self.noAttack = false

	caster:Heal(heal, self)

	hTarget:AddNewModifier(caster, self, "modifier_azrael_crossbow_stun", { duration = self:GetSpecialValueFor("stun_duration") })

	local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster, heal, nil)

	local particle = ParticleManager:CreateParticle("particles/econ/events/ti10/high_five/high_five_impact_burst.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(particle, 3, hTarget:GetAbsOrigin())

	hTarget:EmitSound("Item_AzraelCrossbow.Hit")
end 
