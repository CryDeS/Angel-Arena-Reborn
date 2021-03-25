ogre_small_move = class({})
LinkLuaModifier( "modifier_ogre_small_move", 'creeps/abilities/modifiers/modifier_ogre_small_move', LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ogre_small_move:OnSpellStart( keys )
	local target = self:GetCursorTarget() 
	
	target:AddNewModifier(self:GetCaster(), self, "modifier_ogre_small_move", { duration = self:GetSpecialValueFor("duration") })
end