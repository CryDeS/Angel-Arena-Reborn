abyss_warrior_charged_attack = abyss_warrior_charged_attack or class({})

local ability = abyss_warrior_charged_attack

LinkLuaModifier( "modifier_abyss_warrior_charged_attack", 		 'creeps/boss/abyss_warrior/modifiers/modifier_abyss_warrior_charged_attack', 		 LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abyss_warrior_charged_attack_stun", 	 'creeps/boss/abyss_warrior/modifiers/modifier_abyss_warrior_charged_attack_stun', 	 LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abyss_warrior_charged_attack_linken", 'creeps/boss/abyss_warrior/modifiers/modifier_abyss_warrior_charged_attack_linken', LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_abyss_warrior_charged_attack"
end