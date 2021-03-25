golem_small_aura = golem_small_aura or class({})

LinkLuaModifier( "modifier_golem_small_aura", 'creeps/abilities/golems/modifiers/modifier_golem_small_aura', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_golem_small_aura_emitter", 'creeps/abilities/golems/modifiers/modifier_golem_small_aura_emitter', LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function golem_small_aura:GetIntrinsicModifierName()
	return "modifier_golem_small_aura_emitter"
end