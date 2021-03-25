item_damned_swords = item_damned_swords or class({})
local ability = item_damned_swords

LinkLuaModifier("modifier_damned_swords", 		  "items/damned_swords/modifiers/modifier_damned_swords", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_damned_swords_debuff", "items/damned_swords/modifiers/modifier_damned_swords_debuff", LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_damned_swords"
end