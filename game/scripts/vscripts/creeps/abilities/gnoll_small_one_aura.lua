gnoll_small_one_aura = class({})
LinkLuaModifier( "modifier_gnoll_small_one_aura", 'creeps/abilities/modifiers/modifier_gnoll_small_one_aura', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gnoll_small_one_aura_emitter", 'creeps/abilities/modifiers/modifier_gnoll_small_one_aura_emitter', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function gnoll_small_one_aura:GetIntrinsicModifierName()
	return "modifier_gnoll_small_one_aura_emitter"
end