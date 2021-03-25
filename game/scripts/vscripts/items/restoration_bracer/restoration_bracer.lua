item_restoration_bracer = item_restoration_bracer or class({})
local ability = item_restoration_bracer

LinkLuaModifier("modifier_item_restoration_bracer", 'items/restoration_bracer/modifiers/modifier_item_restoration_bracer', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_item_restoration_bracer"
end
