angel_arena_fountain = class({})
LinkLuaModifier( "angel_arena_fountain_aura", "creeps/fountain/angel_arena_fountain_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "angel_arena_fountain_aura_effect", "creeps/fountain/angel_arena_fountain_aura_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function angel_arena_fountain:GetIntrinsicModifierName()
	return "angel_arena_fountain_aura"
end

--------------------------------------------------------------------------------