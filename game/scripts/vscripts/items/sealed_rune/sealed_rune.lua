item_sealed_rune = item_sealed_rune or class({})
local ability = item_sealed_rune

LinkLuaModifier("modifier_sealed_rune", "items/sealed_rune/modifiers/modifier_sealed_rune", LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_sealed_rune"
end