megacreep_warrior_aura_lua = class({})
LinkLuaModifier( "modifier_megacreep_warrior_aura_lua", "creeps/abilities/npc_aa_megacreep_warrior/modifier_megacreep_warrior_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_megacreep_warrior_aura_effect_lua", "creeps/abilities/npc_aa_megacreep_warrior/modifier_megacreep_warrior_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function megacreep_warrior_aura_lua:GetIntrinsicModifierName()
	return "modifier_megacreep_warrior_aura_lua"
end

--------------------------------------------------------------------------------