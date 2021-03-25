item_agile_wand = item_agile_wand or class({})
local ability = item_agile_wand

LinkLuaModifier("modifier_agile_wand", 'items/agile_wand/modifiers/modifier_agile_wand', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_agile_wand"
end
