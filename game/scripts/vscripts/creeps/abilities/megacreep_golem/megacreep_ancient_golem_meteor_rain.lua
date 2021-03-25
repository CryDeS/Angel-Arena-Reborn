megacreep_ancient_golem_meteor_rain = class({})

function megacreep_ancient_golem_meteor_rain:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function megacreep_ancient_golem_meteor_rain:OnSpellStart()
	if not IsServer() then return end
	local caster 		= self:GetCaster()
	local point 		= self:GetCursorPosition()
	local radius		= self:GetSpecialValueFor("radius")
	local hit_damage 	= self:GetSpecialValueFor("damage")
	local damage = {
		victim = nil,
		attacker = caster,
		damage = hit_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _, enemy in pairs(enemies) do
		damage.victim = enemy
		ApplyDamage(damage)
	end
	local part = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl( part, 0, point )
	ParticleManager:SetParticleControl( part, 1, Vector( radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( part )
end