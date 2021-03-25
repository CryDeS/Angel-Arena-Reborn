item_holy_book = item_holy_book or class({})
local ability = item_holy_book

LinkLuaModifier("modifier_holy_book", 'items/holy_book/modifiers/modifier_holy_book', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_holy_book"
end
