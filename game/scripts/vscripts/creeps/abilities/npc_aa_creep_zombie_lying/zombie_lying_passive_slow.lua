zombie_lying_passive_slow = class({})
LinkLuaModifier( "modifier_zombie_lying_passive_slow", "creeps/abilities/npc_aa_creep_zombie_lying/modifier_zombie_lying_passive_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zombie_lying_passive_slow_effect", "creeps/abilities/npc_aa_creep_zombie_lying/modifier_zombie_lying_passive_slow_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zombie_lying_passive_slow:GetIntrinsicModifierName()
    return "modifier_zombie_lying_passive_slow"
end

--------------------------------------------------------------------------------