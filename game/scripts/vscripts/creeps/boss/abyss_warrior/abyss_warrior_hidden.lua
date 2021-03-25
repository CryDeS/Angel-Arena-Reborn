abyss_warrior_hidden = abyss_warrior_hidden or class({})

local ability = abyss_warrior_hidden

LinkLuaModifier( "modifier_abyss_warrior_hidden", 'creeps/boss/abyss_warrior/modifiers/modifier_abyss_warrior_hidden', LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_abyss_warrior_hidden"
end

