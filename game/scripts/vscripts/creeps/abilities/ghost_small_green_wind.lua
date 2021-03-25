ghost_small_green_wind = class({})
LinkLuaModifier( "modifier_ghost_small_green_wind", 'creeps/abilities/modifiers/modifier_ghost_small_green_wind', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ghost_small_green_wind:OnSpellStart( keys )
	local caster = self:GetCaster()
	caster:EmitSound("DOTA_Item.DoE.Activate")

	local units = FindUnitsInRadius(caster:GetTeamNumber(), 
									caster:GetAbsOrigin(), 
									nil, 
									self:GetSpecialValueFor("radius"), 
									DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
									DOTA_UNIT_TARGET_FLAG_NONE, 
									0, 
									false) 
	
	if units then
		for i = 1, #units do
			if units[i] then
				units[i]:AddNewModifier(caster, self, "modifier_ghost_small_green_wind", { movespeed = self:GetSpecialValueFor("bonus_movespeed"), duration = self:GetSpecialValueFor("duration")} ) 
			end
		end
	end
end