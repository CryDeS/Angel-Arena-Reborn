ghost_small_red_magic_fire = class({})
LinkLuaModifier( "modifier_ghost_small_red_magic_fire", 'creeps/abilities/modifiers/modifier_ghost_small_red_magic_fire', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ghost_small_red_magic_fire:OnSpellStart( keys )
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_ghost_small_red_magic_fire", { damage = self:GetSpecialValueFor("damage"), duration = self:GetSpecialValueFor("duration")} ) 
end