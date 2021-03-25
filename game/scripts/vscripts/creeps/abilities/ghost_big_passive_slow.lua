ghost_big_passive_slow = class({})
LinkLuaModifier( "modifier_ghost_big_passive_slow_caster", 'creeps/abilities/modifiers/modifier_ghost_big_passive_slow_caster', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ghost_big_passive_slow", 'creeps/abilities/modifiers/modifier_ghost_big_passive_slow', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function ghost_big_passive_slow:GetIntrinsicModifierName()
	return "modifier_ghost_big_passive_slow_caster"
end