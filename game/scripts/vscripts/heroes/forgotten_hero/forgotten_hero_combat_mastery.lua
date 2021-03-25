forgotten_hero_combat_mastery = forgotten_hero_combat_mastery or class({})

local ability = forgotten_hero_combat_mastery

LinkLuaModifier( "modifier_forgotten_hero_combat_mastery", 			"heroes/forgotten_hero/modifiers/modifier_forgotten_hero_combat_mastery", 			LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_forgotten_hero_combat_mastery_disarmor", "heroes/forgotten_hero/modifiers/modifier_forgotten_hero_combat_mastery_disarmor", 	LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_forgotten_hero_combat_mastery_damage", 	"heroes/forgotten_hero/modifiers/modifier_forgotten_hero_combat_mastery_damage", 	LUA_MODIFIER_MOTION_NONE )

function ability:GetIntrinsicModifierName()
	return "modifier_forgotten_hero_combat_mastery"
end
