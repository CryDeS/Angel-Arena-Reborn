item_plague_staff = class({})
LinkLuaModifier( "modifier_plague_staff", 'items/plague_staff/modifiers/modifier_plague_staff', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function item_plague_staff:GetIntrinsicModifierName()
	return "modifier_plague_staff"
end
