function OnSpellStart( keys )
	local caster 		= keys.caster 
	local soul_ability 	= caster.soul_ability
	local ability 		= keys.ability 
	local modifier_name = keys.ModifierName 
	local modifier_stun = keys.ModifierStun 

	local max_souls 	= 0

	if soul_ability then
		max_souls = soul_ability:GetSpecialValueFor("max_souls") or 0 
	end

	local current_souls = caster:GetModifierStackCount(modifier_name, caster) or 0

	local dmg_by_hero	= keys.DmgHero 
	local dmg_by_creep	= keys.DmgCreep 
	local dmg_pct 		= keys.DmgPct / 100
	local radius 		= keys.Radius 

	local talent 		= caster:FindAbilityByName("reaver_lord_special_bonus_no_souls")

	if talent then
		if current_souls < max_souls and talent:GetLevel() == 0 then 
			ability:EndCooldown() 
			ability:RefundManaCost()
			return 
		end
	end

	--caster:RemoveModifierByName(modifier_name)


	local units = FindUnitsInRadius(	caster:GetTeamNumber(), 
										caster:GetAbsOrigin() ,
										nil, 
										radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
										0, 
										false) 
	
	if not units or units == {} then return end


	local total_damage = 0
	
	for i = 0, #units do
		if units[i] then
			if units[i]:IsRealHero() then
				total_damage = total_damage + dmg_by_hero
			else
				total_damage = total_damage + dmg_by_creep
			end
		end
	end

	
	local point = caster:GetAbsOrigin() + caster:GetForwardVector():Normalized() * 200

	local last_target

	for i = 0, #units do
		if units[i] then
			ability:ApplyDataDrivenModifier(caster, units[i], modifier_stun, {})
			if not BossSpawner:IsBoss(units[i]) then

				ApplyDamage({	victim = units[i], 
								attacker = caster, 
								damage = (total_damage  + units[i]:GetMaxHealth() * dmg_pct), 
								damage_type = DAMAGE_TYPE_MAGICAL })
			end
			FindClearSpaceForUnit(units[i], point, false)
			last_target = units[i]
		end
	end
	
	if(not last_target) then 
		return 
	end
	local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"	
	local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, last_target )

	ParticleManager:SetParticleControlEnt(particle, 0, last_target, PATTACH_POINT_FOLLOW, "attach_hitloc", last_target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", last_target:GetAbsOrigin(), true)

	local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )

	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", last_target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, last_target, PATTACH_POINT_FOLLOW, "attach_hitloc", last_target:GetAbsOrigin(), true)
end
