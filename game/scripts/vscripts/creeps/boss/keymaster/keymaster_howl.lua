keymaster_howl = keymaster_howl or class({})

local ability = keymaster_howl

LinkLuaModifier( "modifier_keymaster_howl_stun", 	'creeps/boss/keymaster/modifiers/modifier_keymaster_howl_stun', 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_keymaster_howl_silence", 'creeps/boss/keymaster/modifiers/modifier_keymaster_howl_silence', 	LUA_MODIFIER_MOTION_NONE )

function makePartilce(unit)
	local pos = unit:GetAbsOrigin()

	local idx = ParticleManager:CreateParticle("particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6_ring_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

	ParticleManager:SetParticleControlEnt( idx, 0, unit, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", pos, true)
	ParticleManager:SetParticleControlEnt( idx, 1, unit, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", pos, true)
end

function ability:OnSpellStart()
	if not IsServer() then return end
	if not self or self:IsNull() then return end

	local caster = self:GetCaster()

	if not caster or caster:IsNull() then return end

	local pos 		= caster:GetAbsOrigin()
	local radius   	= self:GetCastRange(pos, nil) + caster:GetCastRangeBonus()

	local units = FindUnitsInRadius( caster:GetTeamNumber(),
									 pos,
									 caster,
									 radius,
									 self:GetAbilityTargetTeam(),
									 self:GetAbilityTargetType(),
									 self:GetAbilityTargetFlags(),
									 FIND_ANY_ORDER, 
									 false )

	local stunDuration 		= self:GetSpecialValueFor("stun_duration")
	local silenceDuration 	= self:GetSpecialValueFor("silence_duration")

	for _, unit in pairs(units) do
		if unit and not unit:IsNull() then
			unit:AddNewModifier(caster, self, "modifier_keymaster_howl_stun", { duration = stunDuration })
			unit:AddNewModifier(caster, self, "modifier_keymaster_howl_silence", { duration = silenceDuration })

			makePartilce(unit)
		end
	end

	ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_silence_ice.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	
	local idx = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9_crimson_impact_damage_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	
	caster:EmitSound("Boss_Keymaster.Howl.Cast")
end

