require('items/second_attacks')

item_bandoline_blade = item_bandoline_blade or class({})
local ability = item_bandoline_blade

LinkLuaModifier("modifier_bandoline_blade", "items/bandoline_blade/modifiers/modifier_bandoline_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bandoline_blade_cd", "items/bandoline_blade/modifiers/modifier_bandoline_blade_cd", LUA_MODIFIER_MOTION_NONE)

MeleeSecondAttack:RegisterSecondAttack("modifier_bandoline_blade_cd")

function ability:GetIntrinsicModifierName()
	return "modifier_bandoline_blade"
end