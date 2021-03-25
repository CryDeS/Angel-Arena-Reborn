item_health_gel = item_health_gel or class({})
local ability = item_health_gel

LinkLuaModifier("modifier_health_gel", 'items/health_gel/modifiers/modifier_health_gel', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_health_gel"
end
