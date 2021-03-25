forgotten_hero_breach = forgotten_hero_breach or class({})

local ability = forgotten_hero_breach

LinkLuaModifier( "modifier_forgotten_hero_breach", "heroes/forgotten_hero/modifiers/modifier_forgotten_hero_breach", LUA_MODIFIER_MOTION_NONE )

function ability:OnSpellStart( kv )
	if not IsServer() then return end

	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("duration") + caster:GetTalentSpecialValueFor("forgotten_hero_talent_breach_duration")

	local fadeTime = self:GetSpecialValueFor("fade_time")

	ParticleManager:CreateParticle("particles/heroes/forgotten_hero/breach/breach_start.vpcf", PATTACH_ABSORIGIN, caster)

	Timers:CreateTimer(fadeTime, function()
		caster:AddNewModifier(caster, self, "modifier_forgotten_hero_breach", { duration = duration })
	end)

	caster:EmitSound("Hero_ForgottenHero.Breach.Cast")
end