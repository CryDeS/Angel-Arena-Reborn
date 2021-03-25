ogre_small_buff = class({})
LinkLuaModifier( "modifier_ogre_small_buff", 'creeps/abilities/modifiers/modifier_ogre_small_buff', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_small_buff_enemy", 'creeps/abilities/modifiers/modifier_ogre_small_buff_enemy', LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ogre_small_buff:OnSpellStart( keys )
	local target = self:GetCursorTarget() 
	
	target:AddNewModifier(self:GetCaster(), self, "modifier_ogre_small_buff", { duration = self:GetSpecialValueFor("duration") })
end