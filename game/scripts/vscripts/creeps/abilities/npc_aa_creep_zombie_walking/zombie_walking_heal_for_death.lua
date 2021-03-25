zombie_walking_heal_for_death = class({})
LinkLuaModifier( "modifier_zombie_walking_heal_for_death", "creeps/abilities/npc_aa_creep_zombie_walking/modifier_zombie_walking_heal_for_death", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function zombie_walking_heal_for_death:GetIntrinsicModifierName()
    return "modifier_zombie_walking_heal_for_death"
end

--------------------------------------------------------------------------------