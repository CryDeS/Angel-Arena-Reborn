spider_two_invis = class({})
LinkLuaModifier( "modifier_spider_two_invis", 'creeps/abilities/modifiers/modifier_spider_two_invis', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spider_two_invis_debuff", 'creeps/abilities/modifiers/modifier_spider_two_invis_debuff', LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function spider_two_invis:OnSpellStart( keys )
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_spider_two_invis", {duration = duration})
	caster:AddNewModifier(caster, self, "modifier_invisible", {duration = duration})

	local fx = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_darkclaw/dazzle_darkclaw_poison_touch_fade.vpcf", PATTACH_ABSORIGIN, nil)
	ParticleManager:SetParticleControl(fx, 3, caster:GetAbsOrigin() )
end
