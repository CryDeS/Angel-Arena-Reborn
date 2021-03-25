small_satyr_big_bash = class({})

LinkLuaModifier("modifier_small_satyr_big_bash_passive", "creeps/abilities/npc_aa_creep_small_satyr_big/modifier_small_satyr_big_bash_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_small_satyr_big_bash_stunned", "creeps/abilities/npc_aa_creep_small_satyr_big/modifier_small_satyr_big_bash_stunned", LUA_MODIFIER_MOTION_NONE)

---------------------------------------------------------------------------

function small_satyr_big_bash:GetIntrinsicModifierName()
    return "modifier_small_satyr_big_bash_passive"
end

---------------------------------------------------------------------------