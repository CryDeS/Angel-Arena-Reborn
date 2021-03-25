abyss_warrior_immortal = abyss_warrior_immortal or class({})

local ability = abyss_warrior_immortal

LinkLuaModifier( "modifier_abyss_warrior_immortal", 'creeps/boss/abyss_warrior/modifiers/modifier_abyss_warrior_immortal', LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_abyss_warrior_immortal"
end