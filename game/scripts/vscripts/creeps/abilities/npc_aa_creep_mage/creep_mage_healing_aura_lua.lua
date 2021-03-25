creep_mage_healing_aura_lua = class({})
LinkLuaModifier( "modifier_creep_mage_healing_aura_lua", "creeps/abilities/npc_aa_creep_mage/modifier_creep_mage_healing_aura_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creep_mage_healing_aura_lua:GetIntrinsicModifierName()
	return "modifier_creep_mage_healing_aura_lua"
end

--------------------------------------------------------------------------------