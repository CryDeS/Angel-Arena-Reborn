item_shard_huntress = item_shard_huntress or class({})
item_shard_huntress_dummy = item_shard_huntress

LinkLuaModifier("modifier_item_shard_huntress", 'items/shards_for_repick/shard_huntress/modifier_item_shard_huntress', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_shard_huntress_buff", 'items/shards_for_repick/shard_huntress/modifier_item_shard_huntress_buff', LUA_MODIFIER_MOTION_NONE)

item_shard_huntress.ForceShareable = true
--------------------------------------------------------------------------------
function item_shard_huntress:GetIntrinsicModifierName()
	return "modifier_item_shard_huntress"
end

function item_shard_huntress:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_item_shard_huntress_buff", { duration = self:GetSpecialValueFor("duration") })
end
