ghost_small_blue_lightning = class({})
--------------------------------------------------------------------------------

function ghost_small_blue_lightning:OnSpellStart( keys )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	if IsServer() then 
		local damage_type = self:GetAbilityDamageType() 

		ApplyDamage({ 
			victim = target, 
			attacker = caster, 
			damage = self:GetSpecialValueFor("damage_main"), 
			damage_type = damage_type, 
			ability = self })

		local units = FindUnitsInRadius(	caster:GetTeamNumber(), 
													target:GetAbsOrigin(), 
													nil, 
													self:GetSpecialValueFor("radius"), 
													DOTA_UNIT_TARGET_TEAM_ENEMY, 
													DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
													DOTA_UNIT_TARGET_FLAG_NONE, 
													0, 
													false) 
		
		if units then
			for i = 1, #units do
				if units[i] and units[i] ~= target then
					ApplyDamage({ 
						victim = units[i], 
						attacker = caster, 
						damage = self:GetSpecialValueFor("damage_second"), 
						damage_type = damage_type, 
						ability = self })
				end
			end
		end

	end 

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_static_link_beam.vpcf",  PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)

	local f = function()
		ParticleManager:DestroyParticle(particle, false)
		return nil 
	end 

	Timers:CreateTimer(0.1, f)

	target:EmitSound("Hero_Zuus.ArcLightning.Cast")
	
	local particle2 = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_trigger_beams.vpcf",  PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(particle2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
end