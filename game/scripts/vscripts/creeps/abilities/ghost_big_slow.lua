ghost_big_slow = class({})
LinkLuaModifier( "modifier_ghost_big_slow", 'creeps/abilities/modifiers/modifier_ghost_big_slow', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ghost_big_slow:OnSpellStart( keys )
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_ghost_big_slow", { duration = self:GetSpecialValueFor("duration") } ) 
end