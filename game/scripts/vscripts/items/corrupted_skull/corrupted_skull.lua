item_corrupted_skull = item_corrupted_skull or class({})
local ability = item_corrupted_skull

LinkLuaModifier("modifier_corrupted_skull", 		"items/corrupted_skull/modifiers/modifier_corrupted_skull", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_corrupted_skull_debuff", 	"items/corrupted_skull/modifiers/modifier_corrupted_skull_debuff", LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_corrupted_skull"
end