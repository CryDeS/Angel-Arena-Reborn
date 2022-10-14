item_burning_sword = item_burning_sword or class({}) 
item_burning_sword_dummy = item_burning_sword

LinkLuaModifier( "modifier_burning_sword_passive", 		'items/burning_sword/modifiers/modifier_burning_sword_passive',   	LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_burning_sword_disarmor", 		'items/burning_sword/modifiers/modifier_burning_sword_disarmor', 		LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_burning_sword_disarmor_cd", 	'items/burning_sword/modifiers/modifier_burning_sword_disarmor_cd', 	LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_burning_sword:GetIntrinsicModifierName()
	return "modifier_burning_sword_passive"
end
