megacreep_warrior_passive_rage_lua = class({})
LinkLuaModifier( "modifier_megacreep_warrior_passive_rage_lua", "creeps/abilities/npc_aa_megacreep_warrior/modifier_megacreep_warrior_passive_rage_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_megacreep_warrior_passive_rage_effect_lua", "creeps/abilities/npc_aa_megacreep_warrior/modifier_megacreep_warrior_passive_rage_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function megacreep_warrior_passive_rage_lua:GetIntrinsicModifierName()
    return "modifier_megacreep_warrior_passive_rage_lua"
end

--------------------------------------------------------------------------------