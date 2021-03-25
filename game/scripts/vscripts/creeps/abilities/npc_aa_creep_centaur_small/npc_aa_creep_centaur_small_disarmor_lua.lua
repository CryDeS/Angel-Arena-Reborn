npc_aa_creep_centaur_small_disarmor_lua = class({})
LinkLuaModifier( "modifier_npc_aa_creep_centaur_small_disarmor_lua", "creeps/abilities/npc_aa_creep_centaur_small/modifier_npc_aa_creep_centaur_small_disarmor_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_aa_creep_centaur_small_disarmor_effect_lua", "creeps/abilities/npc_aa_creep_centaur_small/modifier_npc_aa_creep_centaur_small_disarmor_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "npc_aa_creep_centaur_small_disarmor_cooldown_lua", "creeps/abilities/npc_aa_creep_centaur_small/npc_aa_creep_centaur_small_disarmor_cooldown_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function npc_aa_creep_centaur_small_disarmor_lua:GetIntrinsicModifierName()
    return "modifier_npc_aa_creep_centaur_small_disarmor_lua"
end

--------------------------------------------------------------------------------