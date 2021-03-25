ghost_small_green_nature = class({})
LinkLuaModifier( "modifier_ghost_small_green_nature", 'creeps/abilities/modifiers/modifier_ghost_small_green_nature', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ghost_small_green_nature:OnSpellStart( keys )
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	target:AddNewModifier(caster, self, "modifier_ghost_small_green_nature", { duration = self:GetSpecialValueFor("duration")} ) 
end