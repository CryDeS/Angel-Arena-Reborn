megacreep_ancient_golem_burn_close = class({})
LinkLuaModifier("modifier_megacreep_ancient_golem_burn_close","creeps/abilities/megacreep_golem/modifiers/modifier_megacreep_ancient_golem_burn_close", LUA_MODIFIER_MOTION_NONE)

function megacreep_ancient_golem_burn_close:OnSpellStart()
	local caster   = self:GetCaster()
	local radius   = self:GetSpecialValueFor("radius")
	local Duration = self:GetSpecialValueFor("duration")
	local enemies  = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster,self, "modifier_megacreep_ancient_golem_burn_close", {duration = Duration})
	end
	local part = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(part, 1, Vector(radius,radius,radius) )
	ParticleManager:SetParticleControlEnt(part, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(part)
end