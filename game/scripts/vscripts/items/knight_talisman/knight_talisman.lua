item_knight_talisman = item_knight_talisman or class({})
local ability = item_knight_talisman

LinkLuaModifier("modifier_knight_talisman", 'items/knight_talisman/modifiers/modifier_knight_talisman', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_knight_talisman"
end
