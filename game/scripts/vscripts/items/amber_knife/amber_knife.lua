item_amber_knife = item_amber_knife or class({})
local ability = item_amber_knife

LinkLuaModifier("modifier_amber_knife", 	  "items/amber_knife/modifiers/modifier_amber_knife", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_amber_knife_invis", "items/amber_knife/modifiers/modifier_amber_knife_invis", LUA_MODIFIER_MOTION_NONE)

function item_amber_knife:GetIntrinsicModifierName()
	return "modifier_amber_knife"
end

function item_amber_knife:OnSpellStart()
	local caster 	= self:GetCaster()
	local duration  = self:GetSpecialValueFor("invis_duration")
	local fadeTime  = self:GetSpecialValueFor("invis_fadetime")

	local part = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_ti9/dazzle_shadow_wave_ti9_crimson_impact_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

	ParticleManager:SetParticleControl(part, 0, caster:GetOrigin())
	ParticleManager:SetParticleControl(part, 1, caster:GetOrigin())
	ParticleManager:SetParticleControl(part, 2, caster:GetOrigin())

	ParticleManager:ReleaseParticleIndex(part)

	Timers:CreateTimer(fadeTime, function()
		local part = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(part, 0, caster:GetOrigin())
		ParticleManager:ReleaseParticleIndex(part)

		caster:AddNewModifier(caster, self, "modifier_amber_knife_invis", { duration = duration })
	end)

	caster:EmitSound("Item_AmberKnife.Cast")
end