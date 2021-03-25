item_steel_frame = item_steel_frame or class({})
local ability = item_steel_frame

LinkLuaModifier("modifier_item_steel_frame", 'items/steel_frame/modifiers/modifier_item_steel_frame', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_item_steel_frame"
end
