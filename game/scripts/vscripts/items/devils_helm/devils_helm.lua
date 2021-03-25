item_devils_helm = item_devils_helm or class({})
local ability = item_devils_helm

LinkLuaModifier("modifier_devils_helm", 		"items/devils_helm/modifiers/modifier_devils_helm", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_devils_helm_debuff", 	"items/devils_helm/modifiers/modifier_devils_helm_debuff", LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_devils_helm"
end