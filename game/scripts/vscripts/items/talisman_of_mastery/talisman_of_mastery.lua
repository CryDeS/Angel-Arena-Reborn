item_talisman_of_mastery = item_talisman_of_mastery or class({})

LinkLuaModifier( "modifier_talisman_of_mastery", 'items/talisman_of_mastery/modifiers/modifier_talisman_of_mastery', LUA_MODIFIER_MOTION_NONE )

function item_talisman_of_mastery:GetIntrinsicModifierName()
	return "modifier_talisman_of_mastery"
end
