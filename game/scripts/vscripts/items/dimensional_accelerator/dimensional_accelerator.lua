item_dimensional_accelerator = item_dimensional_accelerator or class({})
local ability = item_dimensional_accelerator

LinkLuaModifier("modifier_item_dimensional_accelerator", 'items/dimensional_accelerator/modifiers/modifier_item_dimensional_accelerator', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_item_dimensional_accelerator"
end
