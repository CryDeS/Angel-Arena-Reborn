item_burning_blades = item_burning_blades or class({})
local ability = item_burning_blades

LinkLuaModifier("modifier_burning_blades", 		  	"items/burning_blades/modifiers/modifier_burning_blades", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_burning_blades_maim", 	"items/burning_blades/modifiers/modifier_burning_blades_maim", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_burning_blades_disarmor", "items/burning_blades/modifiers/modifier_burning_blades_disarmor", LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_burning_blades"
end