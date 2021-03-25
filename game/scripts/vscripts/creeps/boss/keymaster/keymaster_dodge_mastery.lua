keymaster_dodge_mastery = keymaster_dodge_mastery or class({})

local ability = keymaster_dodge_mastery

LinkLuaModifier( "modifier_keymaster_dodge_mastery", 'creeps/boss/keymaster/modifiers/modifier_keymaster_dodge_mastery', LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_keymaster_dodge_mastery"
end