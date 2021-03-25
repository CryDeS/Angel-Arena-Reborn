item_consumption_orb = item_consumption_orb or class({})
local ability = item_consumption_orb

LinkLuaModifier("modifier_item_consumption_orb", 'items/consumption_orb/modifiers/modifier_item_consumption_orb', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_item_consumption_orb"
end
