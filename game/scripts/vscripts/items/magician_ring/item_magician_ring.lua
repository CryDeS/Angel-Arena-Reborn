item_magician_ring = class({})
LinkLuaModifier( "modifier_item_magician_ring", 'items/magician_ring/modifiers/modifier_item_magician_ring', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_magician_ring_buff", 'items/magician_ring/modifiers/modifier_item_magician_ring_buff', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_magician_ring:GetIntrinsicModifierName()
	return "modifier_item_magician_ring"
end
