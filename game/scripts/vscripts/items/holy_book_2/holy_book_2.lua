item_holy_book_2 = item_holy_book_2 or class({})
local ability = item_holy_book_2

LinkLuaModifier("modifier_holy_book_2", 'items/holy_book_2/modifiers/modifier_holy_book_2', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_holy_book_2"
end
