item_cursed_orb = item_cursed_orb or class({})
local ability = item_cursed_orb

LinkLuaModifier("modifier_item_cursed_orb", 'items/cursed_orb/modifiers/modifier_item_cursed_orb', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_item_cursed_orb"
end
