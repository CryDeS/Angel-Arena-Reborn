forgotten_hero_meditation = forgotten_hero_meditation or class({})

local ability = forgotten_hero_meditation

local talentName = "forgotten_hero_talent_meditation_damage_buff"

LinkLuaModifier( "modifier_forgotten_hero_meditation", "heroes/forgotten_hero/modifiers/modifier_forgotten_hero_meditation", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_forgotten_hero_meditation_buff", "heroes/forgotten_hero/modifiers/modifier_forgotten_hero_meditation_buff", LUA_MODIFIER_MOTION_NONE )

function ability:GetChannelTime()
	return self:GetSpecialValueFor("duration")
end

function ability:OnSpellStart( kv )
	if not IsServer() then return end

	local caster = self:GetCaster()

	self.mod = caster:AddNewModifier(caster, self, "modifier_forgotten_hero_meditation", { duration = -1 })

	caster:EmitSound("Hero_ForgottenHero.Meditation.Start")

	self.part = ParticleManager:CreateParticle("particles/heroes/forgotten_hero/meditation/streaks.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
end

function ability:OnChannelFinish( bInterrupted )
	if not IsServer() then return end 

	if self.part ~= nil then
		ParticleManager:DestroyParticle(self.part, false)
		self.part = nil
	end

	local mod = self.mod

	if mod then
		mod:Destroy()

		self.mod = nil
	end

	local caster = self:GetCaster()

	if not bInterrupted and caster:HasTalent(talentName) then
		local duration = caster:GetTalentSpecialValueFor(talentName, "duration")
		
		caster:AddNewModifier(caster, self, "modifier_forgotten_hero_meditation_buff", { duration = duration })
	end

	ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_spring_cast_rays.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	caster:EmitSound("Hero_ForgottenHero.Meditation.End")
	caster:StopSound("Hero_ForgottenHero.Meditation.Start")
end 