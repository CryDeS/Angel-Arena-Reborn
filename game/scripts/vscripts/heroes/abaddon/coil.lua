local particle_name 	= "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"

function AbaddonCoilStart( event )
	-- Variables
	local caster 			= event.caster
	local original_target 	= event.target
	local ability 			= event.ability
	local damage_pct 		= ability:GetSpecialValueFor( "percent") / 100
	local damage 			= ability:GetSpecialValueFor( "target_damage" ) + Util:DisableSpellAmp(caster, caster:GetStrength()*damage_pct)
	local heal 				= ability:GetSpecialValueFor( "heal_amount" ) + caster:GetStrength()*damage_pct
	local projectile_speed 	= ability:GetSpecialValueFor( "missile_speed" )
	local self_damage 		= ability:GetSpecialValueFor( "self_damage" )
	local radius = 0

	if IsServer() then
		radius = caster:GetTalentSpecialValueFor("special_bonus_unique_abaddon_4")
	end

	-- Play the ability sound
	caster:EmitSound("Hero_Abaddon.DeathCoil.Cast")
	original_target:EmitSound("Hero_Abaddon.DeathCoil.Target")

	ApplyDamage({ victim = caster, attacker = caster, damage = Util:DisableSpellAmp(caster, self_damage), damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	
	local units = FindUnitsInRadius(caster:GetTeamNumber() , original_target:GetAbsOrigin() , nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, target in pairs(units) do 

		local info = {
			Target = target,
			Source = caster,
			Ability = ability,
			EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
			bDodgeable = false,
			bProvidesVision = true,
			iMoveSpeed = projectile_speed,
	        iVisionRadius = 0,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		}

		ProjectileManager:CreateTrackingProjectile( info )

		if IsServer() then
			if target:GetTeamNumber() ~= caster:GetTeamNumber() then
				target:TriggerSpellReflect(ability)
				
				if not target:TriggerSpellAbsorb( ability ) then 
					Util:DealPercentDamage(target, caster, DAMAGE_TYPE_MAGICAL, heal, 0)
				end
			else
				target:Heal( heal, caster )
			end
			
		end
	end

end