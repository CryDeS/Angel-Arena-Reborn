zombie_lying_passive_boost_movespeed = class({})
LinkLuaModifier( "modifier_zombie_lying_passive_boost_movespeed", "creeps/abilities/npc_aa_creep_zombie_lying/modifier_zombie_lying_passive_boost_movespeed", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zombie_lying_passive_boost_movespeed:GetIntrinsicModifierName()
    return "modifier_zombie_lying_passive_boost_movespeed"
end

--------------------------------------------------------------------------------