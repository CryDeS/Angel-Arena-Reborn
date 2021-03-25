npc_aa_creep_wolf_big_damage_aura_lua = class({})
LinkLuaModifier( "modifier_npc_aa_creep_wolf_big_damage_aura_lua", "creeps/abilities/npc_aa_creep_wolf_big/modifier_npc_aa_creep_wolf_big_damage_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_aa_creep_wolf_big_damage_aura_effect_lua", "creeps/abilities/npc_aa_creep_wolf_big/modifier_npc_aa_creep_wolf_big_damage_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function npc_aa_creep_wolf_big_damage_aura_lua:GetIntrinsicModifierName()
	return "modifier_npc_aa_creep_wolf_big_damage_aura_lua"
end

--------------------------------------------------------------------------------