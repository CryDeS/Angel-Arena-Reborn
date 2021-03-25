possessed_fallen_sword = possessed_fallen_sword or class({})

local ability = possessed_fallen_sword

LinkLuaModifier( "modifier_possessed_fallen_sword", 		'creeps/boss/possessed/modifiers/modifier_possessed_fallen_sword', 			LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_possessed_fallen_sword_anim", 	'creeps/boss/possessed/modifiers/modifier_possessed_fallen_sword_anim', 	LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_possessed_fallen_sword_debuff", 	'creeps/boss/possessed/modifiers/modifier_possessed_fallen_sword_debuff', 	LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_possessed_fallen_sword"
end