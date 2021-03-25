npc_aa_creep_centaur_big_aura_hp_regen_lua = class({})
LinkLuaModifier( "modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua", "creeps/abilities/npc_aa_creep_centaur_big/modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_aa_creep_centaur_big_aura_effect_hp_regen_lua", "creeps/abilities/npc_aa_creep_centaur_big/modifier_npc_aa_creep_centaur_big_aura_effect_hp_regen_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function npc_aa_creep_centaur_big_aura_hp_regen_lua:GetIntrinsicModifierName()
	return "modifier_npc_aa_creep_centaur_big_aura_hp_regen_lua"
end

--------------------------------------------------------------------------------