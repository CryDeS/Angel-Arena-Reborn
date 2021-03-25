small_satyr_middle_dmg_amplify = class({})

LinkLuaModifier( "modifier_small_satyr_middle_dmg_amplify", 'creeps/abilities/npc_aa_creep_small_satyr_middle/modifier_small_satyr_middle_dmg_amplify', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_small_satyr_middle_dmg_amplify_emitter", 'creeps/abilities/npc_aa_creep_small_satyr_middle/modifier_small_satyr_middle_dmg_amplify_emitter', LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function small_satyr_middle_dmg_amplify:GetIntrinsicModifierName()
	return "modifier_small_satyr_middle_dmg_amplify_emitter"
end