demon_archer_runaway = class({})
LinkLuaModifier( "modifier_demon_archer_runaway", "creeps/abilities/npc_aa_creep_demon_archer/modifier_demon_archer_runaway", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_archer_runaway_effect", "creeps/abilities/npc_aa_creep_demon_archer/modifier_demon_archer_runaway_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function demon_archer_runaway:GetIntrinsicModifierName()
    return "modifier_demon_archer_runaway"
end

--------------------------------------------------------------------------------