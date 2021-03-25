boss_shield = class({})
LinkLuaModifier("modifier_boss_shield", "creeps/boss/modifier_boss_shield", LUA_MODIFIER_MOTION_NONE)

function boss_shield:GetIntrinsicModifierName()
	return "modifier_boss_shield"
end