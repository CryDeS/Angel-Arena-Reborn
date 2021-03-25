item_boss_soul = item_boss_soul or class({})
item_boss_soul_dummy = item_boss_soul

local ability = item_boss_soul

ability.ForceShareable = true

LinkLuaModifier( "modifier_boss_soul", 'items/boss_soul/modifiers/modifier_boss_soul', LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_boss_soul"
end
