fireblade_firestrip = fireblade_firestrip or class({})
local ability = fireblade_firestrip

LinkLuaModifier( "modifier_fireblade_firestrip_buff", 'heroes/fireblade/modifiers/modifier_fireblade_firestrip_buff', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fireblade_firestrip_debuff", 'heroes/fireblade/modifiers/modifier_fireblade_firestrip_debuff', LUA_MODIFIER_MOTION_NONE )

function ability:OnSpellStart( keys )
	if not IsServer() then return end

	local caster 			= self:GetCaster()
	local casterPos 		= caster:GetAbsOrigin()

	local radius 			= self:GetCastRange(casterPos, nil) + caster:GetCastRangeBonus()
	local magicalDamage 	= self:GetSpecialValueFor("damage")

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf", PATTACH_ABSORIGIN, caster )

	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)

	Timers:CreateTimer(0.001, function()
		ParticleManager:DestroyParticle(particle, false)
	end)

	EmitSoundOn( "Hero_EmberSpirit.SleightOfFist.Cast", caster )

	local flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS

	if caster:HasTalent("fireblade_talent_firestrip_spellimmune") then
		flags = flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end

	local units = FindUnitsInRadius( caster:GetTeamNumber(),
									 caster:GetAbsOrigin(),
									 nil,
									 radius,
									 DOTA_UNIT_TARGET_TEAM_ENEMY,
									 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
									 flags,
									 0, 
									 false) 
	
	if not units then return  end

	local stunDuration = caster:GetTalentSpecialValueFor("fireblade_talent_firestrip_stun")

	local nUnits = 0

	for _, unit in pairs(units) do
		local damage = caster:GetAverageTrueAttackDamage(nil) 

		local damage_table = {
			victim 		= unit, 
			attacker 	= caster, 
			damage 		= damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability 	= self,
		}

		ApplyDamage(damage_table)

		damage_table.damage = magicalDamage
		damage_table.damage_type = self:GetAbilityDamageType() 

		ApplyDamage(damage_table)

		ParticleManager:CreateParticle( "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_ABSORIGIN, unit )

		if stunDuration > 0 then
			unit:AddNewModifier(caster, self, "modifier_fireblade_firestrip_debuff", { duration = stunDuration })
		end

		EmitSoundOn( "Hero_EmberSpirit.SleightOfFist.Damage", unit )

		if unit:IsRealHero() then
			nUnits = nUnits + 1
		end
	end


	if nUnits ~= 0 then
		local mod = caster:FindModifierByNameAndCaster("modifier_fireblade_firestrip_buff", caster)

		local duration = self:GetSpecialValueFor("buff_duration")

		if not mod then
			mod = caster:AddNewModifier(caster, self, "modifier_fireblade_firestrip_buff", { duration = duration } )
		else
			mod:SetDuration(duration, true)
			nUnits = nUnits + mod:GetStackCount()
		end

		mod:SetStackCount( nUnits )
	end
end