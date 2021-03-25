ogre_big_passive = class({})
LinkLuaModifier( "modifier_ogre_big_passive", 'creeps/abilities/modifiers/modifier_ogre_big_passive', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_big_passive_bash", 'creeps/abilities/modifiers/modifier_ogre_big_passive_bash', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function ogre_big_passive:GetIntrinsicModifierName()
	return "modifier_ogre_big_passive"
end