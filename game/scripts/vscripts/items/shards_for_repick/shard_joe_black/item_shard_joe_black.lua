item_shard_joe_black = item_shard_joe_black or class({})
item_shard_joe_black_dummy = item_shard_joe_black
LinkLuaModifier("modifier_item_shard_joe_black", 'items/shards_for_repick/shard_joe_black/modifier_item_shard_joe_black', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_shard_joe_black_active", 'items/shards_for_repick/shard_joe_black/modifier_item_shard_joe_black_active', LUA_MODIFIER_MOTION_NONE)

item_shard_joe_black.ForceShareable = true

--------------------------------------------------------------------------------

function item_shard_joe_black:GetIntrinsicModifierName()
	return "modifier_item_shard_joe_black"
end

--------------------------------------------------------------------------------

function item_shard_joe_black:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_item_shard_joe_black_active", { duration = duration })
end