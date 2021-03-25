item_doombolt = item_doombolt or class({})
local ability = item_doombolt

LinkLuaModifier( "modifier_doombolt", 		'items/doombolt/modifiers/modifier_doombolt', 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_doombolt_crit", 	'items/doombolt/modifiers/modifier_doombolt_crit', 	LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_doombolt"
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
		EffectName 			= "particles/units/heroes/hero_snapfire/hero_snapfire_base_attack.vpcf",
		iMoveSpeed 			= self:GetSpecialValueFor("projectile_speed"),
		bDrawsOnMinimap 	= false,
		bDodgeable 			= true,
		bIsAttack 			= false,
		bVisibleToEnemies 	= true,
		bReplaceExisting 	= false,
		bProvidesVision 	= false,
	}

	ProjectileManager:CreateTrackingProjectile(info)

	hSource:EmitSound("Item_DoomBolt.Cast")
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

	local damageFromAttack = self:GetSpecialValueFor("damage_from_attack") / 100

	local damage = caster:GetAverageTrueAttackDamage(nil) * damageFromAttack

	ApplyDamage({
		victim 		= hTarget,
		attacker 	= caster,
		damage 		= damage,
		damage_type = self:GetAbilityDamageType(),
		ability 	= self
	})

	hTarget:EmitSound("Item_DoomBolt.Hit")
end 
