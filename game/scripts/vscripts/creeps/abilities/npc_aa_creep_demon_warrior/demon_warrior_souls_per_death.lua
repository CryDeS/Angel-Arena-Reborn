demon_warrior_souls_per_death = class({})
LinkLuaModifier( "modifier_demon_warrior_souls_per_death", "creeps/abilities/npc_aa_creep_demon_warrior/modifier_demon_warrior_souls_per_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_warrior_souls_per_death_effect", "creeps/abilities/npc_aa_creep_demon_warrior/modifier_demon_warrior_souls_per_death_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function demon_warrior_souls_per_death:GetIntrinsicModifierName()
    return "modifier_demon_warrior_souls_per_death"
end

--------------------------------------------------------------------------------