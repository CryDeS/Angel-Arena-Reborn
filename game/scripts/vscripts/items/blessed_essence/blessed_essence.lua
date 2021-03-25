item_blessed_essence = item_blessed_essence or class({})
local ability = item_blessed_essence

LinkLuaModifier("modifier_blessed_essence", 'items/blessed_essence/modifiers/modifier_blessed_essence', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_blessed_essence"
end
