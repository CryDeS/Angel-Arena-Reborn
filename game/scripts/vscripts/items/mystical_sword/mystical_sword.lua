item_mystical_sword = item_mystical_sword or class({})
local ability = item_mystical_sword

LinkLuaModifier("modifier_mystical_sword", 		  "items/mystical_sword/modifiers/modifier_mystical_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mystical_sword_debuff", "items/mystical_sword/modifiers/modifier_mystical_sword_debuff", LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_mystical_sword"
end