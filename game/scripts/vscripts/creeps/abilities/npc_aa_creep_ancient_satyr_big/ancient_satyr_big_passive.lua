ancient_satyr_big_passive = class({})

LinkLuaModifier( "modifier_ancient_satyr_big_passive", "creeps/abilities/npc_aa_creep_ancient_satyr_big/modifier_ancient_satyr_big_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ancient_satyr_big_passive_slow", "creeps/abilities/npc_aa_creep_ancient_satyr_big/modifier_ancient_satyr_big_passive_slow", LUA_MODIFIER_MOTION_NONE )

function ancient_satyr_big_passive:GetIntrinsicModifierName() return "modifier_ancient_satyr_big_passive" end
