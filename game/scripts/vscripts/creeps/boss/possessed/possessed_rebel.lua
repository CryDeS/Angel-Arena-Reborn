possessed_rebel = possessed_rebel or class({})

local ability = possessed_rebel

LinkLuaModifier( "modifier_possessed_rebel", 		'creeps/boss/possessed/modifiers/modifier_possessed_rebel', 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_possessed_rebel_debuff", 'creeps/boss/possessed/modifiers/modifier_possessed_rebel_debuff', 	LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_possessed_rebel"
end