abyss_warrior_fallen_hero = abyss_warrior_fallen_hero or class({})

local ability = abyss_warrior_fallen_hero

LinkLuaModifier( "modifier_abyss_warrior_fallen_hero", 'creeps/boss/abyss_warrior/modifiers/modifier_abyss_warrior_fallen_hero', LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_abyss_warrior_fallen_hero"
end