item_wisdom_shard = item_wisdom_shard or class({})
local ability = item_wisdom_shard

LinkLuaModifier("modifier_item_wisdom_shard", 'items/wisdom_shard/modifiers/modifier_item_wisdom_shard', LUA_MODIFIER_MOTION_NONE)

function ability:GetIntrinsicModifierName()
	return "modifier_item_wisdom_shard"
end
