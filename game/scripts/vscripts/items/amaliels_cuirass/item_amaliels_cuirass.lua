item_amaliels_cuirass = class({})
LinkLuaModifier( "modifier_amaliels_cuirass", 				'items/amaliels_cuirass/modifier_amaliels_cuirass', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_amaliels_cuirass_aura_friend", 	'items/amaliels_cuirass/modifier_amaliels_cuirass_aura_friend', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_amaliels_cuirass_enemy_emitter", 'items/amaliels_cuirass/modifier_amaliels_cuirass_enemy_emitter', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_amaliels_cuirass_aura_enemy",  	'items/amaliels_cuirass/modifier_amaliels_cuirass_aura_enemy', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_amaliels_cuirass:GetIntrinsicModifierName()
	return "modifier_amaliels_cuirass"
end
