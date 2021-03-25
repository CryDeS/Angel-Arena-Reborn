small_satyr_little_aura_mag_resist = class({})

LinkLuaModifier( "modifier_small_satyr_little_aura_mag_resist", 'creeps/abilities/npc_aa_creep_small_satyr_little/modifier_small_satyr_little_aura_mag_resist', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_small_satyr_little_aura_mag_resist_emitter", 'creeps/abilities/npc_aa_creep_small_satyr_little/modifier_small_satyr_little_aura_mag_resist_emitter', LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function small_satyr_little_aura_mag_resist:GetIntrinsicModifierName()
	return "modifier_small_satyr_little_aura_mag_resist_emitter"
end