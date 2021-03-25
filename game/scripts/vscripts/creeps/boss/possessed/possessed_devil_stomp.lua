possessed_devil_stomp = possessed_devil_stomp or class({})

local ability = possessed_devil_stomp

LinkLuaModifier( "modifier_possessed_devil_stomp", 'creeps/boss/possessed/modifiers/modifier_possessed_devil_stomp', LUA_MODIFIER_MOTION_NONE )


function ability:FindUnits(caster, position, radius)
	return FindUnitsInRadius( 	caster:GetTeamNumber(),
								position,
							 	caster,
							 	radius,
							 	self:GetAbilityTargetTeam(),
							 	self:GetAbilityTargetType(),
							 	self:GetAbilityTargetFlags(),
							 	FIND_ANY_ORDER, 
							 	false )		
end

function ability:OnSpellStart()
	if not IsServer() then return end

	local caster		= self:GetCaster()
	local pos			= caster:GetAbsOrigin()
	local radius		= self:GetCastRange( pos, nil ) + caster:GetCastRangeBonus()
	local damageType 	= self:GetAbilityDamageType()
	local damage		= self:GetSpecialValueFor("damage")
	local stunDuration	= self:GetSpecialValueFor("stun_duration")

	local units = self:FindUnits(caster, pos, radius)

	for _, unit in pairs(units) do
		if unit and IsValidEntity(unit) then
			unit:AddNewModifier(caster, self, "modifier_possessed_devil_stomp", { duration = stunDuration })

			ApplyDamage({
				victim 		= unit,
				attacker 	= caster,
				damage 		= damage,
				damage_type = damageType,
				ability 	= self,
			})	
		end
	end

	caster:EmitSound("Boss_Possessed.DevilStomp.Cast")

	local idx = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(idx, 1, Vector(radius, 0, 0) )
end
