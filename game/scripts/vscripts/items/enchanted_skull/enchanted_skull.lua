item_enchanted_skull = item_enchanted_skull or class({})
local ability = item_enchanted_skull

LinkLuaModifier("modifier_enchanted_skull", 		"items/enchanted_skull/modifiers/modifier_enchanted_skull", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enchanted_skull_debuff", 	"items/enchanted_skull/modifiers/modifier_enchanted_skull_debuff", LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_enchanted_skull"
end