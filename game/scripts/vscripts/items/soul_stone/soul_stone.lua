item_soul_stone = item_soul_stone or class({})
local ability = item_soul_stone

LinkLuaModifier( "modifier_soul_stone", 'items/soul_stone/modifiers/modifier_soul_stone', LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_soul_stone"
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
		EffectName 			= "particles/units/heroes/hero_visage/visage_soul_assumption_bolt6.vpcf",
		iMoveSpeed 			= self:GetSpecialValueFor("projectile_speed"),
		bDrawsOnMinimap 	= false,
		bDodgeable 			= true,
		bIsAttack 			= false,
		bVisibleToEnemies 	= true,
		bReplaceExisting 	= false,
		bProvidesVision 	= false,
	}

	ProjectileManager:CreateTrackingProjectile(info)

	hSource:EmitSound("Item_SoulStone.Cast")
end 

function ability:OnSpellStart()
	if not IsServer() then return end

    if not self or self:IsNull() then return end

    local target = self:GetCursorTarget()

    if not target or target:IsNull() then return end

    local caster = self:GetCaster()

    if not caster or caster:IsNull() then return end

	if target:TriggerSpellAbsorb(self) or target:TriggerSpellReflect(self) then return end

	self:LaunchProjectile(caster, target)
end


function ability:OnProjectileHit(hTarget, vLocation)
 	if not self or self:IsNull() then return end
    if not hTarget or hTarget:IsNull() then return end

	local caster = self:GetCaster()
	
	local damagePct = self:GetSpecialValueFor("mainstat_to_dmg") / 100

	local damage = self:GetSpecialValueFor("damage")

	if caster and not caster:IsNull() and caster.GetPrimaryStatValue then 
		damage = damage +  caster:GetPrimaryStatValue() * damagePct
	end

	local heal = ApplyDamage({
		victim 		= hTarget,
		attacker 	= caster,
		damage 		= damage,
		damage_type = self:GetAbilityDamageType(),
		ability 	= self
	})

	if caster and not caster:IsNull() then 
		caster:Heal(heal, self)

    	local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
    	SendOverheadEventMessage(caster, OVERHEAD_ALERT_HEAL, caster, heal, nil)
    end

    local particle = ParticleManager:CreateParticle("particles/econ/events/ti10/high_five/high_five_impact_burst.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
    ParticleManager:SetParticleControl(particle, 3, hTarget:GetAbsOrigin())

	hTarget:EmitSound("Item_SoulStone.Hit")
end 
