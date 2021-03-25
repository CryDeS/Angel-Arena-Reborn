require('items/second_attacks')

item_dark_edge = item_dark_edge or class({})
local ability = item_dark_edge

LinkLuaModifier("modifier_dark_edge", 			"items/dark_edge/modifier_dark_edge", 					LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_edge_invis", 	"items/dark_edge/modifier_dark_edge_invis", 			LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_edge_cd", 		"items/dark_edge/modifier_dark_edge_cd", 				LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_edge_debuff", 	"items/dark_edge/modifier_dark_edge_debuff", 			LUA_MODIFIER_MOTION_NONE)

MeleeSecondAttack:RegisterSecondAttack("modifier_dark_edge_cd")

function ability:GetIntrinsicModifierName()
	return "modifier_dark_edge"
end

function ability:OnSpellStart()
	local caster = self:GetCaster()
	local duration  = self:GetSpecialValueFor("windwalk_duration")
	local fadeTime = self:GetSpecialValueFor("windwalk_fadeTime")

	local part = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9_crimson_impact_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

	ParticleManager:SetParticleControl(part, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(part, 1, caster:GetOrigin())
	ParticleManager:SetParticleControl(part, 2, caster:GetOrigin())
	ParticleManager:ReleaseParticleIndex(part)

	Timers:CreateTimer(fadeTime, function()
		local inv_part = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(inv_part, 0, caster:GetOrigin())
		ParticleManager:ReleaseParticleIndex(inv_part)

		caster:AddNewModifier(caster, self, "modifier_dark_edge_invis", {duration=duration})
		return nil
	end)

	caster:EmitSound("Item_DarkEdge.Cast")
end