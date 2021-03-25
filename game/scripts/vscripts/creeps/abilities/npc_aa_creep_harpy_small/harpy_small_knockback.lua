harpy_small_knockback = class({})

LinkLuaModifier( "modifier_harpy_knockback_active", "creeps/abilities/npc_aa_creep_harpy_small/modifiers/modifier_harpy_knockback_active", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------

function harpy_small_knockback:OnSpellStart()
	local duration			= self:GetSpecialValueFor( "duration" )
	local radius			= self:GetSpecialValueFor( "radius" )
	local caster 			= self:GetCaster()
	local point 			= self:GetCursorPosition() 

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	if enemies then
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, self, "modifier_harpy_knockback_active", { radius = radius, dur = duration, duration = duration, point = Vector(point.x, point.y, point.z)})
		end 
	end

 	hParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    ParticleManager:SetParticleControl(hParticle, 0, point)
    ParticleManager:SetParticleControl(hParticle, 1, point)
    ParticleManager:ReleaseParticleIndex(hParticle)
    GridNav:DestroyTreesAroundPoint(point, radius, true)
end

--------------------------------------------------------------------------------