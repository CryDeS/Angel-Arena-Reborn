item_burning_book = item_burning_book or class({})
local ability = item_burning_book

LinkLuaModifier("modifier_burning_book", 			'items/burning_book/modifiers/modifier_burning_book', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_burning_book_maim", 		"items/burning_book/modifiers/modifier_burning_book_maim", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_burning_book_disarmor", 	"items/burning_book/modifiers/modifier_burning_book_disarmor", LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_burning_book"
end
