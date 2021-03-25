skelet_2_aura = class({})
LinkLuaModifier( "modifier_skelet_2_aura", "creeps/abilities/npc_aa_creep_skelet_2/modifier_skelet_2_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skelet_2_aura_effect", "creeps/abilities/npc_aa_creep_skelet_2/modifier_skelet_2_aura_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function skelet_2_aura:GetIntrinsicModifierName()
	return "modifier_skelet_2_aura"
end

--------------------------------------------------------------------------------