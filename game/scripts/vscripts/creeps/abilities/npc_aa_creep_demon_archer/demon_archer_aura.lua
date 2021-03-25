demon_archer_aura = class({})
LinkLuaModifier( "modifier_demon_archer_aura", "creeps/abilities/npc_aa_creep_demon_archer/modifier_demon_archer_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_archer_aura_effect", "creeps/abilities/npc_aa_creep_demon_archer/modifier_demon_archer_aura_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function demon_archer_aura:GetIntrinsicModifierName()
	return "modifier_demon_archer_aura"
end

--------------------------------------------------------------------------------