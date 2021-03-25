megacreep_beast_haste = class({})

LinkLuaModifier("modifier_megacreep_beast_haste", "creeps/abilities/megacreep_beast/modifiers/modifier_megacreep_beast_haste", LUA_MODIFIER_MOTION_NONE)

function megacreep_beast_haste:OnSpellStart()
	local caster = self:GetCaster() 
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

    local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	if not allies then return end 

	for _, ally in pairs(allies) do
		ally:AddNewModifier(caster, self, "modifier_megacreep_beast_haste", { duration=duration })
	end 

	caster:EmitSound("Hero_ElderTitan.AncestralSpirit.Buff")
end

---------------------------------------------------------------------------