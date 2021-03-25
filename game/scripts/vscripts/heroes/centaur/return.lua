centaur_return = class({})
LinkLuaModifier( "modifier_centaur_return_custom", 		'heroes/centaur/modifiers/modifier_centaur_return_custom', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_aura", 'heroes/centaur/modifiers/modifier_centaur_return_custom_aura', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function centaur_return:GetIntrinsicModifierName()
	return "modifier_centaur_return_custom"
end

