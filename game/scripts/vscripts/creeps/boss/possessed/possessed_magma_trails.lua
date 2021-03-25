possessed_magma_trails = possessed_magma_trails or class({})

local ability = possessed_magma_trails

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

	local caster    = self:GetCaster()
	
	local damage = self:GetSpecialValueFor("damage") + caster:GetAverageTrueAttackDamage( nil ) * self:GetSpecialValueFor("damage_from_attack") / 100

	local pos = caster:GetAbsOrigin()
	local radius = self:GetCastRange( pos, nil ) + caster:GetCastRangeBonus()

	local damage 		= damage
	local damageType 	= self:GetAbilityDamageType()
	local trailRadius 	= self:GetSpecialValueFor("trail_radius")
	local trailDelay 	= self:GetSpecialValueFor("trail_prepare")

	local units = self:FindUnits(caster, pos, radius)

	if #units == 0 then return end

	local positions = {}

	for _, unit in pairs(units) do
		if unit and IsValidEntity(unit) then
			local unitPos = unit:GetAbsOrigin()
			table.insert(positions, unit:GetAbsOrigin())

			local idx = ParticleManager:CreateParticle("particles/bosses/possessed/magma_trails_start.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(idx, 0, unitPos )
			ParticleManager:SetParticleControl(idx, 1, Vector(trailRadius, 0, 0) )
			ParticleManager:SetParticleControl(idx, 2, Vector(trailDelay, 0, 0) )
		end
	end

	units = nil

	caster:EmitSound("Boss_Possessed.MagmaTrails.Cast")

	Timers:CreateTimer( trailDelay, function()
		-- check everything that can happend.
		if not self then return end
		if self:IsNull() then return end
		if not caster then return end
		if caster:IsNull() or not IsValidEntity(caster) then return end
		if not caster:IsAlive() then return end

		for _, position in pairs( positions ) do
			local enemies = self:FindUnits(caster, position, trailRadius)

			for _, enemy in pairs(enemies) do
				if enemy and IsValidEntity(enemy) then
					ApplyDamage({
						victim = enemy,
						attacker = caster,
						damage = damage,
						damage_type = damageType,
						ability = self,
					})
				end
			end

			local idx = ParticleManager:CreateParticle("particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_linger.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(idx, 0, position )
			EmitSoundOnLocationWithCaster(position, "Boss_Possessed.MagmaTrails.Trail", caster)
		end
	end)
end
