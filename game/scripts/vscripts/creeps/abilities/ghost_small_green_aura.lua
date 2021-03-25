ghost_small_green_aura = class({})
LinkLuaModifier( "modifier_ghost_small_green_aura", 'creeps/abilities/modifiers/modifier_ghost_small_green_aura', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ghost_small_green_aura_emitter", 'creeps/abilities/modifiers/modifier_ghost_small_green_aura_emitter', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function ghost_small_green_aura:GetIntrinsicModifierName()
	return "modifier_ghost_small_green_aura_emitter"
end