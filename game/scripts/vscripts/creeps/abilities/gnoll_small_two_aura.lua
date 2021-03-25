gnoll_small_two_aura = class({})
LinkLuaModifier( "modifier_gnoll_small_two_aura", 'creeps/abilities/modifiers/modifier_gnoll_small_two_aura', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gnoll_small_two_aura_emitter", 'creeps/abilities/modifiers/modifier_gnoll_small_two_aura_emitter', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function gnoll_small_two_aura:GetIntrinsicModifierName()
	return "modifier_gnoll_small_two_aura_emitter"
end