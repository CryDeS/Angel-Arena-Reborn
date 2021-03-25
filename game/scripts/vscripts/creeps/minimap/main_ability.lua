ability_hidden_from_map = ability_hidden_from_map or class({})

LinkLuaModifier( "modifier_hidden_from_map",	'modifiers/modifier_hidden_from_map', 	LUA_MODIFIER_MOTION_NONE )

function ability_hidden_from_map:GetIntrinsicModifierName()
	return "modifier_hidden_from_map"
end