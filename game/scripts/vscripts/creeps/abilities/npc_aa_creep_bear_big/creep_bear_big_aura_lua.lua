creep_bear_big_aura_lua = class({})
LinkLuaModifier( "modifier_creep_bear_big_aura_lua", "creeps/abilities/npc_aa_creep_bear_big/modifier_creep_bear_big_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creep_bear_big_aura_effect_lua", "creeps/abilities/npc_aa_creep_bear_big/modifier_creep_bear_big_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creep_bear_big_aura_lua:GetIntrinsicModifierName()
	return "modifier_creep_bear_big_aura_lua"
end

--------------------------------------------------------------------------------