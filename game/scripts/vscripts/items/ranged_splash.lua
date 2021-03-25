local forbidden_modifiers = {
	"modifier_pangolier_swashbuckle_stunned",
	"modifier_pangolier_swashbuckle",
	"modifier_pangolier_swashbuckle_attack",
	"modifier_monkey_king_boundless_strike_crit",
}

RangedSplashModifier = RangedSplashModifier or class({})

function RangedSplashModifier:ApplyToModifier( mod )
	for key, value in pairs(RangedSplashModifier) do
		mod[key] = value
	end

	return mod
end

function RangedSplashModifier:Init( splashMult, splashAoe )
	self.splashMult = splashMult
	self.splashAoe = splashAoe
end

function RangedSplashModifier:PerformSplash(parent, target, ability, baseDamage)
	for _, modName in pairs(forbidden_modifiers) do
		if parent:HasModifier(modName) then return end
	end

	local damage = baseDamage * self.splashMult

	local teamNumber = parent:GetTeamNumber()
	local units = FindUnitsInRadius( teamNumber,
									 target:GetAbsOrigin(), 
									 target, 
									 self.splashAoe, 
									 DOTA_UNIT_TARGET_TEAM_ENEMY, 
									 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
									 DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 
									 0, 
									 false) 

	local projModel = parent:GetRangedProjectileName()
	local projSpeed = parent:GetProjectileSpeed() 

	for _, unit in pairs(units) do
		if unit ~= target then
			local info = {
				Target 				= unit,
				Source 				= target,
				EffectName 			= projModel,
				bDodgeable 			= false,
				bProvidesVision 	= true,
				iMoveSpeed 			= projSpeed,
				iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				iVisionRadius 		= 0,
				iVisionTeamNumber 	= teamNumber,
			}

			ProjectileManager:CreateTrackingProjectile( info )
			
			local flyTime = (target:GetAbsOrigin() - unit:GetAbsOrigin()):Length() / projSpeed

			Timers:CreateTimer( flyTime, function()
				if not unit or unit:IsNull() or not IsValidEntity(unit) or not unit:IsAlive() then return end
				if not parent or parent:IsNull() or not IsValidEntity(parent) or not parent:IsAlive() then return end
				if not self or self:IsNull() then return end
				if not ability or ability:IsNull() then return end

				ApplyDamage({ victim 		= unit, 
							  attacker 		= parent, 
							  damage 		= damage, 
							  damage_type 	= DAMAGE_TYPE_PHYSICAL, 
							  damage_flags 	= DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR, 
							  ability 		= ability })

			end)
		end
	end
end


function RangedSplashModifier:OnAttackLanded( params )
	if not IsServer() then return end

	local parent = self:GetParent()

	if parent ~= params.attacker then return end

	local target = params.target
	local ability = self:GetAbility()

	if not target or target:IsNull() or not IsValidEntity(target) or not ability or ability:IsNull() then return end

	if not parent:IsAlive() or not target:IsAlive() then return end

	self:PerformSplash(parent, target, ability, params.damage)
end