ogre_big_aura = class({})
LinkLuaModifier( "modifier_ogre_big_aura", 'creeps/abilities/modifiers/modifier_ogre_big_aura', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_big_aura_emitter", 'creeps/abilities/modifiers/modifier_ogre_big_aura_emitter', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function ogre_big_aura:GetIntrinsicModifierName()
	return "modifier_ogre_big_aura_emitter"
end