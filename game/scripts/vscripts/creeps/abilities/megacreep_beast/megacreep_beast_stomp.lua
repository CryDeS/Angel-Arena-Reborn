megacreep_beast_stomp = class({})

LinkLuaModifier("modifier_megacreep_beast_stomp_stun", "creeps/abilities/megacreep_beast/modifiers/modifier_megacreep_beast_stomp_stun", LUA_MODIFIER_MOTION_NONE)

---------------------------------------------------------------------------

function megacreep_beast_stomp:CreateEffects(caster, position)
	local pid = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_ABSORIGIN, caster)
   	ParticleManager:SetParticleControl(pid, 0, position)
    ParticleManager:ReleaseParticleIndex(pid)

    caster:EmitSound("n_creep_Thunderlizard_Big.Stomp")
end 

function megacreep_beast_stomp:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("CNY_Beast.Ability.Cast")
	return true 
end 

function megacreep_beast_stomp:OnSpellStart()
	local caster = self:GetCaster() 
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
		
	local position = caster:GetAbsOrigin() + caster:GetForwardVector()*self:GetSpecialValueFor("cast_offset")
	
	self:CreateEffects(caster, position)

    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if not enemies then return end 

	local damage = self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("damage_from_hp") * caster:GetHealth()
	local damage_type = self:GetAbilityDamageType() 

	for _, enemy in pairs(enemies) do
		ApplyDamage({
			victim = enemy, 
			attacker = caster, 
			damage = damage,
			damage_type = damage_type,
			ability = self, 
		})

		enemy:AddNewModifier(caster, self, "modifier_megacreep_beast_stomp_stun", { duration=duration })
	end 
end

---------------------------------------------------------------------------