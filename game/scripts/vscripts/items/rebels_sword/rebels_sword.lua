item_rebels_sword = item_rebels_sword or class({}) 
item_rebels_sword_dummy = item_rebels_sword

LinkLuaModifier( "modifier_rebels_sword_passive", 		'items/rebels_sword/modifiers/modifier_rebels_sword_passive',   	LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rebels_sword_disarmor", 		'items/rebels_sword/modifiers/modifier_rebels_sword_disarmor', 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rebels_sword_disarmor_cd", 	'items/rebels_sword/modifiers/modifier_rebels_sword_disarmor_cd', 	LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_rebels_sword:GetIntrinsicModifierName()
	return "modifier_rebels_sword_passive"
end
