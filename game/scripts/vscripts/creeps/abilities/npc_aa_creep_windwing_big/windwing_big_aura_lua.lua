windwing_big_aura_lua = class({})
LinkLuaModifier( "modifier_windwing_big_aura_lua", "creeps/abilities/npc_aa_creep_windwing_big/modifier_windwing_big_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_windwing_big_aura_effect_lua", "creeps/abilities/npc_aa_creep_windwing_big/modifier_windwing_big_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function windwing_big_aura_lua:GetIntrinsicModifierName()
	return "modifier_windwing_big_aura_lua"
end

--------------------------------------------------------------------------------